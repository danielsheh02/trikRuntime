import QtQuick 2.0
import QtQuick.Layouts 1.0

Rectangle {
    id: _information
    property var systemInformation: SystemInformation
    property string osVersion: systemInformation.osVersion()
    property string macAddress: systemInformation.macAddress()
    color: Style.backgroundColor
    Component.onCompleted: {
        systemInformation.setQmlParent(_information)
    }
    Rectangle {
        anchors.fill: parent
        radius: 10
        anchors.margins: 15
        ColumnLayout {
            id: _columnInfo
            anchors.fill: parent
            anchors.margins: 10
            Text {
                text: qsTr("OS version:")
                wrapMode: Text.Wrap
                font.pointSize: 15
            }
            Text {
                text: osVersion ? osVersion : qsTr("Unknown")
                wrapMode: Text.Wrap
                font.pointSize: 13
                color: "#8B8B8B"
            }
            Rectangle {
                height: 1
                color: "#8B8B8B"
                Layout.fillWidth: true
            }

            Text {
                text: qsTr("MAC address:")
                wrapMode: Text.Wrap
                font.pointSize: 15
            }
            Text {
                text: macAddress ? macAddress : qsTr("Not found")
                wrapMode: Text.Wrap
                font.pointSize: 13
                color: "#8B8B8B"
            }
            Item {
                Layout.fillHeight: true
            }
            Text {
                text: "https://trikset.com/"
                color: "blue"
                font.underline: true
                Layout.alignment: Qt.AlignHCenter
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        Qt.openUrlExternally("https://trikset.com/")
                    }

                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
    }
}
