pragma Singleton

import QtQuick 2.0

QtObject {

    property string mode: ThemeMode
    property color backgroundColor: mode === "light" ? '#70D8D8D8' : '#313131'
    property color progressBarWiFiInitColor: mode === "light" ? 'white' : '#505050'
    property color statusBarColor: mode === "light" ? 'white' : '#232323'
    property color textColor: mode === "light" ? 'black' : 'white'
    property color managersBackColor: mode === "light" ? 'white' : '#505050'
    property color delimeterLineColor: mode === "light" ? 'black' : '#979797'
    property color confirmWindowColor: mode === "light" ? "#D8D8D8" : "#505050"
    property color buttonsColor: mode === "light" ? "#7D7D7D" : "#949494"
    property color cellsColor: mode === "light" ? "white" : "#949494"
    property color namesColor: mode === "light" ? "black" : "white"
    property color trikColor: '#3BB050'
    property color darkTrikColor: "#219D38"
    property color lightTrikColor: "#36c950"
    property color elementsOfListColor: mode === "light" ? "white" : "#707070"
    property color focusElementsOfListColor: mode === "light" ? "#303BB050" : trikColor
    property color focusElementsOfListNetworksColor: mode === "light" ? "#303BB050" : '#903BB050'
    property color elementsOfGridColor: mode === "light" ? "white" : "#949494"
    property color lightOrStandartGreenColor: mode === "light" ? trikColor : lightTrikColor
    property color switchBorderColor1: mode === "light" ? "#CCCCCC" : "#353535"
    property color switchBorderColor2: mode === "light" ? "#999999" : "#353535"
    property color switchBorderColor3: mode === "light" ? "white" : "#E6E6E6"
    property color spinBorderColor: mode === "light" ? trikColor : "#353535"
    property color gyroAccelBackColor: elementsOfListColor
    property color gyroAccelBordersColor: mode === "light" ? "black" : "#DBDBDB"
    property color commSettingsBorderColor: gyroAccelBordersColor
    property color informationColor: mode === "light" ? '#8B8B8B' : '#C9C9C9'
    property color linkColor: mode === "light" ? 'blue' : 'white'
}
