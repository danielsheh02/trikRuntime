import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.0

ApplicationWindow {
    id: root
    visible: true
    minimumHeight: 320
    minimumWidth: 240
    maximumHeight: 320
    maximumWidth: 240
    title: qsTr("TRIK")

    property string iconsPath: "../resourcesQml/"
    property var activeTheme: Style.activeTheme

    ColumnLayout {
        anchors.fill: parent
        spacing: -1

        StatusBar {
            id: _statusBar
            z: 1
            Layout.fillWidth: true
            Layout.preferredHeight: 0.07 * parent.height
            Layout.alignment: Qt.AlignTop
        }

        StackView {
            id: stack
            initialItem: _mainMenu
            Layout.fillWidth: true
            Layout.fillHeight: true
            focus: true

            Keys.onPressed: {
                switch (event.key) {
                case Qt.Key_Escape:
                    if (stack.depth > 1) {
                        stack.currentItem.destroy()
                    }
                    stack.pop()
                    stack.currentItem.idList.focus = true
                    break
                case Qt.Key_PowerOff:
                    if (!event.isAutoRepeat) {
                        while (stack.depth > 1) {
                            stack.currentItem.destroy()
                            stack.pop()
                        }
                        stack.currentItem.idList.currentIndex = 0
                        if (stack.currentItem === _mainMenu) {
                            stack.currentItem.timer.start()
                        }
                    }
                    break
                case Qt.Key_W:
                    if (event.modifiers & Qt.ControlModifier) {
                        if (!event.isAutoRepeat) {
                            while (stack.depth > 1) {
                                stack.currentItem.destroy()
                                stack.pop()
                            }
                            stack.currentItem.idList.currentIndex = 0
                            if (stack.currentItem === _mainMenu) {
                                stack.currentItem.timer.start()
                            }
                        }
                    }
                    break
                default:
                    break
                }
            }
            Keys.onReleased: {
                switch (event.key) {
                case Qt.Key_PowerOff:
                    if (!event.isAutoRepeat
                            && stack.currentItem === _mainMenu) {
                        stack.currentItem.timer.stop()
                        stack.currentItem.timer.count = 0
                        stack.currentItem.confirmWindow.visible = false
                        stack.currentItem.idList.focus = true
                    }
                    break
                case Qt.Key_W:
                    if (event.modifiers & Qt.ControlModifier) {
                        if (!event.isAutoRepeat
                                && stack.currentItem === _mainMenu) {
                            stack.currentItem.timer.stop()
                            stack.currentItem.timer.count = 0
                            stack.currentItem.confirmWindow.visible = false
                            stack.currentItem.idList.focus = true
                        }
                    }
                    break
                default:
                    break
                }
            }
            pushEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 0
                }
            }
            pushExit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 0
                }
            }
            popEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 0
                }
            }
            popExit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 0
                }
            }
            replaceEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 0
                }
            }
            replaceExit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 0
                }
            }
        }
        MainMenu {
            id: _mainMenu
            color: activeTheme.backgroundColor
        }
    }
}
