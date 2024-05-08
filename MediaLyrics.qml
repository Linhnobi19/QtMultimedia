import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Drawer{
    id: rootId
    interactive: false
    dragMargin: 10
    clip: true
    closePolicy: Popup.NoAutoClose
    width: parent.width * 1/3
    height: parent.height
    edge: Qt.RightEdge
    background: Rectangle {
        id: lyricsBackground
        color: "black"
        opacity: 0.5
        radius: 20
    }

    property string nameLyric: ""

    Rectangle {
        id: containerRect
        width: availableWidth
        height: availableHeight
        color: "transparent"
//        color: "blue"
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30

        Flickable {
            anchors.fill: parent

            // Don't set contentWidth to lock horizontal dragging ability
            contentHeight: textItem.height
            boundsBehavior: Flickable.StopAtBounds          // Just can flick inside the lyric tab
            boundsMovement: Flickable.StopAtBounds
            flickDeceleration: Flickable.AutoFlickIfNeeded
            interactive: true                   // turn on flick and scroll ability

            Text {
                id: textItem
                width: parent.width - 20
                text: nameLyric === "" ? qsTr("Lyric") + Translation.m_language : nameLyric
                wrapMode: Text.WordWrap     // if the line text over containerRect width --> auto down for new line
                font.pointSize: 18
                color: "white"
            }
        }

    }



}
