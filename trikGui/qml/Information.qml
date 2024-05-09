import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

// import "Data" 1.0
Rectangle {
    id: _information
    property var systemInformation: SystemInformation
    property string osVersion: SystemInformation.osVersion()
    property string macAddress: SystemInformation.macAddress()
    color: activeTheme.backgroundColor
    Component.onCompleted: {
        systemInformation.setQmlParent(_information)
    }
    Rectangle {
        anchors.fill: parent
        radius: 10
        anchors.margins: 15
        color: activeTheme.managersBackColor
        ColumnLayout {
            id: _columnInfo
            anchors.fill: parent
            anchors.margins: 10
            Text {
                text: qsTr("OS version:")
                wrapMode: Text.Wrap
                font.pointSize: 15
                color: activeTheme.textColor
            }
            Text {
                text: _information.osVersion ? _information.osVersion : qsTr(
                                                   "Unknown")
                wrapMode: Text.Wrap
                font.pointSize: 13
                color: activeTheme.informationColor
            }
            Rectangle {
                height: 1
                color: activeTheme.informationColor
                Layout.fillWidth: true
            }

            Text {
                text: qsTr("MAC address:")
                wrapMode: Text.Wrap
                font.pointSize: 15
                color: activeTheme.textColor
            }
            Text {
                text: _information.macAddress ? _information.macAddress : qsTr(
                                                    "Not found")
                wrapMode: Text.Wrap
                font.pointSize: 13
                color: activeTheme.informationColor
            }
            Rectangle {
                height: 1
                color: activeTheme.informationColor
                Layout.fillWidth: true
            }
            GridLayout {
                columns: 2
                Text {
                    text: qsTr("Icons by")
                    wrapMode: Text.Wrap
                    font.pointSize: 11
                    color: activeTheme.informationColor
                }
                Text {
                    text: qsTr("Icons8,")
                    wrapMode: Text.Wrap
                    font.pointSize: 11
                    color: activeTheme.informationColor
                    font.underline: true
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Qt.openUrlExternally("https://icons8.com/")
                        }
                        // cursorShape: Qt.PointingHandCursor
                    }
                }
                Text {
                    text: qsTr("Flaticon,")
                    wrapMode: Text.Wrap
                    font.pointSize: 11
                    color: activeTheme.informationColor
                    font.underline: true
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Qt.openUrlExternally("https://www.flaticon.com/")
                        }
                        // cursorShape: Qt.PointingHandCursor
                    }
                }
                Text {
                    text: qsTr("Svgrepo")
                    wrapMode: Text.Wrap
                    font.pointSize: 11
                    color: activeTheme.informationColor
                    font.underline: true
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Qt.openUrlExternally("https://www.svgrepo.com/")
                        }
                        // cursorShape: Qt.PointingHandCursor
                    }
                }
            }
            Item {
                Layout.fillHeight: true
            }
            Text {
                text: "https://trikset.com/"
                color: activeTheme.linkColor
                font.underline: true
                Layout.alignment: Qt.AlignHCenter
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        Qt.openUrlExternally("https://trikset.com/")
                    }

                    // cursorShape: Qt.PointingHandCursor
                }
            }
        }
    }
}
