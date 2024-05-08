import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: rootId
    height: 60
    anchors.top: parent.top
//    anchors.left: parent.left
    // property and signal for playlist
    signal openPlaylist     // signal for click Button
    property bool playlistStatus: playlistButton.status
    signal statusPlaylistChanged    // signal for drag drwer

    // property and signal for lyrics
    property bool lyricsStatus: lyricsButton.status
    signal openLyrics
    signal closeLyrics
    signal closePlaylist


    // drawer button and back button
    SwitchButton{
        id: playlistButton
        icon_off: "qrc:mediaBut/drawer_p.png"
        icon_on: "qrc:mediaBut/back.png"
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 10
        onClicked: {
            playlistStatus = status
            openPlaylist()
        }
    }

    onStatusPlaylistChanged: {
        playlistButton.status = true
    }

    // text header show name of the app
    Text {
        id: textHeader
        text: qsTr("Appheader") + Translation.m_language
        anchors.centerIn: parent
        font.pointSize: 18
        color: "black"
        font.bold: true
        font.italic: true
    }

    // flag for convert languages
    Image {
        id: vnFlag
        source: "qrc:mediaBut/vn.png"
        width: 50
        height: 50
        anchors.right: lyricsButton.left
        anchors.rightMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        scale:  mouseArea1.containsMouse ? 1.1 : 1.0
        smooth: mouseArea1.containsMouse

        Rectangle{
            id: borderVnFlag
            width: parent.width
            height: parent.height * 3/5
            border.color: "black"
            border.width: 3
            color: "transparent"
            visible: true
            anchors.centerIn: parent
        }

        MouseArea {
            id: mouseArea1
            anchors.fill: parent
            hoverEnabled: true         //this line will enable mouseArea.containsMouse
            onClicked: {
                Translation.selectLanguage("vn")
            }
        }
    }

    Image {
        id: usFlag
        source: "qrc:mediaBut/us.png"
        width: 50
        height: 50
        anchors.right: vnFlag.left
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        scale:  mouseArea2.containsMouse ? 1.1 : 1.0
        smooth: mouseArea2.containsMouse

        Rectangle{
            id: borderUsFlag
            width: parent.width
            height: parent.height * 3/5
            border.color: "black"
            border.width: 3
            color: "transparent"
            visible: true
            anchors.centerIn: parent
        }
        MouseArea {
            id: mouseArea2
            anchors.fill: parent
            hoverEnabled: true         //this line will enable mouseArea.containsMouse
            onClicked: {
                Translation.selectLanguage("us")
            }
        }
    }

    SwitchButton{
        id: lyricsButton
        icon_off: "qrc:mediaBut/drawer_p.png"
        icon_on: "qrc:mediaBut/close.png"
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 10
        onClicked: {
            lyricsStatus = status
            openLyrics()
        }
    }

    onCloseLyrics: {
        lyricsButton.status = false
    }
    onClosePlaylist: {
        playlistButton.status = false
    }

}
