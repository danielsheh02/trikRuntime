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
                    color: "#3BB050"
                    width: _delegateLever.isCurrent ? 3 : 0
                }
                Text {
                    text: display.nameLabel
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.leftMargin: 10
                    anchors.topMargin: 5
                }

                Switch {
                    id: control
                    anchors.right: parent.right
                    anchors.top: parent.top
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
                        color: display.isOn ? "#3BB050" : "#ffffff"
                        border.color: display.isOn ? "#3BB050" : "#cccccc"
                        Rectangle {
                            x: display.isOn ? parent.width - width : 0
                            width: parent.width / 2
                            height: parent.height
                            radius: 13
                            color: control.down ? "#cccccc" : "#ffffff"
                            border.color: display.isOn ? "#3BB050" : "#999999"
                        }
                    }
                }

                SpinBox {
                    id: _sb
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    width: parent.width / 2
                    height: parent.height / 2.3
                    font.pointSize: 13
                    anchors.bottomMargin: 0
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

                    contentItem: Rectangle {
                        id: _counter
                        border.color: "#D8D8D8"
                        anchors.right: _up.left
                        anchors.top: parent.top
                        anchors.left: _down.right
                        anchors.bottom: parent.bottom
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
                        border.color: enabled ? "#21be2b" : "#bdbebf"
                        Text {
                            text: '+'
                            font.pointSize: 17
                            anchors.centerIn: parent
                        }
                    }
                    down.indicator: Rectangle {
                        id: _down
                        height: parent.height
                        width: parent.width / 3
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        color: _sb.down.pressed ? "#e4e4e4" : "#f6f6f6"
                        border.color: enabled ? Style.trikColor : "#bdbebf"
                        Text {
                            text: '-'
                            font.pointSize: 17
                            anchors.centerIn: parent
                        }
                    }
                }
            }
        }
    }
}
