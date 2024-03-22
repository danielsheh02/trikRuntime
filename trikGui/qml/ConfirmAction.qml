import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

Rectangle {
    width: parent.width / 1.05
    implicitHeight: _columnConfirm.implicitHeight
    z: 1
    color: Style.confirmWindowColor
    radius: 10
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    border.color: Style.delimeterLineColor
    border.width: 1
    visible: false
    property string focusButton: "No"
    property string textAction: ""
    property string descrAction: ""
    property var buttonNo: _buttonNo

    Keys.onPressed: {
        switch (event.key) {
        case Qt.Key_Right:

            if (focusButton === "No") {
                focusButton = "Yes"
                _buttonYes.focus = true
            }
            break
        case Qt.Key_Left:
            if (focusButton === "Yes") {
                focusButton = "No"
                _buttonNo.focus = true
            }
            break
        case Qt.Key_Return:
            if (focusButton === "Yes") {
                _buttonYes.clicked()
            } else if (focusButton === "No") {
                _buttonNo.clicked()
            }
            break
        case Qt.Key_Escape:
            _confirm.visible = false
            break
        case Qt.Key_PowerOff:
            if (!event.isAutoRepeat) {
                _confirm.visible = false
            }
            break
        case Qt.Key_W:
            if (!event.isAutoRepeat) {
                _confirm.visible = false
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
            text: textAction
            wrapMode: Text.Wrap
            Layout.fillWidth: true
            font.pointSize: 12
            horizontalAlignment: Text.AlignHCenter
            Layout.topMargin: 6
            color: Style.textColor
        }
        Rectangle {
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: 1
            color: Style.delimeterLineColor
        }
        RowLayout {
            Layout.fillWidth: true
            Image {
                source: iconsPath + "warningDel.png"
                Layout.preferredWidth: _mainMenuView.width
                                       < 400 ? _mainMenuView.width / 7 : _mainMenuView.width / 25
                Layout.preferredHeight: _mainMenuView.width
                                        < 400 ? _mainMenuView.width / 7 : _mainMenuView.width / 25
                Layout.leftMargin: 5
                Layout.rightMargin: 5
            }

            Text {
                text: descrAction
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                font.pointSize: 12
                Layout.rightMargin: 5
                color: Style.textColor
            }
        }
        RowLayout {
            Layout.alignment: Qt.AlignRight
            Layout.bottomMargin: 5
            Layout.rightMargin: 9
            Layout.topMargin: 6
            Button {
                id: _buttonNo
                text: qsTr("No")
                Layout.preferredHeight: _columnConfirm.width / 6.8
                Layout.preferredWidth: _columnConfirm.width / 3.8
                onClicked: {
                    noOnClick()
                }
            }
            Button {
                id: _buttonYes
                text: qsTr("Yes")
                Layout.preferredHeight: _columnConfirm.width / 6.8
                Layout.preferredWidth: _columnConfirm.width / 3.8
                onClicked: {
                    yesOnClick()
                }
            }
        }
    }
}
