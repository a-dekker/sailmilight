import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.sailmilight.Settings 1.0
import io.thp.pyotherside 1.5

Page {
    id: settingsPage

    MySettings {
        id: myset
    }

    property bool largeScreen: Screen.sizeCategory === Screen.Large
                               || Screen.sizeCategory === Screen.ExtraLarge

    objectName: "SettingPage"

    Component.onCompleted: {
        app.ip_address = myset.value("controller-ip", "127.0.0.1")
        ip_address_1.text = app.ip_address.split(".")[0]
        ip_address_2.text = app.ip_address.split(".")[1]
        ip_address_3.text = app.ip_address.split(".")[2]
        ip_address_4.text = app.ip_address.split(".")[3]
        port_textfield.text = myset.value("controller-port", "8899")
        app.port_nbr = port_textfield.text
        // reset focus as fields where changed
        ip_address_1.focus = false
        ip_address_2.focus = false
        ip_address_3.focus = false
        ip_address_4.focus = false
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

    function resetValues() {
        ip_address_1.text = ""
        ip_address_2.text = ""
        ip_address_3.text = ""
        ip_address_4.text = ""
    }

    function validateIPaddress(ipaddress) {
        var ipformat
        if (ipaddress === "") {
            return false
        }
        ipformat = /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
        if (ipaddress.match(ipformat)) {
            return true
        } else {
            banner("WARNING", qsTr("Invalid IP address"))
            return false
        }
    }

    function checkAll() {
        if (ip_address_1.text !== "" && ip_address_2.text !== ""
                && ip_address_3.text !== "" && ip_address_4.text !== "") {
            var ipaddress = ip_address_1.text + "." + ip_address_2.text + "."
                    + ip_address_3.text + "." + ip_address_4.text
            if (validateIPaddress(ipaddress)) {
                //save
                myset.setValue("controller-ip", ipaddress)
                myset.sync()
                app.ip_address = ipaddress
            }
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
            width: parent.width
            PageHeader {
                title: qsTr("Settings")
            }
            SectionHeader {
                text: qsTr("Wifi controller")
            }
            IconButton {
                icon.source: largeScreen ? "image://theme/icon-l-clear" : "image://theme/icon-m-clear"
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingMedium
                visible: isPortrait
                onClicked: {
                    resetValues()
                }
            }
            Row {
                x: Theme.paddingLarge
                y: Theme.paddingLarge
                spacing: 0
                Label {
                    text: qsTr("IP address")
                    width: isLandscape ? ((column.width - (Theme.paddingLarge * 5)) / 2)
                                         - iconButtonLandscape.width : (column.width - (Theme.paddingLarge * 2)) / 4
                }
                TextField {
                    id: ip_address_1

                    placeholderText: "---"
                    width: isPortrait ? (column.width + Theme.paddingLarge)
                                        / 6 : (column.width + Theme.paddingLarge) / 8
                    validator: RegExpValidator {
                        regExp: /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
                    }
                    color: errorHighlight ? "red" : Theme.highlightColor
                    inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText
                    horizontalAlignment: Text.AlignRight
                    text: ""
                    EnterKey.enabled: text.trim().length > 0
                    EnterKey.highlighted: true
                    EnterKey.text: "→"
                    EnterKey.onClicked: {
                        checkAll()
                        ip_address_2.focus = true
                    }
                    onFocusChanged: {
                        if (ip_address_1.text !== "") {
                            // remove leading zero's
                            ip_address_1.text = ip_address_1.text.replace(
                                        /^0+([1-9])/, '$1')
                            checkAll()
                        }
                    }
                    onTextChanged: {
                        if (text.length === 3) {
                            ip_address_2.focus = true
                        }
                    }
                }
                Label {
                    text: "."
                    width: 4
                }
                TextField {
                    id: ip_address_2

                    placeholderText: "---"
                    width: isPortrait ? (column.width + Theme.paddingLarge)
                                        / 6 : (column.width + Theme.paddingLarge) / 8
                    validator: RegExpValidator {
                        regExp: /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
                    }
                    color: errorHighlight ? "red" : Theme.highlightColor
                    inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText
                    horizontalAlignment: Text.AlignRight
                    text: ""
                    EnterKey.enabled: text.trim().length > 0
                    EnterKey.highlighted: true
                    EnterKey.text: "→"
                    EnterKey.onClicked: {
                        checkAll()
                        ip_address_3.focus = true
                    }
                    onFocusChanged: {
                        if (ip_address_2.text !== "") {
                            // remove leading zero's
                            ip_address_2.text = ip_address_2.text.replace(
                                        /^0+([1-9])/, '$1')
                            checkAll()
                        }
                    }
                    onTextChanged: {
                        if (text.length === 3) {
                            ip_address_3.focus = true
                        }
                    }
                }
                Label {
                    text: "."
                }
                TextField {
                    id: ip_address_3

                    placeholderText: "---"
                    width: isPortrait ? (column.width + Theme.paddingLarge)
                                        / 6 : (column.width + Theme.paddingLarge) / 8
                    validator: RegExpValidator {
                        regExp: /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
                    }
                    color: errorHighlight ? "red" : Theme.highlightColor
                    inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText
                    horizontalAlignment: Text.AlignRight
                    text: ""
                    EnterKey.enabled: text.trim().length > 0
                    EnterKey.highlighted: true
                    EnterKey.text: "→"
                    EnterKey.onClicked: {
                        checkAll()
                        ip_address_4.focus = true
                    }
                    onFocusChanged: {
                        if (ip_address_3.text !== "") {
                            // remove leading zero's
                            ip_address_3.text = ip_address_3.text.replace(
                                        /^0+([1-9])/, '$1')
                            checkAll()
                        }
                    }
                    onTextChanged: {
                        if (text.length === 3) {
                            ip_address_4.focus = true
                        }
                    }
                }
                Label {
                    text: "."
                    anchors.margins: 0
                }
                TextField {
                    id: ip_address_4

                    placeholderText: "---"
                    width: isPortrait ? (column.width + Theme.paddingLarge)
                                        / 6 : (column.width + Theme.paddingLarge) / 8
                    validator: RegExpValidator {
                        regExp: /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
                    }
                    color: errorHighlight ? "red" : Theme.highlightColor
                    inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText
                    horizontalAlignment: Text.AlignRight
                    text: ""
                    EnterKey.enabled: text.trim().length > 0
                    EnterKey.highlighted: true
                    EnterKey.text: "OK"
                    EnterKey.onClicked: {
                        checkAll()
                        ip_address_4.focus = false
                    }
                    onFocusChanged: {
                        if (ip_address_4.text !== "") {
                            // remove leading zero's
                            ip_address_4.text = ip_address_4.text.replace(
                                        /^0+([1-9])/, '$1')
                            checkAll()
                        }
                    }
                }
                IconButton {
                    id: iconButtonLandscape
                    icon.source: largeScreen ? "image://theme/icon-l-clear" : "image://theme/icon-m-clear"
                    visible: isLandscape
                    onClicked: {
                        resetValues()
                    }
                }
            }
            Row {
                x: Theme.paddingLarge
                y: Theme.paddingLarge
                Label {
                    height: Theme.paddingLarge * 2
                    verticalAlignment: Text.AlignBottom
                    text: qsTr("Port number")
                    width: (column.width - port_textfield.width - iconButton.width
                            - Theme.paddingLarge - Theme.paddingMedium)
                }
                TextField {
                    id: port_textfield
                    placeholderText: "8899"
                    width: (column.width - (Theme.paddingLarge * 3)) / 2
                    validator: RegExpValidator {
                        regExp: /^[0-9]{1,5}$/
                    }
                    color: errorHighlight ? "red" : Theme.highlightColor
                    inputMethodHints: Qt.ImhDigitsOnly
                    horizontalAlignment: Text.AlignRight
                    text: ""
                    EnterKey.enabled: text.trim().length > 0
                    EnterKey.highlighted: true
                    EnterKey.text: "OK"
                    EnterKey.onClicked: {
                        myset.setValue("controller-port", port_textfield.text)
                        myset.sync()
                        port_textfield.focus = false
                        app.port_nbr = port_textfield.text
                    }
                    onFocusChanged: {
                        myset.setValue("controller-port", port_textfield.text)
                        myset.sync()
                        app.port_nbr = port_textfield.text
                    }
                }
                IconButton {
                    id: iconButton
                    icon.source: largeScreen ? "image://theme/icon-l-clear" : "image://theme/icon-m-clear"
                    visible: port_textfield.text
                    highlighted: pressed
                    onClicked: {
                        port_textfield.text = ""
                        port_textfield.focus = true
                    }
                }
            }
            Button {
                id: searchButton
                x: Theme.paddingLarge
                y: Theme.paddingLarge
                // width: (parent.width / 2) * 0.95
                text: qsTr("Search WiFi bridges")
                onClicked: {
                    python.call('call_milight.bridges', [], function (result) {
                        found_ip.text = qsTr("Discovered IP: ") + result[0]
                        found_mac.text = qsTr("Corresponding MAC: ") + result[1]
                    })
                }
            }
            Label {
                x: Theme.paddingLarge
                y: Theme.paddingLarge
                id: found_ip
                text: ""
            }
            Label {
                x: Theme.paddingLarge
                y: Theme.paddingLarge
                id: found_mac
                text: ""
            }
        }
    }
}
