import QtQuick 2.0

MouseArea{
    id: rootId

    property var icon_default: ""
    property var icon_pressed: ""
    property var icon_released: ""
    property alias source: img.source

    width: img.implicitWidth
    height: img.implicitHeight

    Image{
        id: img
        source: icon_default
    }

    onPressed: {
        img.source = icon_pressed
    }
}
