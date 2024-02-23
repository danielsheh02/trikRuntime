import QtQuick 2.0
import QtQuick.Layouts 1.0
import WiFiMode 1.0

Rectangle {

    Connections {
        target: WiFiIndicator
        onModeChanged: {
            switch (WiFiIndicator.mode) {
            case Mode.Client:
                if (WiFiIndicator.isConnected()) {
                    _wiFiIndicator.source = iconsPath + "wiFiIndicator.png"
                    _wiFiIndicator.visible = true
                } else {
                    _wiFiIndicator.source = ""
                    _wiFiIndicator.visible = false
                }
                break
            case Mode.AccessPoint:
                _wiFiIndicator.source = iconsPath + "accessPoint.png"
                _wiFiIndicator.visible = true
                break
            case Mode.Unknown:
                _wiFiIndicator.source = ""
                _wiFiIndicator.visible = false
                break
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 7
        anchors.rightMargin: 5
        anchors.leftMargin: 5
        Text {
            id: _voltageValue
            text: BatteryIndicator ? BatteryIndicator.voltageValue : ""
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
            font.pointSize: 11
        }
        Image {
            id: _gamepadIndicator
            source: GamepadIndicator.isConnected ? iconsPath + "gamepad_on.png" : ""
            Layout.preferredHeight: _voltageValue.height
            Layout.preferredWidth: 20
            visible: GamepadIndicator.isConnected
        }
        Image {
            id: _communicatorIndicator
            source: CommunicatorIndicator.isConnected ? iconsPath + "communicatorConnected.png" : ""
            Layout.preferredHeight: _voltageValue.height
            Layout.preferredWidth: 20
            visible: CommunicatorIndicator.isConnected
        }
        Image {
            id: _mailboxIndicator
            source: MailboxIndicator.isConnected ? iconsPath + "mailbox.png" : ""
            Layout.preferredHeight: _voltageValue.height
            Layout.preferredWidth: 20
            visible: MailboxIndicator.isConnected
        }
        Image {
            id: _wiFiIndicator
            source: ""
            Layout.preferredHeight: _voltageValue.height
            Layout.preferredWidth: 20
            visible: false
        }
    }
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        height: 1
        color: "black"
    }
}
