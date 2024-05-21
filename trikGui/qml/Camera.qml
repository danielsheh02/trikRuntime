import QtQuick 2.0

Rectangle {
    id: _camera
    property var sensors: Sensors
    property var idList: _listSensors
    color: activeTheme.backgroundColor
    Component.onCompleted: {
        sensors.setQmlParent(_camera)
    }
    ListView {
        id: _listSensors
        anchors.fill: parent
        model: Sensors

        delegate: Item {
            id: _item
            height: _listSensors.height
            width: _listSensors.width
            property string src: ""
            Loader {
                id: _loader
                anchors.fill: parent
                sourceComponent: null
                Connections {
                    target: display
                    onImageChanged: {
                        _loader.sourceComponent = _imageComponent
                        _item.src = ""
                        _item.src = "image://cameraImageProvider"
                    }
                    onCameraUnavailable: {
                        _loader.sourceComponent = _txtComponent
                    }
                }
            }
            Component {
                id: _txtComponent
                Text {
                    id: _txtNotify
                    text: qsTr("Camera is not available")
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: activeTheme.textColor
                }
            }
            Component {
                id: _imageComponent
                Image {
                    id: _imageView
                    // source: display.namePhoto ? "file:" + display.namePhoto : ""
                    source: _item.src
                    width: parent.width
                    height: parent.width
                    fillMode: Image.PreserveAspectFit
                    cache: false
                }
            }
        }
    }
}
