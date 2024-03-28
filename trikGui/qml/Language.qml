import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

Rectangle {
    id: _languageSelection
    property var languageSelection: LanguageSelection
    property var idList: _listLanguages
    color: Style.backgroundColor
    Component.onCompleted: {
        languageSelection.setQmlParent(_languageSelection)
    }
    ConfirmAction {
        id: _confirm
        textAction: qsTr("Confirm the change")
        descrAction: qsTr("The controller will be restarted. Do you want to continue?")
        property string targetLanguage: ""
        function noOnClick() {
            _confirm.visible = false
            _confirm.targetLanguage = ""
            _listLanguages.focus = true
        }
        function yesOnClick() {
            languageSelection.switchLanguage(_confirm.targetLanguage)
            _confirm.visible = false
            _confirm.focusButton = "No"
            _confirm.targetLanguage = ""
            _listLanguages.focus = true
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
            color: Style.textColor
        }

        Rectangle {
            id: _mainView
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 10
            clip: true
            color: Style.managersBackColor
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
                    case "de":
                        return iconsPath + "de.png"
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
                    case "de":
                        return "Deutsch"
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
                            _confirm.buttonNo.focus = true
                            break
                        default:
                            break
                        }
                    }
                    Rectangle {
                        id: _languageName
                        anchors.fill: parent
                        radius: 10
                        color: _delegateLanguages.isCurrent ? Style.darkTrikColor : Style.managersBackColor
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
                                color: _delegateLanguages.isCurrent ? "white" : Style.namesColor
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
