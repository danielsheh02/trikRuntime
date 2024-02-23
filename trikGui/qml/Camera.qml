import QtQuick 2.0

Rectangle {
    id: _camera
    property var sensorsManager: SensorsManager
    property var sensors: sensorsManager.sensors
    property var idList: _listSensors
    color: Style.backgroundColor

    ListView {
        id: _listSensors
        anchors.fill: parent
        model: sensors

        delegate: Item {
            id: _item
            anchors.fill: parent
            Connections {
                target: display
                onImageChanged: {
                    _imageView.source = ""
                    _imageView.source = "image://cameraImageProvider"
                }
            }
            Image {
                id: _imageView
                // source: display.namePhoto ? "file:" + display.namePhoto : ""
                source: ""
                width: parent.width
                height: parent.width
                fillMode: Image.PreserveAspectFit
                cache: false
            }
        }
    }
}
