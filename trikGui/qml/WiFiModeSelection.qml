import QtQuick 2.0
import WiFiMode 1.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Rectangle {
    id: _mainItem
    property var wiFiMode: WiFiModeServer
    property var idList: _listWiFiModes
    color: Style.backgroundColor

    ListModel {
        id: dataModelModes
        ListElement {
            iconPath: "WiFiClient.png"
            text: qsTr("Wi-Fi client")
            mode: Mode.Client
        }
        ListElement {
            iconPath: "WiFiAP.png"
            text: qsTr("Wi-Fi access point")
            mode: Mode.AccessPoint
        }
    }

    ListView {
        id: _listWiFiModes
        anchors.fill: parent
        anchors.margins: 7
        model: dataModelModes
        spacing: 7
        delegate: Item {
            id: _delegateMode
            width: _listWiFiModes.width
            height: _listWiFiModes.height / 4.8
            property bool isCurrent: ListView.isCurrentItem
            Keys.onPressed: {
                switch (event.key) {
                case Qt.Key_Return:
                    wiFiMode.setMode(model.mode)
                    break
                default:
                    break
                }
            }
            Rectangle {
                id: _mode
                focus: isCurrent
                anchors.fill: parent
                radius: 10
                color: _delegateMode.isCurrent ? "#303BB050" : "white"
                Row {
                    width: parent.width
                    height: parent.height
                    anchors.left: parent.left
                    anchors.leftMargin: 7
                    spacing: parent.width < 400 ? 5 : 15
                    Image {
                        source: iconsPath + model.iconPath
                        width: parent.width < 400 ? parent.width / 7 : parent.width / 23
                        height: parent.width < 400 ? parent.width / 7 : parent.width / 23
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        id: _textMode
                        text: model.text
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
}
