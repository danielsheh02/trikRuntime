import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

Rectangle {
    id: _modeSelection
    property var modeSelection: ModeManager
    property var idList: _listModes
    color: Style.backgroundColor
    Component.onCompleted: {
        console.log("ya tuta")
        console.log(modeSelection)
        modeSelection.setQmlParent(_modeSelection)
    }
    ConfirmAction {
        id: _confirm
        textAction: qsTr("Confirm the change")
        descrAction: qsTr("Are you sure you want to change the theme?")
        property string targetMode: ""
        function noOnClick() {
            _confirm.visible = false
            _confirm.targetMode = null
            _listModes.focus = true
        }
        function yesOnClick() {
            modeSelection.switchMode(_confirm.targetMode)
            _confirm.visible = false
            _confirm.focusButton = "No"
            _confirm.targetMode = null
            _listModes.focus = true
        }
    }

    ColumnLayout {
        id: _columMainView
        spacing: 5
        anchors.fill: parent
        anchors.margins: 15

        Text {
            text: qsTr("Select mode:")
            wrapMode: Text.Wrap
            color: Style.textColor
        }

        Rectangle {
            id: _mainView
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 10
            clip: true
            color: Style.managersBackColor
            ListModel {
                id: _dataMode
                ListElement {
                    iconPath: "sun.png"
                    mode: "light"
                    text: qsTr("Light")
                }
                ListElement {
                    iconPath: "moon.png"
                    mode: "dark"
                    text: qsTr("Dark")
                }
            }

            ListView {
                id: _listModes
                anchors.fill: parent
                spacing: 10
                property real lineMargin: 8
                model: _dataMode
                function getCurrentMode() {
                    var currentMode = modeSelection.getCurrentMode()
                    if (currentMode === "light") {
                        return 0
                    } else {
                        return 1
                    }
                }

                currentIndex: getCurrentMode()

                delegate: Item {
                    id: _delegateModes
                    width: _listModes.width
                    implicitHeight: (_textName.implicitHeight > _modeIcon.height ? _textName.implicitHeight : _modeIcon.height) + _listModes.lineMargin
                    property var isCurrent: ListView.isCurrentItem
                    Keys.onPressed: {
                        switch (event.key) {
                        case Qt.Key_Return:
                            _confirm.targetMode = model.mode
                            _confirm.focus = true
                            _confirm.visible = true
                            break
                        default:
                            break
                        }
                    }
                    Rectangle {
                        id: _modeName
                        anchors.fill: parent
                        radius: 10
                        color: _delegateModes.isCurrent ? Style.darkTrikColor : Style.managersBackColor
                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 5
                            spacing: 5
                            Image {
                                id: _modeIcon
                                source: iconsPath + model.iconPath
                                Layout.preferredWidth: _modeSelection.width
                                                       < 400 ? _modeSelection.width
                                                               / 7 : _modeSelection.width / 25
                                Layout.preferredHeight: _modeSelection.width
                                                        < 400 ? _modeSelection.width
                                                                / 7 : _modeSelection.width / 25
                                Layout.alignment: Qt.AlignVCenter
                            }
                            Text {
                                id: _textName
                                text: model.text
                                Layout.alignment: Qt.AlignVCenter
                                color: _delegateModes.isCurrent ? "white" : Style.namesColor
                                width: _modeName.width - _modeIcon.width
                                wrapMode: Text.Wrap
                                Layout.fillWidth: true
                            }
                        }
                    }
                }
            }
        }
    }
}
