import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import MainMenuManager 1.0

Rectangle {
    id: _mainMenuView
    property var network: Network
    property var idList: _gridView
    property var timer: _holdTimer
    property var confirmWindow: _confirm

    Connections {
        target: RunningCode
        property var runningCodeObject: null

        onShowRunningCodeComponent: {
            var RunningCodeComponent = Qt.createComponent(
                        "RunningCodeComponent.qml")
            if (RunningCodeComponent.status === Component.Ready) {
                var object = RunningCodeComponent.createObject(_mainMenuView)
                if (object === null) {
                    console.log("Error creating object")
                }
                if (programName === "direct command") {
                    object.idText.text = qsTr("Running direct command")
                } else {
                    object.idText.text = qsTr("Running ") + programName
                }
                runningCodeObject = object
                object.focus = true
                stack.push(object)
            } else if (RunningCodeComponent.status === Component.Error) {
                console.error("Error loading component:",
                              RunningCodeComponent.errorString())
            }
        }
        onHideRunningCodeComponent: {
            if (runningCodeObject === stack.currentItem) {
                stack.currentItem.destroy()
                stack.pop()
                if (stack.currentItem.idList) {
                    stack.currentItem.idList.focus = true
                }
            }
        }
        onHideScriptComponent: {
            if (runningCodeObject === stack.currentItem) {
                stack.currentItem.destroy()
                stack.pop()
                if (stack.currentItem.idList) {
                    stack.currentItem.idList.focus = true
                }
            }
        }
        onShowErrorRunningCodeComponent: {
            if (runningCodeObject === stack.currentItem) {
                stack.currentItem.idText.text = error
                stack.currentItem.idText.color = "red"
            }
        }
    }

    Timer {
        id: _holdTimer
        interval: 1800
        repeat: true
        property int count: 0
        onTriggered: {
            if (_holdTimer.count === 0) {
                _confirm.focus = true
                _confirm.visible = true
                count++
            } else {
                MainMenuManager.shutdown()
            }
        }
    }

    Rectangle {
        id: _confirm
        width: parent.width / 1.05
        height: parent.height / 3.8
        z: 1
        color: Style.confirmWindowColor
        radius: 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        border.color: Style.delimeterLineColor
        border.width: 1
        visible: false

        RowLayout {
            id: _rowConfrim
            anchors.fill: parent
            anchors.margins: 10
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
                text: qsTr("Keep holding to turn off the controller.")
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                font.pointSize: 12
                Layout.rightMargin: 5
                color: Style.textColor
            }
        }
    }

    ListModel {
        id: _menuItems
        ListElement {
            text: qsTr("Files")
            iconPath: "files.png"
            filePath: "FileManager.qml"
            appType: AppType.Files
        }
        ListElement {
            text: qsTr("Testing")
            iconPath: "testing.png"
            filePath: "Testing.qml"
            appType: AppType.Testing
        }
        ListElement {
            text: qsTr("Settings")
            iconPath: "settings.png"
            filePath: "Settings.qml"
            appType: AppType.Settings
        }
        ListElement {
            text: qsTr("Feedback")
            iconPath: "telegram.png"
            filePath: "Feedback.qml"
            appType: AppType.Feedback
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        anchors.topMargin: 7
        Text {
            text: qsTr("Name: ") + (network !== null ? network.hostName : "")
            Layout.fillWidth: true
            font.pointSize: 12
            wrapMode: Text.Wrap
            color: Style.textColor
        }
        Text {
            text: qsTr("IP: ")
                  + (network !== null ? (network.ip !== "" ? network.ip : qsTr(
                                                                 "no connection")) : qsTr(
                                            "no connection"))
            Layout.fillWidth: true
            font.pointSize: 12
            wrapMode: Text.Wrap
            color: Style.textColor
        }
        Text {
            text: qsTr("Hull number: ") + (network !== null ? network.hullNumber : "")
            Layout.fillWidth: true
            font.pointSize: 12
            wrapMode: Text.Wrap
            color: Style.textColor
        }
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            GridView {
                id: _gridView
                anchors.fill: parent
                anchors.topMargin: 15
                cellWidth: parent.width / 2
                model: _menuItems
                property real maxTextLen: 12
                Component.onCompleted: {
                    focus = true
                }
                Keys.onPressed: {
                    if (event.key === Qt.Key_Right
                            && _gridView.currentIndex === _menuItems.count - 1) {
                        _gridView.currentIndex = 0
                        event.accepted = true
                    }
                    if (event.key === Qt.Key_Left
                            && _gridView.currentIndex === 0) {
                        _gridView.currentIndex = _menuItems.count - 1
                        event.accepted = true
                    }
                }

                delegate: ColumnLayout {
                    id: _delegate
                    property bool isCurrent: GridView.isCurrentItem
                    spacing: 0

                    width: _gridView.cellWidth
                    Keys.onPressed: {
                        switch (event.key) {
                        case Qt.Key_Return:
                            MainMenuManager.createApp(model.appType)

                            var component = Qt.createComponent(model.filePath)
                            if (component.status === Component.Ready) {
                                var object = component.createObject(
                                            _mainMenuView)
                                if (object === null) {
                                    console.log("Error creating object")
                                }

                                stack.push(object)
                                object.idList.focus = true
                            } else if (component.status === Component.Error) {
                                console.error("Error loading component:",
                                              component.errorString())
                            }
                            break
                        default:
                            break
                        }
                    }

                    Item {
                        property real iconMargin: 12
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: _iconMenu.width + iconMargin
                        Layout.preferredHeight: _iconMenu.height + iconMargin
                        Rectangle {
                            id: _iconWrapper
                            anchors.fill: parent
                            radius: 10
                            border.color: _delegate.isCurrent ? Style.lightOrStandartGreenColor : "transparent"
                            border.width: _delegate.isCurrent ? 4 : 0
                            color: Style.elementsOfGridColor
                            Image {
                                id: _iconMenu
                                source: iconsPath + model.iconPath
                                anchors.centerIn: parent
                                width: _mainMenuView.width
                                       < 400 ? _mainMenuView.width / 5 : _mainMenuView.width / 23
                                height: _mainMenuView.width
                                        < 400 ? _mainMenuView.width / 5 : _mainMenuView.width / 23
                            }
                        }
                    }
                    Text {
                        id: _text
                        text: model.text.length
                              > _gridView.maxTextLen ? model.text.substring(
                                                           0,
                                                           _gridView.maxTextLen)
                                                       + "..." : model.text
                        Layout.alignment: Qt.AlignHCenter
                        wrapMode: Text.Wrap
                        font.pointSize: 12
                        Layout.maximumWidth: parent.width
                        color: Style.textColor
                    }
                }
            }
        }
    }
}
