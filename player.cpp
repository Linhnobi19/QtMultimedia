#include "player.h"
#include "playlistmodel.h"

#include <QMediaService>
#include <QMediaPlaylist>
#include <QMediaMetaData>
#include <QObject>
#include <QFileInfo>
#include <QTime>
#include <QDir>
#include <QStandardPaths>
#include <math.h>
#include <taglib/unsynchronizedlyricsframe.h>

Player::Player(QObject *parent)
    :QObject(parent)
{
    m_player = new QMediaPlayer(this);
    m_playlist = new QMediaPlaylist(this);
    m_player->setPlaylist(m_playlist);
    m_playlistModel = new PlaylistModel(this);
    open();
    if (!m_playlist->isEmpty()) {
        m_playlist->setCurrentIndex(0);
    }
}

void Player::random()
{
    int randomIndex = floor(((double) rand()/RAND_MAX) * m_playlist->mediaCount());

    while (randomIndex == m_playlist->currentIndex()) {
        randomIndex = floor((double)rand()/RAND_MAX)* m_playlist->mediaCount();
    }
    m_player->playlist()->setCurrentIndex(randomIndex);
    m_player->play();
}

void Player::playloop()
{
    m_playlist->setPlaybackMode(QMediaPlaylist::CurrentItemInLoop);
}

void Player::open()
{
    // set the dir to music folder for loading song into playlist
    QDir directory(QStandardPaths::standardLocations(QStandardPaths::MusicLocation)[0]);
    location = directory.absolutePath();

    // find mp3 file to add link to playlist
    QFileInfoList songs = directory.entryInfoList(QStringList() << "*.mp3",QDir::Files);
    QList<QUrl> urls;
    for(int i = 0; i < songs.length(); i++){
        urls.append(QUrl::fromLocalFile(songs[i].absoluteFilePath()));
    }
    addPlaylist(urls);
}

void Player::addPlaylist(const QList<QUrl> &urls)
{
    for (auto &url: urls) {
        m_playlist->addMedia(url);
        FileRef f(url.path().toStdString().c_str());
        Tag *tag = f.tag();     // in4 about this link, represent in4 like: title, singer,...
        Song song(QString::fromWCharArray(tag->title().toCWString()),
                  QString::fromWCharArray(tag->artist().toCWString()),
                  url.toDisplayString(),
                  getLyric(url),
                  getAlbumArt(url));
        m_playlistModel->addSong(song);

    }
}

QString Player::getLyric(QUrl url)
{
    TagLib::MPEG::File f1(url.path().toStdString().c_str());
    TagLib::ID3v2::FrameList frames = f1.ID3v2Tag()->frameListMap()["USLT"];
    TagLib::ID3v2::UnsynchronizedLyricsFrame *frame = nullptr;
    QString lyrics;
    for (TagLib::ID3v2::FrameList::Iterator it = frames.begin(); it != frames.end(); ++it) {
        frame = dynamic_cast<TagLib::ID3v2::UnsynchronizedLyricsFrame *>(*it);
        if (frame) {
            lyrics = QString::fromStdWString(frame->text().toWString());
        }
    }


    return lyrics.toUtf8().constData();
}

QString Player::getAlbumArt(QUrl url)
{
    static const char *IdPicture = "APIC" ;
    TagLib::MPEG::File mpegFile(url.path().toStdString().c_str());
    TagLib::ID3v2::Tag *id3v2tag = mpegFile.ID3v2Tag();
    TagLib::ID3v2::FrameList Frame ;
    TagLib::ID3v2::AttachedPictureFrame *PicFrame ;
    void *SrcImage ;
    unsigned long Size ;

    FILE *jpegFile;
    jpegFile = fopen(QString(url.fileName()+".jpg").toStdString().c_str(),"wb");

    if ( id3v2tag )
    {
        // picture frame
        Frame = id3v2tag->frameListMap()[IdPicture] ;
        if (!Frame.isEmpty() )
        {
            for(TagLib::ID3v2::FrameList::ConstIterator it = Frame.begin(); it != Frame.end(); ++it)
            {
                PicFrame = static_cast<TagLib::ID3v2::AttachedPictureFrame*>(*it) ;
                  if ( PicFrame->type() ==
                TagLib::ID3v2::AttachedPictureFrame::FrontCover)
                {
                    // extract image (in it’s compressed form)
                    Size = PicFrame->picture().size() ;
                    SrcImage = malloc ( Size ) ;
                    if ( SrcImage )
                    {
                        memcpy ( SrcImage, PicFrame->picture().data(), Size ) ;
                        fwrite(SrcImage,Size,1, jpegFile);
                        fclose(jpegFile);
                        free( SrcImage ) ;
                        return QUrl::fromLocalFile(url.fileName()+".jpg").toDisplayString();
                    }

                }
            }
        }
    }
    else
    {
        qDebug() <<"id3v2 not present";
        return "qrc:mediaBut/album_art.png";
    }
    return "qrc:mediaBut/album_art.png";
}

QString Player::getTime(qint64 currentInfo)
{
    QString tStr = "00:00";
    currentInfo = currentInfo/1000;
    qint64 duration = m_player->duration()/1000;    // use for fomat time
    if(duration || currentInfo){
        // set up h, m, s, ms for time and h must in range 0-23,...
        QTime currentTime((currentInfo / 3600) % 24, (currentInfo / 60) % 60
                          , currentInfo % 60, (currentInfo * 1000) % 1000);

        QString format = "mm:ss";
        if(duration > 3600){
            format = "hh::mm:ss";
        }
        tStr = currentTime.toString(format);
    }
    return tStr;
}



