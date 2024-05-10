pragma Singleton

import QtQuick 2.0

Item {
    property var activeTheme: ThemeMode === "light" ? lightTheme : darkTheme

    LightTheme {
        id: lightTheme
    }

    DarkTheme {
        id: darkTheme
    }
}
