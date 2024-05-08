import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Drawer{
    id: rootId

    interactive: true
    dragMargin: 10
    clip: true
    closePolicy: Popup.NoAutoClose
    width: parent.width * 1/4
    height: parent.height
    background: Rectangle {
        anchors.fill: parent
        color: "#ddeff1"
    }

    // the alternative solution for Connections
    // use for change to another song in playlist that want to connect to the song in media Player.
    property int currentIndex: playlistSong.currentIndex


    ListView {
        id: playlistSong
        width: parent.width
        height: parent.height
        model: playlistModel
        spacing: 2
        currentIndex: 0
        headerPositioning: ListView.OverlayHeader // fixed position of the header
        property int animationWidth: 50

        header: Rectangle{
            width: playlistSong.width + playlistSong.spacing
            height: 80
            z: 2
            color: "#acadac"
            Text {
                id: drawerHeder
                text: qsTr("Header") + Translation.m_language
                font.pointSize: 22
                color: "black"
                font.bold: true
                anchors.left: parent.left
                anchors.leftMargin: 10
            }
            Text {
                id: locationText
                text: "Location: " + location
                font.pointSize: 16
                font.italic: true
                anchors.top: drawerHeder.bottom
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 10
            }
            Image {
                id: musicImg
                source: "qrc:mediaBut/music.png"
                anchors.right: countSong.left
                anchors.rightMargin: 5
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                id: countSong
                text: playlistSong.count
                font.pointSize: 20
                font.bold: true
                color: "white"
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            MouseArea{
                anchors.fill: parent    // that make sense when you click to it, it don't go through and click the song after
            }
        }

        delegate: MouseArea{
            // Define each mouse Area for each song
            implicitWidth: playlistSong.width
            implicitHeight: 120     // if set height is playlistSongItem.height, it will set the default height of the image

            Image {
                id: playlistItem
                source: "qrc:mediaBut/playlist.jpg"
                width: parent.width
                height: parent.height
                opacity: 0.7
            }

            Image {
                id: avaSong
                source: m_album_art
                width: 100
                height: 100
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: nameOfSong
                text: m_title
                width: parent.width - x - playlistSong.animationWidth - 10 // 10 here is the margin between text and animation
                elide: Text.ElideRight

                // define anchors
                anchors.left: avaSong.right
                anchors.leftMargin: 5
                y: parent.height/2 - height - 10
                font.pointSize: 16
                font.bold: true
            }

            Text {
                id: singerOfSong
                text: m_singer
                width: nameOfSong.width
                anchors.left: avaSong.right
                anchors.leftMargin: 5
                y: parent.height/2
                font.pointSize: 16
                clip: true
            }


            onClicked: {
//                playlistSong.currentIndex = index
                player.playlist.currentIndex = index
                player.play()
                rootId.currentIndex = index

            }
            onPressed: {
                playlistItem.source = "qrc:mediaBut/hold.png"
            }
            onCanceled: {
                playlistItem.source = "qrc:mediaBut/playlist.jpg"
            }
            onReleased: {
                playlistItem.source = "qrc:mediaBut/playlist.jpg"
            }

        }

        highlight: Image{
            source: "qrc:mediaBut/playlist.jpg"
            //playing gif file
            Rectangle {
                width: animation.width; height: animation.height + 8
                color: "transparent"
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter

                AnimatedImage {
                    id: animation
                    source: "qrc:mediaBut/playing.gif"
                    cache: false
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                    width: playlistSong.animationWidth
                    height: 50
                }
            }
        }
    }


    // connection when click on mediaPlayer it will cause change the index in playlist
    Connections {
        target: playlist
        onCurrentIndexChanged: {
            playlistSong.currentIndex = index
        }
    }

}
