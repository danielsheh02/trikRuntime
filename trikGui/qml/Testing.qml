import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import TestingManager 1.0
import QtQml.Models 2.1

Rectangle {
    id: _mainItem
    property var testingManager: TestingManager
    property var idList: _listTesting
    color: Style.backgroundColor
    Component.onCompleted: {
        testingManager.setQmlParent(_mainItem)
    }

    ListModel {
        id: dataModelTesting

        // ListElement {
        //     iconPath: "analog.png"
        //     filePath: "AnalogDigitalSensors.qml"
        //     text: qsTr("Analog sensors")
        //     type: Type.AnalogSensor
        // }
        // ListElement {
        //     iconPath: "digital.png"
        //     filePath: "AnalogDigitalSensors.qml"
        //     text: qsTr("Digital sensors")
        //     type: Type.DigitalSensor
        // }
        Component.onCompleted: {
            if (testingManager.checkPwmCapture()) {
                dataModelTesting.insert(1, {
                                            "iconPath": "pwmcapture.png",
                                            "filePath": "AnalogDigitalSensors.qml",
                                            "text": qsTr("PWM capture"),
                                            "type": Type.PwmCapture
                                        })
            }
        }

        ListElement {
            iconPath: "digital.png"
            filePath: "AnalogDigitalSensors.qml"
            text: qsTr("Sensors")
            type: Type.Sensors
        }
        ListElement {
            iconPath: "servo.png"
            filePath: "Motors.qml"
            text: qsTr("Servo motors")
            type: Type.ServoMotor
        }
        ListElement {
            iconPath: "power.png"
            filePath: "Motors.qml"
            text: qsTr("Power motors")
            type: Type.PowerMotor
        }
        ListElement {
            iconPath: "encoder.png"
            filePath: "Encoders.qml"
            text: qsTr("Encoders")
            type: Type.Encoder
        }
        ListElement {
            iconPath: "accelerometer.png"
            filePath: "Accelerometer.qml"
            text: qsTr("Accelerometer")
            type: Type.Accelerometer
        }
        ListElement {
            iconPath: "gyroscope.png"
            filePath: "Gyroscope.qml"
            text: qsTr("Gyroscope")
            type: Type.Gyroscope
        }
        ListElement {
            iconPath: "camera.png"
            filePath: "Camera.qml"
            text: qsTr("Camera")
            type: Type.Camera
        }
    }

    ListView {
        id: _listTesting
        anchors.fill: parent
        model: dataModelTesting
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
            policy: _listTesting.contentHeight
                    > _listTesting.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
        }
        delegate: Item {
            id: _delegateMode
            width: _listTesting.width
            height: _listTesting.height / 5.5
            property bool isCurrent: ListView.isCurrentItem
            Keys.onPressed: {
                switch (event.key) {
                case Qt.Key_Return:
                    if (model.text === qsTr("Servo motors")
                            || model.text === qsTr("Power motors")) {
                        testingManager.createMotors(model.type)
                    } else {
                        testingManager.createSensors(model.type)
                    }
                    var TestingComponent = Qt.createComponent(model.filePath)
                    if (TestingComponent.status === Component.Ready) {
                        var objectTesting = TestingComponent.createObject(
                                    _mainItem)
                        if (objectTesting === null) {
                            console.log("Error creating object")
                        }
                        stack.push(objectTesting)
                        objectTesting.idList.focus = true
                        if (model.text === qsTr("Servo motors")
                                || model.text === qsTr("Power motors")) {
                            objectTesting.motors.setQmlParent(objectTesting)
                        } else {
                            objectTesting.sensors.setQmlParent(objectTesting)
                        }
                    } else if (TestingComponent.status === Component.Error) {
                        console.error("Error loading component:",
                                      TestingComponent.errorString())
                    }
                    break
                default:
                    break
                }
            }
            Rectangle {
                id: _mode
                focus: isCurrent
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                radius: 10
                color: _delegateMode.isCurrent ? "#303BB050" : "white"
                RowLayout {
                    id: _row
                    anchors.fill: parent
                    anchors.left: parent.left
                    anchors.leftMargin: 7
                    spacing: parent.width < 400 ? 10 : 15
                    Image {
                        id: _iconDevice
                        source: iconsPath + model.iconPath
                        Layout.preferredWidth: parent.width
                                               < 400 ? _mainItem.width / 5.5 : _mainItem.width / 23
                        Layout.preferredHeight: parent.width
                                                < 400 ? _mainItem.width / 5.5 : _mainItem.width / 23
                        Layout.alignment: Qt.AlignVCenter
                    }
                    Text {
                        id: _textMode
                        text: model.text
                        wrapMode: Text.Wrap
                        Layout.fillWidth: true
                        Layout.rightMargin: 7
                        Layout.alignment: Qt.AlignVCenter
                    }
                }
            }
        }
    }
}
