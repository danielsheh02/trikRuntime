import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQml.Models 2.1

Rectangle {
    id: _communication
    color: Style.backgroundColor
    property var communicationSettings: CommunicationSettingsManager.communicationSettings
    property var objectForQmlParentSetting: communicationSettings
    property var idList: _listDigitsHull

    Component.onCompleted: {
        communicationSettings.setQmlParent(_communication)
    }

    Column {
        id: _listsDigits
        spacing: 11
        anchors.fill: parent
        anchors.topMargin: 10
        property string whatFocused: "hull"

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Comm settings")
            font.pointSize: 15
            font.bold: true
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("(Press 'Enter' to edit)")
            font.pointSize: 8
        }
        Text {
            anchors.left: parent.left
            anchors.leftMargin: 10
            text: qsTr("Hull number:")
            font.pointSize: 15
        }
        Item {
            width: parent.width / 3.5
            height: parent.height / 8
            anchors.horizontalCenter: parent.horizontalCenter
            Row {
                width: parent.width
                height: parent.height
                spacing: 2
                Repeater {
                    id: _listDigitsHull
                    property int currentIndex: 0
                    property bool focusDigit: false
                    property int countOfHullElems: 2
                    property string hullNumberStr: communicationSettings.hullNumber
                    model: countOfHullElems
                    width: parent.width
                    height: parent.height
                    function onHullNumberChanged() {
                        var result = 0
                        for (var i = 0; i < _listDigitsHull.count; i++) {
                            var delegate = _listDigitsHull.itemAt(i)
                            result = result * 10 + delegate.currentValue
                        }
                        _communication.communicationSettings.onHullNumberChanged(
                                    result)
                    }

                    delegate: Rectangle {
                        id: _digitHull
                        width: parent.width / 2
                        height: parent.height
                        radius: 5
                        property int currentValue: parseInt(
                                                       _listDigitsHull.hullNumberStr[index])
                        border {
                            color: (_listDigitsHull.focusDigit
                                    && _listsDigits.whatFocused === "hull"
                                    && _listDigitsHull.currentIndex
                                    === index) ? "red" : (_listsDigits.whatFocused === "hull"
                                                          && _listDigitsHull.currentIndex
                                                          === index) ? "#219D38" : "black"
                            width: (_listDigitsHull.focusDigit
                                    && _listsDigits.whatFocused === "hull"
                                    && _listDigitsHull.currentIndex
                                    === index) ? 3 : (_listsDigits.whatFocused === "hull"
                                                      && _listDigitsHull.currentIndex
                                                      === index) ? 3 : 1
                        }
                        Text {
                            anchors.centerIn: parent
                            text: currentValue
                            font.pointSize: 13
                        }
                        Keys.onPressed: {
                            switch (event.key) {
                            case Qt.Key_Return:
                                _listDigitsHull.focusDigit = !_listDigitsHull.focusDigit
                                break
                            case Qt.Key_Up:
                                if (_listDigitsHull.focusDigit) {
                                    currentValue = (currentValue + 1) % 10
                                    _listDigitsHull.onHullNumberChanged()
                                }
                                break
                            case Qt.Key_Down:
                                if (_listDigitsHull.focusDigit) {
                                    currentValue = (currentValue - 1 + 10) % 10
                                    _listDigitsHull.onHullNumberChanged()
                                } else {
                                    _listsDigits.whatFocused = "ip"
                                    _listDigitsIp.itemAt(
                                                _listDigitsIp.currentIndex).focus = true
                                }
                                break
                            case Qt.Key_Right:
                                if (index < _listDigitsHull.countOfHullElems - 1) {
                                    _listDigitsHull.currentIndex = index + 1
                                    _listDigitsHull.itemAt(
                                                _listDigitsHull.currentIndex).focus = true
                                }
                                break
                            case Qt.Key_Left:
                                if (index > 0) {
                                    _listDigitsHull.currentIndex = index - 1
                                    _listDigitsHull.itemAt(
                                                _listDigitsHull.currentIndex).focus = true
                                }
                                break
                            default:
                                break
                            }
                        }
                    }
                }
            }
        }
        Text {
            anchors.left: parent.left
            anchors.leftMargin: 10
            text: qsTr("Leader IP:")
            font.pointSize: 15
        }
        Text {
            anchors.left: parent.left
            anchors.leftMargin: 10
            text: qsTr("(last two numbers)")
            font.pointSize: 10
        }
        Item {
            width: parent.width / 1.5
            height: parent.height / 8
            anchors.horizontalCenter: parent.horizontalCenter
            Row {
                width: parent.width
                height: parent.height
                spacing: 2

                Repeater {
                    id: _listDigitsIp
                    property int currentIndex: 0
                    property bool focusDigit: false
                    property int countOfIpElems: 7
                    property int indexOfSeparator: 3
                    property string ip: communicationSettings.thirdFourthIpPart
                    model: countOfIpElems
                    width: parent.width
                    height: parent.height
                    delegate: Rectangle {
                        id: _digitIp
                        width: (index !== _listDigitsIp.indexOfSeparator) ? parent.width / 7 : parent.width / 11
                        height: parent.height
                        radius: 5
                        property var currentValue: index !== _listDigitsIp.indexOfSeparator ? parseInt(_listDigitsIp.ip[index]) : "."
                        property real maxValue: index === 0
                                                || index === 4 ? 3 : 6
                        color: index
                               !== _listDigitsIp.indexOfSeparator ? "white" : Style.backgroundColor
                        border {
                            color: (_listDigitsIp.focusDigit
                                    && _listsDigits.whatFocused === "ip"
                                    && _listDigitsIp.currentIndex
                                    === index) ? "red" : (_listsDigits.whatFocused === "ip"
                                                          && _listDigitsIp.currentIndex === index) ? "#219D38" : (index !== _listDigitsIp.indexOfSeparator) ? "black" : "transparent"
                            width: (_listDigitsIp.focusDigit
                                    && _listsDigits.whatFocused === "ip"
                                    && _listDigitsIp.currentIndex
                                    === index) ? 3 : (_listsDigits.whatFocused === "ip"
                                                      && _listDigitsIp.currentIndex
                                                      === index) ? 3 : 1
                        }

                        Text {
                            anchors.centerIn: parent
                            text: currentValue
                            font.pointSize: index !== _listDigitsIp.indexOfSeparator ? 13 : 25
                        }

                        Keys.onPressed: {
                            switch (event.key) {
                            case Qt.Key_Return:
                                _listDigitsIp.focusDigit = !_listDigitsIp.focusDigit
                                break
                            case Qt.Key_Up:
                                if (_listDigitsIp.focusDigit) {
                                    currentValue = (currentValue + 1) % maxValue
                                } else {
                                    _listsDigits.whatFocused = "hull"
                                    _listDigitsHull.itemAt(
                                                _listDigitsHull.currentIndex).focus = true
                                }
                                break
                            case Qt.Key_Down:
                                if (_listDigitsIp.focusDigit) {
                                    currentValue = (currentValue - 1 + maxValue) % maxValue
                                } else {
                                    _listsDigits.whatFocused = "button"
                                    _button.focus = true
                                }
                                break
                            case Qt.Key_Right:
                                if (index !== 2
                                        && index < _listDigitsIp.countOfIpElems - 1) {
                                    _listDigitsIp.currentIndex = index + 1
                                    _listDigitsIp.itemAt(
                                                _listDigitsIp.currentIndex).focus = true
                                } else if (index === 2) {
                                    _listDigitsIp.currentIndex = index + 2
                                    _listDigitsIp.itemAt(
                                                _listDigitsIp.currentIndex).focus = true
                                }
                                break
                            case Qt.Key_Left:
                                if (index !== 4 && index > 0) {
                                    _listDigitsIp.currentIndex = index - 1
                                    _listDigitsIp.itemAt(
                                                _listDigitsIp.currentIndex).focus = true
                                } else if (index === 4) {
                                    _listDigitsIp.currentIndex = index - 2
                                    _listDigitsIp.itemAt(
                                                _listDigitsIp.currentIndex).focus = true
                                }
                                break
                            default:
                                break
                            }
                        }
                    }
                }
            }
        }
        Button {
            id: _button
            height: parent.height / 10
            text: qsTr("Connect")
            palette.buttonText: "white"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 8
            background: Rectangle {
                color: _button.focus ? "#219D38" : "#7D7D7D"
                radius: 10
            }
            function onConnectButtonClicked() {
                var result = ""
                for (var i = 0; i < _listDigitsIp.count; i++) {
                    var delegate = _listDigitsIp.itemAt(i)
                    result = result + delegate.currentValue
                }
                _communication.communicationSettings.onConnectButtonClicked(
                            result)
            }
            Keys.onPressed: {
                switch (event.key) {
                case Qt.Key_Up:
                    _listsDigits.whatFocused = "ip"
                    _listDigitsIp.itemAt(
                                _listDigitsIp.currentIndex).focus = true
                    break
                case Qt.Key_Return:
                    _button.onConnectButtonClicked()
                    break
                default:
                    break
                }
            }
        }
    }
}
