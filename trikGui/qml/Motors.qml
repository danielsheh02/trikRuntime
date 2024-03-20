import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle {
    id: _motorsPanel
    property var motorsManager: MotorsManager
    property var motors: motorsManager.motors
    property var idList: _listMotorsLevers
    color: Style.backgroundColor

    ListView {
        id: _listMotorsLevers
        anchors.fill: parent
        model: motors
        spacing: 4
        anchors.topMargin: 4
        anchors.bottomMargin: 4

        ScrollBar.vertical: ScrollBar {
            id: _scroll
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            contentItem: Rectangle {
                implicitWidth: 5
                radius: 10
                color: "#B6B5B5"
            }
            policy: _listMotorsLevers.contentHeight
                    > _listMotorsLevers.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
        }
        delegate: Item {
            id: _delegateLever
            width: _listMotorsLevers.width
            height: _listMotorsLevers.height / 4.2
            property var isCurrent: ListView.isCurrentItem
            Keys.onPressed: {
                switch (event.key) {
                case Qt.Key_Enter:
                    display.isOn = !display.isOn
                    break
                case Qt.Key_Return:
                    display.isOn = !display.isOn
                    break
                case Qt.Key_Right:
                    _sb.increase()
                    break
                case Qt.Key_Left:
                    _sb.decrease()
                    break
                default:
                    break
                }
            }
            Rectangle {
                id: _motorLever
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                radius: 10
                border {
                    color: Style.trikColor
                    width: _delegateLever.isCurrent ? 3 : 0
                }
                color: Style.elementsOfListColor
                Text {
                    text: display.nameLabel
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 10
                    anchors.topMargin: 5
                    color: Style.textColor
                }

                Switch {
                    id: control
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 8
                    anchors.topMargin: 6
                    width: parent.width / 5.3
                    height: parent.height / 3.3

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            control.down = false
                            display.isOn = !display.isOn
                        }
                        onPressed: {
                            control.down = true
                        }
                    }
                    indicator: Rectangle {
                        width: parent.width
                        height: parent.height
                        radius: 13
                        color: display.isOn ? Style.trikColor : Style.switchBorderColor3
                        border.color: display.isOn ? Style.trikColor : Style.switchBorderColor1
                        Rectangle {
                            x: display.isOn ? parent.width - width : 0
                            width: parent.width / 2
                            height: parent.height
                            radius: 13
                            color: control.down ? "#CCCCCC" : Style.switchBorderColor3
                            border.color: display.isOn ? Style.trikColor : Style.switchBorderColor2
                        }
                    }
                }

                SpinBox {
                    id: _sb
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width / 2
                    height: parent.height / 2.3
                    font.pointSize: 13
                    value: display.power
                    from: display.minPower
                    to: display.maxPower
                    stepSize: display.powerStep

                    onValueChanged: {
                        // Check against binding loop
                        if (display.power !== value) {
                            display.power = value
                        }
                    }

                    background: Rectangle {
                        id: _counter
                        border.color: Style.spinBorderColor
                        anchors.fill: parent
                        radius: 10
                        Text {
                            id: _textCounter
                            text: _sb.value
                            anchors.centerIn: parent
                        }
                    }

                    up.indicator: Rectangle {
                        id: _up
                        height: parent.height
                        width: parent.width / 3
                        anchors.right: parent.right
                        anchors.top: parent.top
                        color: _sb.up.pressed ? "#e4e4e4" : "#f6f6f6"
                        border.color: Style.spinBorderColor
                        radius: 10
                        Text {
                            text: '+'
                            font.pointSize: 17
                            anchors.centerIn: parent
                            color: enabled ? "black" : "#919191"
                        }
                    }
                    down.indicator: Rectangle {
                        id: _down
                        height: parent.height
                        width: parent.width / 3
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        color: _sb.down.pressed ? "#e4e4e4" : "#f6f6f6"
                        border.color: Style.spinBorderColor
                        radius: 10
                        Text {
                            text: '-'
                            font.pointSize: 17
                            anchors.centerIn: parent
                            color: enabled ? "black" : "#919191"
                        }
                    }
                }
            }
        }
    }
}
