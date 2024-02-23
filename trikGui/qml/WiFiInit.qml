import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Rectangle {
    color: Style.backgroundColor
    property var wiFiInit: WiFiInitServer

    Keys.onPressed: {
        switch (event.key) {
        case Qt.Key_Escape:
            wiFiInit.exit()
            event.accepted = true
            break
        case Qt.Key_PowerOff:
            event.accepted = true
            break
        case Qt.Key_W:
            if (event.modifiers & Qt.ControlModifier) {
                event.accepted = true
            }
            break
        default:
            break
        }
    }
    ColumnLayout {
        id: _columnInfo
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Text {
            text: qsTr("Network initialization in process")
            wrapMode: Text.Wrap
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
        }
        Text {
            text: qsTr("Please wait")
            wrapMode: Text.Wrap
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
        }
        ProgressBar {
            indeterminate: true
            palette.dark: Style.trikColor
            Layout.fillWidth: true
            background: Rectangle {
                color: "white"
                radius: 3
            }
        }

        Text {
            text: qsTr("Press Escape for break")
            wrapMode: Text.Wrap
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
