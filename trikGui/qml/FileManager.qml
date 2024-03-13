import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import QtQml.Models 2.1

Rectangle {
    id: _fileManager
    property var fileManager: FileManagerServer
    property var fileSystemModel: fileManager.fileSystemModel
    property var idList: _listFiles
    color: Style.backgroundColor
    Component.onCompleted: {
        fileManager.setQmlParent(_fileManager)
    }

    ConfirmAction {
        id: _confirm
        textAction: qsTr("Confirm delition")
        descrAction: _confirm.deleteAll ? qsTr("Are you sure you want to delete all the files?") : qsTr(
                                              "Are you sure you want to delete file?")
        property bool deleteAll: false
        function noOnClick() {
            if (!_confirm.deleteAll) {
                _listFiles.focus = true
            } else {
                _buttonDeleteAll.focus = true
            }
            _confirm.visible = false
        }
        function yesOnClick() {
            if (!_confirm.deleteAll) {
                fileManager.remove(visualModel.modelIndex(
                                       _listFiles.currentIndex))
                _listFiles.focus = true
            } else {
                fileManager.removeAll()
                _buttonDeleteAll.focus = true
            }
            _confirm.visible = false
            _confirm.focusButton = "No"
        }
    }
    ColumnLayout {
        id: _columMainView
        spacing: 5
        anchors.fill: parent
        anchors.margins: 15
        property string currentPath: fileManager.currentPath
        Text {
            text: _columMainView.currentPath
            wrapMode: Text.Wrap
            Layout.fillWidth: true
            color: Style.textColor
        }

        Rectangle {
            id: _mainView
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 13
            clip: true
            color: Style.managersBackColor
            Connections {
                target: FileManagerServer
                onFileSystemModelChanged: {
                    _columMainView.currentPath = fileManager.currentPath
                    _listFiles.model.rootIndex = fileManager.indexOfCurrentPath
                    _listFiles.currentIndex = 0
                }
            }

            ColumnLayout {
                id: _columnListView
                anchors.fill: parent
                property bool focusListView: true
                ListView {
                    id: _listFiles
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 10

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
                        policy: _listFiles.contentHeight
                                > _listFiles.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
                    }
                    property real lineMargin: 8
                    function getFileExtension(filename, index) {
                        if (fileManager.isDir(visualModel.modelIndex(index))) {
                            return iconsPath + "folder.png"
                        }
                        var parts = filename.split('.')
                        if (parts.length > 1) {
                            switch (parts[parts.length - 1]) {
                            case "py":
                                return iconsPath + "pyFile.png"
                            case "js":
                                return iconsPath + "jsFile.png"
                            default:
                                return iconsPath + "file.png"
                            }
                        } else {
                            return iconsPath + "file.png"
                        }
                    }
                    model: DelegateModel {
                        id: visualModel
                        model: fileSystemModel
                        rootIndex: fileManager.indexOfCurrentPath
                        delegate: Item {
                            id: _delegateFiles
                            width: _listFiles.width
                            implicitHeight: (_textName.implicitHeight > _fileIcon.height ? _textName.implicitHeight : _fileIcon.height) + _listFiles.lineMargin
                            property var isCurrent: ListView.isCurrentItem
                            Keys.onPressed: {
                                switch (event.key) {
                                case Qt.Key_Return:
                                    fileManager.open(
                                                visualModel.modelIndex(index))
                                    break
                                case Qt.Key_Right:
                                    _confirm.deleteAll = false
                                    _listFiles.focus = false
                                    _confirm.focus = true
                                    _confirm.visible = true
                                    break
                                case Qt.Key_Down:
                                    if (_listFiles.count - 1 === index) {
                                        _buttonDeleteAll.focus = true
                                    }

                                    break
                                default:
                                    break
                                }
                            }
                            Rectangle {
                                id: _fileName
                                anchors.fill: parent
                                radius: 10
                                color: _delegateFiles.isCurrent
                                       && _listFiles.focus ? Style.darkTrikColor : Style.managersBackColor
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 5
                                    spacing: 5
                                    Image {
                                        id: _fileIcon
                                        source: _listFiles.getFileExtension(
                                                    display, index)
                                        Layout.preferredWidth: _fileManager.width < 400 ? _fileManager.width / 9 : _fileManager.width / 25
                                        Layout.preferredHeight: _fileManager.width < 400 ? _fileManager.width / 9 : _fileManager.width / 25
                                        Layout.alignment: Qt.AlignVCenter
                                    }
                                    Text {
                                        id: _textName
                                        text: display
                                        color: _delegateFiles.isCurrent
                                               && _listFiles.focus ? "white" : Style.namesColor
                                        Layout.fillWidth: true
                                        Layout.rightMargin: 7
                                        Layout.alignment: Qt.AlignVCenter
                                        wrapMode: Text.Wrap
                                    }
                                }
                            }
                        }
                    }
                }
                Button {
                    id: _buttonDeleteAll
                    text: qsTr("Delete all ...")
                    palette.buttonText: "white"

                    background: Rectangle {
                        color: _buttonDeleteAll.focus ? Style.darkTrikColor : Style.buttonsColor
                        radius: 10
                    }
                    Layout.alignment: Qt.AlignBottom
                    Layout.fillWidth: true
                    onClicked: {
                        _confirm.deleteAll = true
                        _buttonDeleteAll.focus = false
                        _confirm.focus = true
                        _confirm.visible = true
                    }
                    Keys.onPressed: {
                        switch (event.key) {
                        case Qt.Key_Return:
                            _buttonDeleteAll.clicked()
                            break
                        case Qt.Key_Up:
                            _listFiles.focus = true
                            break
                        default:
                            break
                        }
                    }
                }
            }
        }
    }
}
