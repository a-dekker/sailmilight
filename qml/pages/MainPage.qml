import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.sailmilight.Settings 1.0
import io.thp.pyotherside 1.5

Page {
    id: page

    property bool juststarted: true
    property bool bigScreen: Screen.sizeCategory === Screen.Large
                               || Screen.sizeCategory === Screen.ExtraLarge

    MySettings {
        id: myset
    }

    Component.onCompleted: {
        app.ip_address = myset.value("controller-ip", "127.0.0.1")
        app.port_nbr = myset.value("controller-port", "8899")
        juststarted = false
    }

    Python {
        id: python

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('.'))
            importModule('call_milight', function () {
                console.log('call_milight module is now imported')
            })

            setHandler('result', function (result) {
                console.log(result)
                busy.running = false
            })
        }

        onError: {
            console.log('Python ERROR: ' + traceback)
            Clipboard.text = traceback
        }
    }

    onStatusChanged: {
        switch (status) {
        case PageStatus.Active:
            pageStack.pushAttached(Qt.resolvedUrl("EffectsPage.qml"))
        }
    }


    SilicaFlickable {
        anchors.fill: parent

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
        contentHeight: column.height

        Column {
            id: column
            width: page.width

            PageHeader {
                id: header
                title: app.name

                BusyIndicator {
                    id: busy
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.horizontalPageMargin
                    anchors.verticalCenter: parent.verticalCenter
                    size: BusyIndicatorSize.Small
                    running: false
                }
            }

            TextSwitch {
                id: toggle
                text: qsTr("ON")
                checked: app.bulb_state
                description: qsTr("Switch the RGBW bulb ON/OFF")
                onCheckedChanged: {
                    if (checked && !juststarted) {
                        python.call('call_milight.switchon',
                                    [app.ip_address, app.port_nbr, app.active_zone],
                                    function () {})
                        text = qsTr("ON")
                        busy.running = true
                    }
                    if (!checked && !juststarted) {
                        python.call('call_milight.switchoff',
                                    [app.ip_address, app.port_nbr, app.active_zone],
                                    function () {})
                        text = qsTr("OFF")
                        busy.running = true
                    }
                }
            }

            Row {
                width: parent.width
                Slider {
                    id: dimmer
                    width: isPortrait ? parent.width : parent.width / 2
                    value: 100
                    visible: toggle.checked
                    minimumValue: 0
                    maximumValue: 100
                    stepSize: 1
                    valueText: value.toFixed(0) + " %"
                    label: qsTr("Brightness")
                    onValueChanged: {
                        update_brightness.restart()
                        busy.running = true
                    }
                }
                Slider {
                    id: red_landscape
                    width: parent.width / 2
                    value: 255
                    visible: toggle.checked && isLandscape
                    minimumValue: 0
                    maximumValue: 255
                    stepSize: 1
                    valueText: ((value / 255) * 100).toFixed(0) + " %"
                    label: qsTr("Red")
                    onValueChanged: {
                        update.restart()
                        red.value = red_landscape.value
                        busy.running = true
                    }
                }
            }

            Slider {
                id: red
                width: parent.width
                value: 255
                visible: toggle.checked && isPortrait
                minimumValue: 0
                maximumValue: 255
                stepSize: 1
                valueText: ((value / 255) * 100).toFixed(0) + " %"
                label: qsTr("Red")
                onValueChanged: {
                    update.restart()
                    red_landscape.value = red.value
                    busy.running = true
                }
            }

            Row {
                width: parent.width
                Slider {
                    id: green
                    width: isPortrait ? parent.width : parent.width / 2
                    value: 255
                    visible: toggle.checked
                    minimumValue: 0
                    maximumValue: 255
                    stepSize: 1
                    valueText: ((value / 255) * 100).toFixed(0) + " %"
                    label: qsTr("Green")
                    onValueChanged: {
                        update.restart()
                        busy.running = true
                    }
                }
                Slider {
                    id: blue_landscape
                    width: parent.width / 2
                    value: 255
                    visible: toggle.checked && isLandscape
                    minimumValue: 0
                    maximumValue: 255
                    stepSize: 1
                    valueText: ((value / 255) * 100).toFixed(0) + " %"
                    label: qsTr("Blue")
                    onValueChanged: {
                        update.restart()
                        blue.value = blue_landscape.value
                        busy.running = true
                    }
                }
            }

            Slider {
                id: blue
                width: parent.width
                value: 255
                visible: toggle.checked && isPortrait
                minimumValue: 0
                maximumValue: 255
                stepSize: 1
                valueText: ((value / 255) * 100).toFixed(0) + " %"
                label: qsTr("Blue")
                onValueChanged: {
                    update.restart()
                    blue_landscape.value = blue.value
                    busy.running = true
                }
            }

            Rectangle {
                width: parent.width
                height: page.height - header.height - toggle.height
                        - dimmer.height - red.height - green.height
                        - blue.height - colorLine1.height - colorLine2.height
                        > 0 ? page.height - header.height - toggle.height
                              - dimmer.height - red.height - green.height - blue.height
                              - colorLine1.height - colorLine2.height : Theme.paddingLarge
                color: "transparent"
            }

            Row {
                id: colorLine1
                visible: toggle.checked && (isPortrait || bigScreen)
                width: parent.width
                height: width / 6

                Rectangle {
                    color: "red"
                    width: parent.width / 4
                    height: parent.height

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            update.stop()
                            red.value = 255
                            green.value = 0
                            blue.value = 0
                            python.call('call_milight.setcolor',
                                        [app.ip_address, app.port_nbr, app.active_zone, 255, 0, 0],
                                        function (red, green, blue) {})
                            busy.running = true
                        }
                    }
                }

                Rectangle {
                    color: "green"
                    width: parent.width / 4
                    height: parent.height

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            update.stop()
                            red.value = 0
                            green.value = 255
                            blue.value = 0
                            python.call('call_milight.setcolor',
                                        [app.ip_address, app.port_nbr, app.active_zone, 0, 255, 0],
                                        function (red, green, blue) {})
                            busy.running = true
                        }
                    }
                }

                Rectangle {
                    color: "blue"
                    width: parent.width / 4
                    height: parent.height

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            update.stop()
                            red.value = 0
                            green.value = 0
                            blue.value = 255
                            python.call('call_milight.setcolor',
                                        [app.ip_address, app.port_nbr, app.active_zone, 0, 0, 255],
                                        function (red, green, blue) {})
                            busy.running = true
                        }
                    }
                }
                Rectangle {
                    color: "purple"
                    width: parent.width / 4
                    height: parent.height

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            update.stop()
                            red.value = 153
                            green.value = 51
                            blue.value = 255
                            python.call('call_milight.setcolor',
                                        [app.ip_address, app.port_nbr, app.active_zone, 153, 51, 255],
                                        function (red, green, blue) {})
                            busy.running = true
                        }
                    }
                }
            }

            Row {
                id: colorLine2
                visible: toggle.checked && (isPortrait || bigScreen)
                width: parent.width
                height: width / 6

                Rectangle {
                    color: "orange"
                    width: parent.width / 4
                    height: parent.height

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            update.stop()
                            red.value = 255
                            green.value = 153
                            blue.value = 51
                            python.call('call_milight.setcolor',
                                        [app.ip_address, app.port_nbr, app.active_zone, 255, 153, 51],
                                        function (red, green, blue) {})
                            busy.running = true
                        }
                    }
                }

                Rectangle {
                    color: "yellow"
                    width: parent.width / 4
                    height: parent.height

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            update.stop()
                            red.value = 255
                            green.value = 255
                            blue.value = 0
                            python.call('call_milight.setcolor',
                                        [app.ip_address, app.port_nbr, app.active_zone, 255, 255, 0],
                                        function (red, green, blue) {})
                            busy.running = true
                        }
                    }
                }

                Rectangle {
                    color: "white"
                    width: parent.width / 4
                    height: parent.height

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            update.stop()
                            red.value = 255
                            green.value = 255
                            blue.value = 255
                            python.call('call_milight.setcolorWhite',
                                        [app.ip_address, app.port_nbr, app.active_zone],
                                        function () {})
                            busy.running = true
                        }
                    }
                }
                Rectangle {
                    color: "cyan"
                    width: parent.width / 4
                    height: parent.height

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            update.stop()
                            red.value = 0
                            green.value = 255
                            blue.value = 255
                            python.call('call_milight.setcolor',
                                        [app.ip_address, app.port_nbr, app.active_zone, 0, 255, 255],
                                        function (red, green, blue) {})
                            busy.running = true
                        }
                    }
                }
            }
            Row {
                id: colorLine_landscape
                visible: toggle.checked && isLandscape && !bigScreen
                width: parent.width
                height: width / 8

                Rectangle {
                    color: "red"
                    width: parent.width / 8
                    height: parent.height

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            update.stop()
                            red.value = 255
                            green.value = 0
                            blue.value = 0
                            python.call('call_milight.setcolor',
                                        [app.ip_address, app.port_nbr, app.active_zone, 255, 0, 0],
                                        function (red, green, blue) {})
                            busy.running = true
                        }
                    }
                }

                Rectangle {
                    color: "green"
                    width: parent.width / 8
                    height: parent.height

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            update.stop()
                            red.value = 0
                            green.value = 255
                            blue.value = 0
                            python.call('call_milight.setcolor',
                                        [app.ip_address, app.port_nbr, app.active_zone, 0, 255, 0],
                                        function (red, green, blue) {})
                            busy.running = true
                        }
                    }
                }

                Rectangle {
                    color: "blue"
                    width: parent.width / 8
                    height: parent.height

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            update.stop()
                            red.value = 0
                            green.value = 0
                            blue.value = 255
                            python.call('call_milight.setcolor',
                                        [app.ip_address, app.port_nbr, app.active_zone, 0, 0, 255],
                                        function (red, green, blue) {})
                            busy.running = true
                        }
                    }
                }
                Rectangle {
                    color: "purple"
                    width: parent.width / 8
                    height: parent.height

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            update.stop()
                            red.value = 153
                            green.value = 51
                            blue.value = 255
                            python.call('call_milight.setcolor',
                                        [app.ip_address, app.port_nbr, app.active_zone, 153, 51, 255],
                                        function (red, green, blue) {})
                            busy.running = true
                        }
                    }
                }
                Rectangle {
                    color: "orange"
                    width: parent.width / 8
                    height: parent.height

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            update.stop()
                            red.value = 255
                            green.value = 153
                            blue.value = 51
                            python.call('call_milight.setcolor',
                                        [app.ip_address, app.port_nbr, app.active_zone, 255, 153, 51],
                                        function (red, green, blue) {})
                            busy.running = true
                        }
                    }
                }

                Rectangle {
                    color: "yellow"
                    width: parent.width / 8
                    height: parent.height

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            update.stop()
                            red.value = 255
                            green.value = 255
                            blue.value = 0
                            python.call('call_milight.setcolor',
                                        [app.ip_address, app.port_nbr, app.active_zone, 255, 255, 0],
                                        function (red, green, blue) {})
                            busy.running = true
                        }
                    }
                }

                Rectangle {
                    color: "white"
                    width: parent.width / 8
                    height: parent.height

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            update.stop()
                            red.value = 255
                            green.value = 255
                            blue.value = 255
                            python.call('call_milight.setcolorWhite',
                                        [app.ip_address, app.port_nbr, app.active_zone],
                                        function () {})
                            busy.running = true
                        }
                    }
                }
                Rectangle {
                    color: "cyan"
                    width: parent.width / 8
                    height: parent.height

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            update.stop()
                            red.value = 0
                            green.value = 255
                            blue.value = 255
                            python.call('call_milight.setcolor',
                                        [app.ip_address, app.port_nbr, app.active_zone, 0, 255, 255],
                                        function (red, green, blue) {})
                            busy.running = true
                        }
                    }
                }
            }
        }
    }

    Timer {
        id: update
        repeat: false
        interval: 500
        onTriggered: {
            python.call('call_milight.setcolor',
                        [app.ip_address, app.port_nbr, app.active_zone, red.value, green.value, blue.value],
                        function (red, green, blue) {})
        }
    }

    Timer {
        id: update_brightness
        repeat: false
        interval: 500
        onTriggered: {
            python.call('call_milight.brightness',
                        [app.ip_address, app.port_nbr, app.active_zone, dimmer.value],
                        function () {})
        }
    }
}
