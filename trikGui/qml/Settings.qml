import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import MainMenuManager 1.0
import WiFiMode 1.0

Rectangle {
    id: _mainItem
    color: Style.backgroundColor
    property var idList: _listSettings

    ListModel {
        id: dataModelSettings
        ListElement {
            iconPath: "network.png"
            filePath: "WiFiMode.qml"
            text: qsTr("Network")
            appType: AppType.Network
        }
        ListElement {
            iconPath: "communicationsettings.png"
            filePath: "CommunicationSettings.qml"
            text: qsTr("Comm settings")
            appType: AppType.CommSettings
        }
        ListElement {
            iconPath: "language.png"
            filePath: "Language.qml"
            text: qsTr("Language")
            appType: AppType.Language
        }
        ListElement {
            iconPath: "systemsettings.png"
            filePath: "SystemSettings.qml"
            text: qsTr("System settings")
            appType: AppType.SystemSettings
        }
        ListElement {
            iconPath: "palette.png"
            filePath: "Mode.qml"
            text: qsTr("Appearance")
            appType: AppType.AppearanceMode
        }
        ListElement {
            iconPath: "version.png"
            filePath: "Information.qml"
            text: qsTr("About")
            appType: AppType.Information
        }
    }

    ListView {
        id: _listSettings
        anchors.fill: parent
        anchors.topMargin: 4
        anchors.bottomMargin: 4
        model: dataModelSettings
        spacing: 7
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
            policy: _listSettings.contentHeight
                    > _listSettings.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
        }
        Keys.onPressed: {
            if (event.key === Qt.Key_Down
                    && _listSettings.currentIndex === dataModelSettings.count - 1) {
                _listSettings.currentIndex = 0
                _listSettings.positionViewAtIndex(0, ListView.Beginning)
                event.accepted = true
            } else if (event.key === Qt.Key_Up
                       && _listSettings.currentIndex === 0) {
                _listSettings.currentIndex = dataModelSettings.count - 1
                _listSettings.positionViewAtIndex(dataModelSettings.count - 1,
                                                  ListView.End)
                event.accepted = true
            }
        }
        delegate: Item {
            id: _delegate
            width: _listSettings.width
            height: _listSettings.height / 5.6
            property bool isCurrent: ListView.isCurrentItem
            Keys.onPressed: {
                switch (event.key) {
                case Qt.Key_Return:
                    MainMenuManager.createApp(model.appType)
                    var component = Qt.createComponent(model.filePath)
                    if (component.status === Component.Ready) {
                        var object = component.createObject(_mainItem)
                        if (object === null) {
                            console.log("Error creating object")
                        }
                        stack.push(object)
                        if (model.appType === AppType.CommSettings) {
                            if (object.idList) {
                                object.idList.itemAt(
                                            object.idList.currentIndex).focus = true
                            } else {
                                object.focus = true
                            }
                        } else {
                            if (object.idList) {
                                object.idList.focus = true
                            } else {
                                object.focus = true
                            }
                        }
                    } else if (component.status === Component.Error) {
                        console.error("Error loading component:",
                                      component.errorString())
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
                color: _delegate.isCurrent ? Style.focusElementsOfListColor : Style.elementsOfListColor

                RowLayout {
                    id: _row
                    anchors.fill: parent
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
                        Layout.rightMargin: 3
                        Layout.alignment: Qt.AlignVCenter
                        color: Style.textColor
                    }
                }
            }
        }
    }
}
