import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.1
import QtMultimedia 5.9


Item {
    id: rootId
    width: parent.width
    height: parent.height

    property string lyric: album.currentItem.myData.m_lyric
    property string opacityBackground: album.currentItem.myData.m_album_art
    property int currentIndex: album.currentIndex

    onCurrentIndexChanged: {
        album.currentIndex = rootId.currentIndex
    }


    PathView{
            id: album
            width: parent.width
            implicitHeight: 250
            anchors.top: parent.top
            anchors.left: parent.left
            pathItemCount: 3
            model: playlistModel
            delegate: delegateId
            currentIndex: 0
            property int beginX: centerX - currentItem.width -100
            property int centerX: parent.width/2
            property int endX: centerX + currentItem.width + 100
            property int cordinateY: 125

            path: Path{
                startX: album.beginX; startY: album.cordinateY
                PathAttribute { name: "iconScale"; value: 0.5 }
                PathAttribute { name: "iconOpacity"; value: 0.5 }
                PathLine {
                    x: album.centerX; y: album.cordinateY
                }
                PathAttribute { name: "iconScale"; value: 1.0 }
                PathAttribute { name: "iconOpacity"; value: 1.0 }
                PathLine{
                    x: album.endX; y: album.cordinateY
                }
                PathAttribute { name: "iconScale"; value: 0.5 }
                PathAttribute { name: "iconOpacity"; value: 0.5 }

            }
            preferredHighlightBegin: 0.5
            preferredHighlightEnd: 0.5
            focus: true

            onCurrentIndexChanged: {
//                playlist.currentIndex = currentIndex
                player.playlist.currentIndex = currentIndex
                textAni.targets = [nameOfArtist, nameOfSong]
                textAni.restart()

            }
        }

        Component{
            id: delegateId
            Item {
                id: imgContainer
                width: 220
                height: 220

                // to put in delegate not in pathview because each component also have data
                property variant myData: model
                scale: PathView.iconScale
                opacity: PathView.iconOpacity
                Image {
                    id: imgId
                    source: m_album_art
                    width: parent.width
                    height: parent.height
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        album.currentIndex = index
                        player.play()
                    }
                }
            }
        }

    Text {
        id: nameOfSong
        anchors.horizontalCenter: album.horizontalCenter
        text: album.currentItem.myData.m_title
        anchors.top: album.bottom
        anchors.topMargin: 20
        color: "black"
        font.bold: true
        font.pointSize: 22
    }

    Text {
        id: nameOfArtist
        text: album.currentItem.myData.m_singer
        anchors.horizontalCenter: nameOfSong.horizontalCenter
        anchors.top: nameOfSong.bottom
        color: "black"
        font.pointSize: 18
    }

    NumberAnimation{
        id: textAni
        property: "opacity"
        from: 0
        to: 1
        duration: 3000
        easing.type: Easing.InOutQuad
    }


    // slider
    Slider{
        id: timerSlider
        width: 900
        Layout.minimumWidth: 200
        anchors.top: nameOfArtist.bottom
        anchors.topMargin: 40
        anchors.horizontalCenter: nameOfArtist.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        from: 0
        to: player.duration
        value: player.position
        background: Rectangle {
            id: bgSlider
            width: timerSlider.availableWidth
            x: timerSlider.leftPadding
            height: 4
            radius: 2
            color: "black"
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                id: visualSlider
                width: timerSlider.visualPosition * parent.width
                height: 4
                radius: 2
                color: "#4af0df"
            }
        }

        handle: Image {
            id: point
//            y: parent.padding
            x: parent.leftPadding + parent.visualPosition * (parent.availableWidth ) - point.width / 2
            anchors.verticalCenter: parent.verticalCenter
            source: "mediaBut/point.png"
        }
        onMoved: {
            if(player.seekable){
//                player.setPosition(Math.floor(timerSlider.visualPosition * player.duration))
                player.setPosition(timerSlider.visualPosition * player.duration)
            }
        }
    }

    // time
    Text {
        id: durationTime
        text: utility.getTime(player.position)
        anchors.verticalCenter: timerSlider.verticalCenter
        anchors.right: timerSlider.left
        anchors.rightMargin: 20
        font.pointSize: 16
    }

    Text {
        id: totalTime
        text: utility.getTime(player.duration)
        anchors.verticalCenter: timerSlider.verticalCenter
        anchors.left: timerSlider.right
        anchors.leftMargin: 20
        font.pointSize: 16
    }


    // Media Control
    ButtonControl{
        id: playButton
        anchors.horizontalCenter: mediaInfo.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 200
        property bool status: player.state === MediaPlayer.PlayingState ? true : false
//        property bool status: false

        icon_default: playButton.status ? "mediaBut/play.png" : "mediaBut/pause"
        icon_pressed: playButton.status ? "mediaBut/hold-play.png" : "mediaBut/hold-pause"
        icon_released: playButton.status ? "mediaBut/play.png" :"mediaBut/pause.png"

        onClicked: {
            if(player.state !== MediaPlayer.PlayingState) {
                player.play()
            }
            else {
                player.pause()
            }
        }

        onReleased: {
            playButton.status = !playButton.status
            playButton.source = icon_released
        }

        Connections {
            target: player
            onStateChanged: {
                playButton.source = player.state === MediaPlayer.PlayingState ? "mediaBut/play.png" : "mediaBut/pause.png"
            }
        }
    }

    ButtonControl{
        id: prevBut
        anchors.right: playButton.left
        anchors.verticalCenter: playButton.verticalCenter
        anchors.rightMargin: 30
        icon_default: "mediaBut/prev.png"
        icon_pressed: "mediaBut/hold-prev.png"
        icon_released: "mediaBut/prev.png"

        onClicked: {
            if(shuffer.status === true){
                utility.random()
            }
            else {
                playlist.playbackMode = Playlist.Sequential
                if(album.currentIndex > 0){
                    playlist.previous()
                }
                else {
                    playlist.setCurrentIndex(album.count - 1)
                }
            }
        }

        onReleased: {
            prevBut.source = icon_released
        }
    }

    ButtonControl {
        id: nextBut
        anchors.left: playButton.right
        anchors.verticalCenter: playButton.verticalCenter
        anchors.leftMargin: 30
        icon_default: "mediaBut/next.png"
        icon_pressed: "mediaBut/hold-next.png"
        icon_released: "mediaBut/next.png"

        onClicked: {
            if(shuffer.status === true){
                utility.random()
            }
            else {
                playlist.playbackMode = Playlist.Sequential
                if(album.currentIndex < album.count - 1){
                    playlist.next()
                }
                else {
                    playlist.setCurrentIndex(0)
                }
                player.play()
            }
        }

        onReleased: {
            nextBut.source = icon_released
        }
    }

    SwitchButton{
        id: shuffer
        anchors.right: prevBut.left
        anchors.rightMargin: 40
        anchors.verticalCenter: playButton.verticalCenter
        icon_off: "mediaBut/shuffle.png"
        icon_on: "mediaBut/shuffle-1.png"
    }

    SwitchButton{
        id: repeater
        anchors.left: nextBut.right
        anchors.leftMargin: 40
        anchors.verticalCenter: playButton.verticalCenter
        icon_off: "mediaBut/repeat.png"
        icon_on: "mediaBut/repeat-1.png"
//        status: player.playlist.playbackMode === Playlist.Loop ? 1 : 0

        onClicked: {
            if(repeater.status === true){
                console.log("loop button was pressed")
                utility.playloop()
            }
            else {
                player.playlist.playbackMode = Playlist.Sequential
            }
        }
    }


    // volume slider
    Slider{
        id: volumeId
        width: 400
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 100
        anchors.horizontalCenter: parent.horizontalCenter
        from: 0
        to: 100
        value: player.volume

        background: Rectangle {
            width: volumeId.availableWidth
            height: 5
            x: volumeId.leftPadding
            y: volumeId.availableHeight / 2 - height / 2 + volumeId.topPadding
            color: "#e6e6e6"
            radius: 2

            Rectangle{
                width: volumeId.visualPosition * volumeId.availableWidth
                height: 5
                color: "#4da6ff"
            }
        }

        onValueChanged: {
            player.setVolume(volumeId.value)
        }
    }

    Image {
        id: downVol
        width: 50
        height: 50
        source: volumeId.value !== 0 ? "mediaBut/volumn_down.png" : "mediaBut/mute_button.png"
        anchors.verticalCenter: volumeId.verticalCenter
        anchors.right: volumeId.left
        anchors.rightMargin: 10
        MouseArea{
            anchors.fill: parent
            onClicked: {
                if(volumeId.value !== 0){
                    volumeId.value -= 5
                }

            }
        }
    }

    Image{
        id: upVol
        width: 50
        height: 50
        source: "mediaBut/volumn_up.png"
        anchors.verticalCenter: volumeId.verticalCenter
        anchors.left: volumeId.right
        anchors.leftMargin: 10
        MouseArea{
            anchors.fill: parent
            onClicked: {
                if(volumeId.value !== 100){
                    volumeId.value += 5
                }
            }
        }
    }

    // connection for clicking on MusicPlaylist will cause playlist index changed
//    Connections {
//        target: playlist
//        onCurrentIndexChanged: {
//            album.currentIndex = index
//        }
//    }


}
