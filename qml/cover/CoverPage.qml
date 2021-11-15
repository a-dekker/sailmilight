import QtQuick 2.5
import Sailfish.Silica 1.0

CoverBackground {
    property bool largeScreen: screen.width >= 1080
    Column {
        width: parent.width
        spacing: Theme.paddingMedium
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 15
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: app.name
        }
        Image {
            source: largeScreen ? "/usr/share/icons/hicolor/128x128/apps/harbour-sailmilight.png" : "/usr/share/icons/hicolor/86x86/apps/harbour-sailmilight.png"
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    CoverActionList {
        id: actions

        CoverAction {
            iconSource: "image://theme/icon-cover-location"
            onTriggered: {
                app.bulb_state = !app.bulb_state
            }
        }
    }
}
