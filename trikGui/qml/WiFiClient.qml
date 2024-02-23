import QtQuick 2.0
import WiFiClient 1.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import WiFiMode 1.0

Rectangle {
    id: _mainWiFiClient
    property var wiFiClient: WiFiClientServer
    property string ipValue: ""
    property string connectionStateIconPath: ""
    property bool isScanning: wiFiClient.rowCount() === 0 ? true : false
    color: Style.backgroundColor
    property var idList: _button
    Component.onCompleted: {
        wiFiClient.setQmlParent(_mainWiFiClient)
    }
    Rectangle {
        id: _confirm
        implicitWidth: parent.width / 1.05
        implicitHeight: _columnConfirm.implicitHeight
        z: 1
        color: "#D8D8D8"
        radius: 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        border.color: "black"
        border.width: 1
        property string focusButton: "No"
        visible: false
        Keys.onPressed: {
            switch (event.key) {
            case Qt.Key_Right:
                if (focusButton === "No") {
                    focusButton = "Yes"
                }
                break
            case Qt.Key_Left:
                if (focusButton === "Yes") {
                    focusButton = "No"
                }
                break
            case Qt.Key_Return:
                if (focusButton === "Yes") {
                    _buttonYes.clicked()
                } else if (focusButton === "No") {
                    _buttonNo.clicked()
                }
                break
            default:
                break
            }
        }
        ColumnLayout {
            id: _columnConfirm
            anchors.fill: parent
            Text {
                text: qsTr("Confirm connection")
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                font.pointSize: 12
                horizontalAlignment: Text.AlignHCenter
                Layout.topMargin: 6
            }
            Rectangle {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: 1
                color: "black"
            }
            RowLayout {
                Layout.fillWidth: true
                Image {
                    id: _imagewar
                    source: iconsPath + "warningDel.png"
                    Layout.preferredWidth: _mainItem.width
                                           < 400 ? _mainItem.width / 7 : _mainItem.width / 25
                    Layout.preferredHeight: _mainItem.width
                                            < 400 ? _mainItem.width / 7 : _mainItem.width / 25
                    Layout.leftMargin: 5
                    Layout.rightMargin: 5
                }

                Text {
                    text: qsTr("Are you sure you want to connect to open WiFi network?")
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                    Layout.rightMargin: 3
                    font.pointSize: 12
                }
            }
            RowLayout {
                Layout.alignment: Qt.AlignRight
                Layout.bottomMargin: 7
                Layout.rightMargin: 9
                Layout.topMargin: 9
                Button {
                    id: _buttonNo
                    text: qsTr("No")
                    palette.buttonText: "white"
                    background: Rectangle {
                        color: _confirm.focusButton === "No" ? "#3BB050" : "#7D7D7D"
                        radius: 10
                    }
                    onClicked: {
                        _confirm.visible = false
                        _listNetworks.focus = true
                    }
                }
                Button {
                    id: _buttonYes
                    text: qsTr("Yes")
                    palette.buttonText: "white"
                    background: Rectangle {
                        color: _confirm.focusButton === "Yes" ? "#3BB050" : "#7D7D7D"
                        radius: 10
                    }
                    onClicked: {
                        wiFiClient.connectToSelectedNetwork(
                                    _listNetworks.currentItem.wiFiSsid)
                        _confirm.visible = false
                        _confirm.focusButton = "No"
                        _listNetworks.focus = true
                    }
                }
            }
        }
    }
    Connections {
        target: wiFiClient
        onModelReset: {
            _mainWiFiClient.isScanning = false
        }
        onConnectionStateChanged: {
            switch (wiFiClient.connectionState) {
            case ConnectionState.Connected:
                connectionStateIconPath = iconsPath + "ok.png"
                ipValue = wiFiClient.ipValue
                break
            case ConnectionState.Connecting:
                connectionStateIconPath = iconsPath + "warning.png"
                ipValue = qsTr("connecting...")
                break
            case ConnectionState.NotConnected:
                connectionStateIconPath = iconsPath + "error.png"
                ipValue = qsTr("no connection")
                break
            case ConnectionState.Errored:
                connectionStateIconPath = iconsPath + "error.png"
                ipValue = qsTr("error")
                break
            }
        }
    }

    ColumnLayout {
        spacing: 5
        anchors.fill: parent
        anchors.margins: 10
        Button {
            id: _button
            Layout.preferredHeight: parent.height / 10
            text: qsTr("Enable access point")
            palette.buttonText: "white"
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            background: Rectangle {
                color: _button.focus ? "#219D38" : "#7D7D7D"
                radius: 10
            }

            Keys.onPressed: {
                switch (event.key) {
                case Qt.Key_Down:
                    if (_listNetworks.count > 0) {
                        _listNetworks.focus = true
                    }
                    break
                case Qt.Key_Return:
                    WiFiModeServer.setMode(Mode.AccessPoint)
                    break
                default:
                    break
                }
            }
        }
        Row {
            width: parent.width
            height: parent.height
            Layout.alignment: Qt.AlignLeft
            spacing: connectionStateIconPath !== "" ? (_mainWiFiClient.width < 400 ? 5 : 15) : 0
            Image {
                id: _connectionStatus
                source: connectionStateIconPath
                width: connectionStateIconPath
                       !== "" ? _mainWiFiClient.width
                                < 400 ? _mainWiFiClient.width / 10 : _mainWiFiClient.width / 25 : 0
                height: connectionStateIconPath
                        !== "" ? _mainWiFiClient.width
                                 < 400 ? _mainWiFiClient.width / 10 : _mainWiFiClient.width / 25 : 0
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: _ipValue
                text: qsTr("IP: ") + ipValue
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Text {
            id: _availableNet
            text: qsTr("Available networks:")
        }

        Rectangle {
            id: _mainView
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 10
            clip: true
            ColumnLayout {
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.margins: 20
                spacing: 15
                visible: isScanning
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    text: qsTr("Scanning...")
                    wrapMode: Text.Wrap
                    width: parent.width / 1.2
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                ProgressBar {
                    indeterminate: true
                    palette.dark: Style.trikColor
                    Layout.fillWidth: true
                    background: Rectangle {
                        color: Style.backgroundColor
                        radius: 3
                    }
                }
            }
            ListView {
                id: _listNetworks
                anchors.fill: parent
                anchors.margins: 5
                model: wiFiClient
                visible: !isScanning
                spacing: 7
                property string currentSsid: wiFiClient.currentSsid
                property real lineMargin: 8
                function getWiFiStateIconPath(displaySsid, displayIsKnown, displaySecurity) {
                    if (displaySsid === currentSsid) {
                        return iconsPath + "connectedWiFi.png"
                    } else if (displayIsKnown) {
                        return iconsPath + "knownWiFi.png"
                    } else if (displaySecurity === "none") {
                        return iconsPath + "openWiFiBigLock.png"
                    } else {
                        return iconsPath + "passwordedWiFiBigLock.png"
                    }
                }
                Component.onCompleted: {
                    currentIndex = 0
                }
                delegate: Item {
                    id: _delegateNetworks
                    width: _listNetworks.width
                    implicitHeight: (_textSsid.implicitHeight > _wiFiStatus.height ? _textSsid.implicitHeight : _wiFiStatus.height) + _listNetworks.lineMargin
                    property string wiFiSsid: display.ssid
                    property var isCurrent: ListView.isCurrentItem
                    property string connectionWiFiStateIconPath: _listNetworks.getWiFiStateIconPath(
                                                                     display.ssid,
                                                                     display.isKnown,
                                                                     display.security)
                    Keys.onPressed: {
                        switch (event.key) {
                        case Qt.Key_Return:
                            if (display.ssid !== _listNetworks.currentSsid) {
                                if (display.isKnown) {
                                    wiFiClient.connectToSelectedNetwork(
                                                display.ssid)
                                } else if (display.security === "none") {
                                    _listNetworks.focus = false
                                    _confirm.focus = true
                                    _confirm.visible = true
                                }
                            }
                            break
                        case Qt.Key_Up:
                            if (index === 0) {
                                _button.focus = true
                            }
                            break
                        default:
                            break
                        }
                    }
                    Rectangle {
                        id: _wiFiSsid
                        anchors.fill: parent
                        radius: 10
                        color: _delegateNetworks.isCurrent
                               && _listNetworks.focus ? "#303BB050" : "white"
                        Row {
                            width: parent.width
                            height: parent.height
                            anchors.left: parent.left
                            anchors.leftMargin: 3
                            spacing: connectionWiFiStateIconPath ? (_mainWiFiClient.width
                                                                    < 400 ? 5 : 15) : 0
                            Image {
                                id: _wiFiStatus
                                source: connectionWiFiStateIconPath ? connectionWiFiStateIconPath : ""
                                width: connectionWiFiStateIconPath ? _mainWiFiClient.width < 400 ? _mainWiFiClient.width / 9 : _mainWiFiClient.width / 25 : 0
                                height: connectionWiFiStateIconPath ? _mainWiFiClient.width < 400 ? _mainWiFiClient.width / 9 : _mainWiFiClient.width / 25 : 0
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Text {
                                id: _textSsid
                                text: display.ssid
                                font.bold: display.ssid === _listNetworks.currentSsid
                                width: _wiFiSsid.width - _wiFiStatus.width
                                anchors.verticalCenter: parent.verticalCenter
                                wrapMode: Text.Wrap
                            }
                        }
                    }
                }
            }
        }
    }
}
