import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import WiFiMode 1.0

Rectangle {
    id: _wiFiAP
    property var wiFiAP: WiFiAPServer
    property var idList: _button
    color: activeTheme.backgroundColor

    Component.onCompleted: {
        wiFiAP.setQmlParent(_wiFiAP)
    }
    ColumnLayout {
        id: _columnInfo
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5
        Button {
            id: _button
            Layout.preferredHeight: parent.height / 10
            text: qsTr("Search Wi-Fi")
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true

            Keys.onPressed: {
                switch (event.key) {
                case Qt.Key_Return:
                    WiFiModeServer.setMode(Mode.Client)
                    break
                default:
                    break
                }
            }
        }

        Text {
            text: qsTr("Network parameters:")
            wrapMode: Text.Wrap
            Layout.fillWidth: true
            Layout.fillHeight: true
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 13
            color: activeTheme.textColor
        }

        Image {
            id: _qrCodeImage
            source: wiFiAP.nameImage ? "file:" + wiFiAP.nameImage : ""
            Layout.fillHeight: true
            Layout.preferredWidth: height
            Layout.alignment: Qt.AlignHCenter
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignBottom
            spacing: 5

            Text {
                text: qsTr("Name: ") + (wiFiAP.networkName ? wiFiAP.networkName : qsTr(
                                                                 "not found"))
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                font.pointSize: 13
                horizontalAlignment: Text.AlignHCenter
                color: activeTheme.textColor
            }
            Text {
                text: qsTr("Password: ") + (wiFiAP.password ? wiFiAP.password : qsTr(
                                                                  "not found"))
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                font.pointSize: 13
                horizontalAlignment: Text.AlignHCenter
                color: activeTheme.textColor
            }
            Text {
                text: qsTr("IP address: ") + (wiFiAP.ipValue ? wiFiAP.ipValue : qsTr(
                                                                   "not found"))
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                font.pointSize: 13
                horizontalAlignment: Text.AlignHCenter
                color: activeTheme.textColor
            }
        }
    }
}
