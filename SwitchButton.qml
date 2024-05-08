import QtQuick 2.0

MouseArea{
    id: rootId
    // define source reference img depend on status
    property var icon_on: ""
    property var icon_off: ""

    // define status of the button to set img
    property bool status: false

    width: img.implicitWidth
    height: img.implicitHeight
    Image{
        id: img
        source: rootId.status ? icon_on : icon_off
    }

    onClicked: {
        status = !status
    }
}

