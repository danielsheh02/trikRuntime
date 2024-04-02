import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

Rectangle {
    color: Style.backgroundColor
    ColumnLayout {
        id: _columnInfo
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5

        Text {
            text: qsTr("Please leave an anonymous review about new interface.")
            wrapMode: Text.Wrap
            Layout.fillWidth: true
            Layout.fillHeight: true
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 13
            color: Style.textColor
            Layout.bottomMargin: 13
        }

        Image {
            id: _qrCodeImage
            source: FeedbackServer.nameImage ? "file:" + FeedbackServer.nameImage : ""
            Layout.fillHeight: true
            Layout.preferredWidth: height
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
