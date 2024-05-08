import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12

Window {
    id: rootId
    visible: true
    width: 1920
    height: 1080
    title: qsTr("Title") + Translation.m_language

    signal statusChanged

    Image{
        id: backgroundId
        source: "qrc:mediaBut/background.jpg"
//        source: mediaInfo.opacityBackground
//        width: parent.width
//        height: parent.height
//        opacity: 0.6
//        fillMode: Image.PreserveAspectCrop

    }

    // blur the background if using album_art for background
//    FastBlur {
//        anchors.fill: backgroundId
//        source: backgroundId
//        radius: 100
//        cached: true
//    }


    AppHeader{
        id: headerId
        width: playlistId.opened || lyricsId.opened ? parent.width * 2 / 3 : parent.width
        anchors.left: parent.left
        anchors.leftMargin: playlistId.opened ? playlistId.width : 0
        anchors.right: parent.right
        anchors.rightMargin: lyricsId.opened ? lyricsId.width : 0

        onOpenPlaylist: {
            if(playlistStatus){
                playlistId.visible = true
            }
            else{
                playlistId.visible = false
            }
        }

        onOpenLyrics: {
            if(lyricsStatus){
                lyricsId.visible = true
            }
            else{
                lyricsId.visible = false
            }
        }
    }

    MusicPlaylist{
        id: playlistId
        modal: false
        onOpened: {
            headerId.playlistStatus = true
            headerId.statusPlaylistChanged()
            if(headerId.lyricsStatus){
                headerId.closeLyrics()
            }
        }

        onCurrentIndexChanged: {
            mediaInfo.currentIndex = currentIndex
        }
    }

    MediaLyrics{
        id: lyricsId
        modal: false
        visible: headerId.lyricsStatus
        onOpened: {
            if(headerId.playlistStatus){
                headerId.closePlaylist()
            }
        }
        nameLyric: mediaInfo.lyric
    }

    Connections{
        target: playlistId
        onOpened: {
            if(lyricsId.visible === true){
                lyricsId.visible = false
            }
        }
    }
    Connections{
        target: lyricsId
        onOpened: {
            if(playlistId.visible === true){
                playlistId.visible = false
            }
        }
    }

    MediaPlayer{
        id: mediaInfo
        anchors.top: headerId.bottom
        x: playlistId.opened ? playlistId.width : 0
        width: playlistId.opened || lyricsId.opened ? parent.width * 2 / 3 : parent.width
    }

}
