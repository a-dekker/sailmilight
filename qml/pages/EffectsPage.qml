import QtQuick 2.5
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.5

Page {
    id: settingsPage

    Python {
        id: python

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('.'))
            importModule('call_milight', function () {
                console.log('call_milight module is now imported')
            })

            setHandler('result', function (result) {
                console.log(result)
            })
        }

        onError: {
            console.log('Python ERROR: ' + traceback)
            Clipboard.text = traceback
        }
    }

    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: column.height

        clip: true

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
            }
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingPage.qml"))
            }
            MenuItem {
                text: qsTr("Active zone: ") + app.active_zone.replace(
                          "0", qsTr("all"))
                onClicked: app.rotateActiveZone()
            }
        }

        ScrollDecorator {}

        Column {
            id: column
            spacing: isPortrait ? Theme.paddingLarge : Theme.paddingSmall
            width: parent.width - 2 * Theme.paddingMedium
            PageHeader {
                title: qsTr("Light effects")
            }
            Row {
                x: Theme.paddingMedium
                y: Theme.paddingMedium
                width: parent.width
                IconButton {
                    id: rainbow
                    scale: Screen.width >= 1080 ? 1 : 0.5
                    width: parent.width / 3
                    height: isPortrait ? rainbow.width : rainbow.width / 3
                    icon.source: "../images/rainbow.png"
                    onClicked: {
                        python.call('call_milight.party',
                                    [app.ip_address, app.port_nbr, app.active_zone, 'rainbow_swirl'],
                                    function () {})
                    }
                }
                IconButton {
                    id: disco
                    scale: Screen.width >= 1080 ? 1 : 0.5
                    width: parent.width / 3
                    height: isPortrait ? disco.width : disco.width / 3
                    icon.source: "../images/disco.png"
                    onClicked: {
                        python.call('call_milight.party',
                                    [app.ip_address, app.port_nbr, app.active_zone, 'random'],
                                    function () {})
                    }
                }
                IconButton {
                    id: pulse
                    scale: Screen.width >= 1080 ? 1 : 0.5
                    width: parent.width / 3
                    height: isPortrait ? pulse.width : pulse.width / 3
                    icon.source: "../images/pulse.png"
                    onClicked: {
                        python.call('call_milight.party',
                                    [app.ip_address, app.port_nbr, app.active_zone, 'rainbow_jump'],
                                    function () {})
                    }
                }
            }
            Row {
                x: Theme.paddingMedium
                y: Theme.paddingMedium
                width: parent.width
                Label {
                    width: parent.width / 3
                    horizontalAlignment: Text.Center
                    wrapMode: Text.Wrap
                    text: qsTr("Rainbow")
                    color: rainbow.down ? Theme.secondaryHighlightColor : Theme.primaryColor
                }
                Label {
                    width: parent.width / 3
                    horizontalAlignment: Text.Center
                    wrapMode: Text.Wrap
                    text: qsTr("Disco")
                    color: disco.down ? Theme.secondaryHighlightColor : Theme.primaryColor
                }
                Label {
                    width: parent.width / 3
                    horizontalAlignment: Text.Center
                    wrapMode: Text.Wrap
                    text: qsTr("Pulse")
                    color: pulse.down ? Theme.secondaryHighlightColor : Theme.primaryColor
                }
            }
            Row {
                x: Theme.paddingMedium
                y: Theme.paddingMedium
                width: parent.width
                IconButton {
                    id: flash_red
                    scale: Screen.width >= 1080 ? 1 : 0.5
                    height: isPortrait ? flash_red.width : flash_red.width / 3
                    width: parent.width / 3
                    icon.source: "../images/bulb-flash-red.png"
                    onClicked: {
                        python.call('call_milight.party',
                                    [app.ip_address, app.port_nbr, app.active_zone, 'red_twinkle'],
                                    function () {})
                    }
                }
                IconButton {
                    id: flash_green
                    scale: Screen.width >= 1080 ? 1 : 0.5
                    height: isPortrait ? flash_green.width : flash_green.width / 3
                    width: parent.width / 3
                    icon.source: "../images/bulb-flash-green.png"
                    onClicked: {
                        python.call('call_milight.party',
                                    [app.ip_address, app.port_nbr, app.active_zone, 'green_twinkle'],
                                    function () {})
                    }
                }
                IconButton {
                    id: flash_blue
                    scale: Screen.width >= 1080 ? 1 : 0.5
                    width: parent.width / 3
                    height: isPortrait ? flash_blue.width : flash_blue.width / 3
                    icon.source: "../images/bulb-flash-blue.png"
                    onClicked: {
                        python.call('call_milight.party',
                                    [app.ip_address, app.port_nbr, app.active_zone, 'blue_twinkle'],
                                    function () {})
                    }
                }
            }
            Row {
                x: Theme.paddingMedium
                y: Theme.paddingMedium
                width: parent.width
                Label {
                    width: parent.width / 3
                    horizontalAlignment: Text.Center
                    wrapMode: Text.Wrap
                    text: qsTr("Flash red")
                    color: flash_red.down ? Theme.secondaryHighlightColor : Theme.primaryColor
                }
                Label {
                    width: parent.width / 3
                    horizontalAlignment: Text.Center
                    wrapMode: Text.Wrap
                    text: qsTr("Flash green")
                    color: flash_green.down ? Theme.secondaryHighlightColor : Theme.primaryColor
                }
                Label {
                    width: parent.width / 3
                    horizontalAlignment: Text.Center
                    wrapMode: Text.Wrap
                    text: qsTr("Flash blue")
                    color: flash_blue.down ? Theme.secondaryHighlightColor : Theme.primaryColor
                }
            }
            Row {
                x: Theme.paddingMedium
                y: Theme.paddingMedium
                width: parent.width
                IconButton {
                    id: flash_white
                    scale: Screen.width >= 1080 ? 1 : 0.5
                    height: isPortrait ? flash_white.width : flash_white.width / 3
                    width: parent.width / 3
                    icon.source: "../images/bulb-flash-white.png"
                    onClicked: {
                        python.call('call_milight.party',
                                    [app.ip_address, app.port_nbr, app.active_zone, 'white_fade'],
                                    function () {})
                    }
                }
                IconButton {
                    id: rgbw_fade
                    scale: Screen.width >= 1080 ? 1 : 0.5
                    height: isPortrait ? rgbw_fade.width : rgbw_fade.width / 3
                    width: parent.width / 3
                    icon.source: "../images/bulb-flash-rgbw.png"
                    onClicked: {
                        python.call('call_milight.party',
                                    [app.ip_address, app.port_nbr, app.active_zone, 'rgbw_fade'],
                                    function () {})
                    }
                }
                IconButton {
                    id: night
                    scale: Screen.width >= 1080 ? 1 : 0.5
                    height: isPortrait ? night.width : night.width / 3
                    width: parent.width / 3
                    icon.source: "../images/night.png"
                    onClicked: {
                        python.call('call_milight.setcolorNight',
                                    [app.ip_address, app.port_nbr, app.active_zone],
                                    function () {})
                    }
                }
            }
            Row {
                x: Theme.paddingMedium
                y: Theme.paddingMedium
                width: parent.width
                Label {
                    width: parent.width / 3
                    horizontalAlignment: Text.Center
                    text: qsTr("Fade white")
                    color: flash_white.down ? Theme.secondaryHighlightColor : Theme.primaryColor
                }
                Label {
                    width: parent.width / 3
                    horizontalAlignment: Text.Center
                    text: qsTr("Fade rgbw")
                    color: rgbw_fade.down ? Theme.secondaryHighlightColor : Theme.primaryColor
                }
                Label {
                    width: parent.width / 3
                    horizontalAlignment: Text.Center
                    text: qsTr("Night")
                    color: rgbw_fade.down ? Theme.secondaryHighlightColor : Theme.primaryColor
                }
            }
        }
    }
}
