#ifndef PLAYER_H
#define PLAYER_H

#include <QMediaPlayer>
#include <QMediaPlaylist>
#include <taglib/tag.h>
#include <taglib/fileref.h>
#include <taglib/id3v2tag.h>
#include <taglib/mpegfile.h>
#include <taglib/id3v2frame.h>
#include <taglib/id3v2header.h>
#include <taglib/attachedpictureframe.h>

QT_BEGIN_NAMESPACE
class QAbstractItemView;
class QMediaPlayer;
QT_END_NAMESPACE

class PlaylistModel;

using namespace TagLib;

class Player : public QObject
{
    Q_OBJECT
public:
    explicit Player(QObject *parent = nullptr);

    void addPlaylist(const QList<QUrl> &urls);
    Q_INVOKABLE void random();
    Q_INVOKABLE void playloop();

public slots:
    void open();
    QString getTime(qint64 currentInfo);

public:
    QString getLyric(QUrl url);
    QString getAlbumArt(QUrl url);

    QMediaPlayer *m_player = nullptr;
    QMediaPlaylist * m_playlist = nullptr;
    PlaylistModel *m_playlistModel = nullptr;
    QString location = "";
};

#endif // PLAYER_H
