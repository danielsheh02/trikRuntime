import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import MainMenuManager 1.0

Rectangle {
    id: _mainMenuView
    property var network: Network
    property var idList: _gridView
    property var timer: _holdTimer

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
                object.idText.text = qsTr("Running ") + programName
                object.idText.color = "black"
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
        interval: 2000

        onTriggered: {
            _confirm.focus = true
            _confirm.visible = true
        }
    }

    Rectangle {
        id: _confirm
        width: parent.width / 1.05
        implicitHeight: _columnConfirm.implicitHeight
        z: 1
        color: "#D8D8D8"
        radius: 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        border.color: "black"
        border.width: 1
        property string focusButton: "No"
        property string targetLanguage: ""
        visible: false

        Keys.onPressed: {
            switch (event.key) {
            case Qt.Key_Right:
                if (focusButton === "No") {
                    focusButton = "Yes"
                }
                break
            case Qt.Key_Left:
                if (focusButton === "Yes") {
                    focusButton = "No"
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
                text: qsTr("Confirm the shutdown")
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                font.pointSize: 12
                horizontalAlignment: Text.AlignHCenter
                Layout.topMargin: 6
            }
            Rectangle {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: 1
                color: "black"
            }
            RowLayout {
                Layout.fillWidth: true
                Image {
                    source: iconsPath + "warningDel.png"
                    Layout.preferredWidth: _mainMenuView.width
                                           < 400 ? _mainMenuView.width
                                                   / 7 : _mainMenuView.width / 25
                    Layout.preferredHeight: _mainMenuView.width
                                            < 400 ? _mainMenuView.width
                                                    / 7 : _mainMenuView.width / 25
                    Layout.leftMargin: 5
                    Layout.rightMargin: 5
                }

                Text {
                    text: qsTr("Are you sure you want to shutdown the controller?")
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                    font.pointSize: 12
                    Layout.rightMargin: 5
                }
            }
            RowLayout {
                Layout.alignment: Qt.AlignRight
                Layout.bottomMargin: 7
                Layout.rightMargin: 9
                Layout.topMargin: 9
                Button {
                    id: _buttonNo
                    text: qsTr("No")
                    palette.buttonText: "white"
                    background: Rectangle {
                        color: _confirm.focusButton === "No" ? "#3BB050" : "#7D7D7D"
                        radius: 10
                    }
                    onClicked: {
                        _confirm.visible = false
                        _confirm.targetLanguage = ""
                        _gridView.focus = true
                    }
                }
                Button {
                    id: _buttonYes
                    text: qsTr("Yes")
                    palette.buttonText: "white"
                    background: Rectangle {
                        color: _confirm.focusButton === "Yes" ? "#3BB050" : "#7D7D7D"
                        radius: 10
                    }
                    onClicked: {
                        MainMenuManager.shutdown()
                    }
                }
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
        // ListElement {
        //     text: qsTr("Camera")
        //     iconPath: "camera.png"
        //     filePath: ""
        // }
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
        }
        Text {
            text: qsTr("IP: ") + (network !== null ? network.ip : "")
            Layout.fillWidth: true
            font.pointSize: 12
            wrapMode: Text.Wrap
        }
        Text {
            text: qsTr("Hull number: ") + (network !== null ? network.hullNumber : "")
            Layout.fillWidth: true
            font.pointSize: 12
            wrapMode: Text.Wrap
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
                            border.color: _delegate.isCurrent ? "#3BB050" : "transparent"
                            border.width: _delegate.isCurrent ? 4 : 0
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
                    }
                }
            }
        }
    }
}
