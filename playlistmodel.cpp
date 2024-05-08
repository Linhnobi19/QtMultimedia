#include "playlistmodel.h"
#include <QFileInfo>
#include <QUrl>
#include <QMediaPlaylist>
#include <math.h>


PlaylistModel::PlaylistModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int PlaylistModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_data.count();
}

QVariant PlaylistModel::data(const QModelIndex &index, int role) const
{
    if(index.row() < 0 || index.row() >= m_data.count()){
        return QVariant();
    }

    // define the song you want to get
    const Song &song = m_data[index.row()];

    // define which role you want to get for specific song
    if(role == TitleRole){
        return song.title();
    }
    else if(role == SingerRole){
        return song.singer();
    }
    else if(role == SourceRole){
        return song.source();
    }
    else if(role == LyricRole){
        return song.lyric();
    }
    else if(role == AlbumArtRole){
        return song.album_art();
    }
    else return QVariant();

}

void PlaylistModel::addSong(Song &song)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_data << song;
    endInsertRows();
}

QHash<int, QByteArray> PlaylistModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    // define name of the column we use in QML
    roles[TitleRole] = "m_title";
    roles[SingerRole] = "m_singer";
    roles[SourceRole] = "m_source";
    roles[LyricRole] = "m_lyric";
    roles[AlbumArtRole] = "m_album_art";

    return roles;
}

Song::Song(const QString &title, const QString &singer, const QString &source, const QString &lyric, const QString &album_art)
{
    m_title = title;
    m_singer = singer;
    m_source = source;
    m_lyric = lyric;
    m_album_art = album_art;
}

QString Song::title() const
{
    return m_title;
}

QString Song::singer() const
{
    return m_singer;
}

QString Song::source() const
{
    return m_source;
}

QString Song::lyric() const {
    return m_lyric;
}

QString Song::album_art() const
{
    return m_album_art;
}
