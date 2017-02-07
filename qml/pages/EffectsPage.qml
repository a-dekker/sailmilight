import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3

Page {
    id: settingsPage

    property bool largeScreen: Screen.sizeCategory === Screen.Large
                               || Screen.sizeCategory === Screen.ExtraLarge

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

        ScrollDecorator {
        }

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
                    width: parent.width / 3
                    height: rainbow.width
                    icon.source: "../images/rainbow.png"
                    onClicked: {
                        python.call('call_milight.party',
                                    [app.ip_address, app.port_nbr, app.active_zone, 'rainbow_swirl'],
                                    function () {})
                    }
                }
                IconButton {
                    id: disco
                    width: parent.width / 3
                    height: disco.width
                    icon.source: "../images/disco.png"
                    onClicked: {
                        python.call('call_milight.party',
                                    [app.ip_address, app.port_nbr, app.active_zone, 'random'],
                                    function () {})
                    }
                }
                IconButton {
                    id: pulse
                    width: parent.width / 3
                    height: pulse.width
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
                    text: qsTr("Rainbow")
                    color: rainbow.down ? Theme.secondaryHighlightColor : Theme.primaryColor
                }
                Label {
                    width: parent.width / 3
                    horizontalAlignment: Text.Center
                    text: qsTr("Disco")
                    color: disco.down ? Theme.secondaryHighlightColor : Theme.primaryColor
                }
                Label {
                    width: parent.width / 3
                    horizontalAlignment: Text.Center
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
                    height: flash_red.width
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
                    height: flash_green.width
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
                    width: parent.width / 3
                    height: flash_blue.width
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
                    text: qsTr("Flash red")
                    color: flash_red.down ? Theme.secondaryHighlightColor : Theme.primaryColor
                }
                Label {
                    width: parent.width / 3
                    horizontalAlignment: Text.Center
                    text: qsTr("Flash green")
                    color: flash_green.down ? Theme.secondaryHighlightColor : Theme.primaryColor
                }
                Label {
                    width: parent.width / 3
                    horizontalAlignment: Text.Center
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
                    height: flash_white.width
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
                    height: rgbw_fade.width
                    width: parent.width / 3
                    icon.source: "../images/bulb-flash-rgbw.png"
                    onClicked: {
                        python.call('call_milight.party',
                                    [app.ip_address, app.port_nbr, app.active_zone, 'rgbw_fade'],
                                    function () {})
                    }
                }
                IconButton {
                    id: white_fade
                    width: parent.width / 3
                    height: white_fade.width
                    onClicked: {
                        console.log("dummy")
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
                    text: qsTr("")
                }
            }
        }
    }
}
