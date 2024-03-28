import QtQuick 2.0
import QtQuick.Templates 2.0 as T

T.Switch {
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
