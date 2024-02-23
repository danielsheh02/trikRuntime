import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Rectangle {
    id: _runningCode
    color: Style.backgroundColor
    property var idText: _scriptInfo
    Keys.onPressed: {
        switch (event.key) {
        case Qt.Key_Escape:
            event.accepted = true
            break
        case Qt.Key_PowerOff:
            RunningCode.abortScript()
            event.accepted = true
            break
        case Qt.Key_W:
            if (event.modifiers & Qt.ControlModifier) {
                RunningCode.abortScript()
                event.accepted = true
            }
            break
        }
    }

    ColumnLayout {
        id: _columnInfo
        anchors.fill: parent
        anchors.margins: 10
        spacing: 20

        Text {
            id: _scriptInfo
            wrapMode: Text.Wrap
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            text: qsTr("Press Power to abort")
            wrapMode: Text.Wrap
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
