import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

Rectangle {
    id: _languageSelection
    property var languageSelection: LanguageManager.languageSelection
    property var idList: _listLanguages
    color: Style.backgroundColor
    Component.onCompleted: {
        languageSelection.setQmlParent(_languageSelection)
    }
    Rectangle {
        id: _confirm
        implicitWidth: parent.width / 1.05
        implicitHeight: _columnConfirm.implicitHeight
        z: 1
        color: "#D8D8D8"
        radius: 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        border.color: "black"
        border.width: 1
        property string focusButton: "No"
        property string targetLanguage: ""
        visible: false
        Keys.onPressed: {
            switch (event.key) {
            case Qt.Key_Right:
                if (focusButton === "No") {
                    focusButton = "Yes"
                }
                break
            case Qt.Key_Left:
                if (focusButton === "Yes") {
                    focusButton = "No"
                }
                break
            case Qt.Key_Return:
                if (focusButton === "Yes") {
                    _buttonYes.clicked()
                } else if (focusButton === "No") {
                    _buttonNo.clicked()
                }
                break
            default:
                break
            }
        }
        ColumnLayout {
            id: _columnConfirm
            anchors.fill: parent
            Text {
                text: qsTr("Confirm the change")
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                font.pointSize: 12
                horizontalAlignment: Text.AlignHCenter
                Layout.topMargin: 6
            }
            Rectangle {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: 1
                color: "black"
            }
            RowLayout {
                Layout.fillWidth: true
                Image {
                    source: iconsPath + "warningDel.png"
                    Layout.preferredWidth: _languageSelection.width
                                           < 400 ? _languageSelection.width
                                                   / 7 : _languageSelection.width / 25
                    Layout.preferredHeight: _languageSelection.width
                                            < 400 ? _languageSelection.width
                                                    / 7 : _languageSelection.width / 25
                    Layout.leftMargin: 5
                    Layout.rightMargin: 5
                }

                Text {
                    text: qsTr("Are you sure you want to change the language?")
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                    font.pointSize: 12
                    Layout.rightMargin: 5
                }
            }
            RowLayout {
                Layout.alignment: Qt.AlignRight
                Layout.bottomMargin: 7
                Layout.rightMargin: 9
                Layout.topMargin: 9
                Button {
                    id: _buttonNo
                    text: qsTr("No")
                    palette.buttonText: "white"
                    background: Rectangle {
                        color: _confirm.focusButton === "No" ? "#3BB050" : "#7D7D7D"
                        radius: 10
                    }
                    onClicked: {
                        _confirm.visible = false
                        _confirm.targetLanguage = ""
                        _listLanguages.focus = true
                    }
                }
                Button {
                    id: _buttonYes
                    text: qsTr("Yes")
                    palette.buttonText: "white"
                    background: Rectangle {
                        color: _confirm.focusButton === "Yes" ? "#3BB050" : "#7D7D7D"
                        radius: 10
                    }
                    onClicked: {
                        languageSelection.switchLanguage(
                                    _confirm.targetLanguage)
                        _confirm.visible = false
                        _confirm.focusButton = "No"
                        _confirm.targetLanguage = ""
                        _listLanguages.focus = true
                    }
                }
            }
        }
    }
    ColumnLayout {
        id: _columMainView
        spacing: 5
        anchors.fill: parent
        anchors.margins: 15

        Text {
            text: qsTr("Select language:")
            wrapMode: Text.Wrap
        }

        Rectangle {
            id: _mainView
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 10
            clip: true

            ListView {
                id: _listLanguages
                anchors.fill: parent
                spacing: 10
                property real lineMargin: 8
                model: languageSelection
                function getCurrentLanguage() {
                    for (var i = 0; i < languageSelection.availableLocales.length; i++) {
                        if (languageSelection.availableLocales[i] === Qt.locale(
                                    ).name.slice(0, 2)) {
                            return i
                        }
                    }
                    return 0
                }

                currentIndex: getCurrentLanguage()
                function getLanguageIcon(language) {
                    switch (language) {
                    case "en":
                        return iconsPath + "en.png"
                    case "ru":
                        return iconsPath + "ru.png"
                    case "fr":
                        return iconsPath + "fr.png"
                    }
                }

                function getLanguage(language, index) {
                    switch (language) {
                    case "en":
                        return "English"
                    case "ru":
                        return "Русский"
                    case "fr":
                        return "Française"
                    }
                }

                delegate: Item {
                    id: _delegateLanguages
                    width: _listLanguages.width
                    implicitHeight: (_textName.implicitHeight > _languageIcon.height ? _textName.implicitHeight : _languageIcon.height) + _listLanguages.lineMargin
                    property var isCurrent: ListView.isCurrentItem
                    Keys.onPressed: {
                        switch (event.key) {
                        case Qt.Key_Return:
                            _confirm.targetLanguage = display
                            _confirm.focus = true
                            _confirm.visible = true
                            break
                        default:
                            break
                        }
                    }
                    Rectangle {
                        id: _languageName
                        anchors.fill: parent
                        radius: 10
                        color: _delegateLanguages.isCurrent ? "#219D38" : "white"
                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 5
                            spacing: 5
                            Image {
                                id: _languageIcon
                                source: _listLanguages.getLanguageIcon(display)
                                Layout.preferredWidth: _languageSelection.width
                                                       < 400 ? _languageSelection.width
                                                               / 9 : _languageSelection.width / 25
                                Layout.preferredHeight: _languageSelection.width
                                                        < 400 ? _languageSelection.width
                                                                / 9 : _languageSelection.width / 25
                                Layout.alignment: Qt.AlignVCenter
                            }
                            Text {
                                id: _textName
                                text: _listLanguages.getLanguage(display, index)
                                Layout.alignment: Qt.AlignVCenter
                                color: _delegateLanguages.isCurrent ? "white" : "black"
                                width: _languageName.width - _languageIcon.width
                                wrapMode: Text.Wrap
                                Layout.fillWidth: true
                            }
                        }
                    }
                }
            }
        }
    }
}
