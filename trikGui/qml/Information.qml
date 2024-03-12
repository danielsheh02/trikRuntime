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
        color: Style.managersBackColor
        ColumnLayout {
            id: _columnInfo
            anchors.fill: parent
            anchors.margins: 10
            Text {
                text: qsTr("OS version:")
                wrapMode: Text.Wrap
                font.pointSize: 15
                color: Style.textColor
            }
            Text {
                text: osVersion ? osVersion : qsTr("Unknown")
                wrapMode: Text.Wrap
                font.pointSize: 13
                color: Style.informationColor
            }
            Rectangle {
                height: 1
                color: Style.informationColor
                Layout.fillWidth: true
            }

            Text {
                text: qsTr("MAC address:")
                wrapMode: Text.Wrap
                font.pointSize: 15
                color: Style.textColor
            }
            Text {
                text: macAddress ? macAddress : qsTr("Not found")
                wrapMode: Text.Wrap
                font.pointSize: 13
                color: Style.informationColor
            }
            Rectangle {
                height: 1
                color: Style.informationColor
                Layout.fillWidth: true
            }
            GridLayout {
                columns: 2
                Text {
                    text: qsTr("Icons by")
                    wrapMode: Text.Wrap
                    font.pointSize: 13
                    color: Style.informationColor
                }
                Text {
                    text: qsTr("Icons8,")
                    wrapMode: Text.Wrap
                    font.pointSize: 13
                    color: Style.informationColor
                    font.underline: true
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Qt.openUrlExternally("https://icons8.com/")
                        }
                        cursorShape: Qt.PointingHandCursor
                    }
                }
                Text {
                    text: qsTr("Flaticon,")
                    wrapMode: Text.Wrap
                    font.pointSize: 13
                    color: Style.informationColor
                    font.underline: true
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Qt.openUrlExternally("https://www.flaticon.com/")
                        }
                        cursorShape: Qt.PointingHandCursor
                    }
                }
                Text {
                    text: qsTr("Svgrepo")
                    wrapMode: Text.Wrap
                    font.pointSize: 13
                    color: Style.informationColor
                    font.underline: true
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Qt.openUrlExternally("https://www.svgrepo.com/")
                        }
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
            Item {
                Layout.fillHeight: true
            }
            Text {
                text: "https://trikset.com/"
                color: Style.linkColor
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
