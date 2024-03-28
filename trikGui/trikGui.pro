# Copyright 2013 - 2016 Yurii Litvinov, Mikhail Kita, Anna Kudryashova
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

TEMPLATE = app
QT += network xml quick concurrent quickcontrols2

include(../global.pri)
include(../Qt-QrCodeGenerator/Qt-QrCodeGenerator.pri)
QMAKE_CXXFLAGS_WARN_ON += -Wno-error=sign-compare

HEADERS += \
	$$PWD/abstractIndicator.h \
	$$PWD/autoRunner.h \
	$$PWD/batteryIndicator.h \
	$$PWD/controller.h \
	$$PWD/encoderIndicator.h \
        $$PWD/fileManager.h \
        $$PWD/information.h \
        $$PWD/languageSelection.h \
	$$PWD/motorLever.h \
        $$PWD/motors.h \
        $$PWD/communicationSettings.h \
        $$PWD/runningCode.h \
	$$PWD/sensorIndicator.h \
        $$PWD/sensors.h \
        $$PWD/systemSettings.h \
        $$PWD/wiFiAP.h \
        $$PWD/wiFiClient.h \
        $$PWD/wiFiInit.h \
        $$PWD/wiFiMode.h \
	$$PWD/wiFiIndicator.h \
	$$PWD/openSocketIndicator.h \
	$$PWD/sensorLever.h \
	$$PWD/scriptHolder.h \
	$$PWD/gamepadIndicator.h \
	$$PWD/powerLevel.h \
	$$PWD/gyroscopeIndicator.h \
        $$PWD/accelerometer.h \
        $$PWD/network.h \
        $$PWD/camera.h \
	$$PWD/pwmCaptureIndicator.h \
        $$PWD/communicationSettingsManager.h \
        $$PWD/languageManager.h \
        $$PWD/mainMenuManager.h \
        $$PWD/managers.h \
        $$PWD/motorsManager.h \
        $$PWD/sensorsManager.h \
        $$PWD/settingsManager.h \
        $$PWD/testingManager.h \
        $$PWD/wiFiManager.h \
        $$PWD/accelerometerMock.h \
        $$PWD/encoderMock.h \
        $$PWD/gyroscopeMock.h \
        $$PWD/sensorMock.h \
        $$PWD/modeManager.h \
        $$PWD/wiFiAPMock.h \
        $$PWD/wiFiClientMock.h \
        $$PWD/wiFiModeMock.h

SOURCES += \
	$$PWD/autoRunner.cpp \
	$$PWD/batteryIndicator.cpp \
        $$PWD/communicationSettings.cpp \
	$$PWD/controller.cpp \
	$$PWD/encoderIndicator.cpp \
        $$PWD/fileManager.cpp \
        $$PWD/information.cpp \
        $$PWD/languageSelection.cpp \
	$$PWD/trikGuiMain.cpp \
	$$PWD/motorLever.cpp \
        $$PWD/motors.cpp \
        $$PWD/runningCode.cpp \
	$$PWD/sensorIndicator.cpp \
        $$PWD/sensors.cpp \
        $$PWD/systemSettings.cpp \
        $$PWD/wiFiAP.cpp \
        $$PWD/wiFiClient.cpp \
        $$PWD/wiFiInit.cpp \
        $$PWD/wiFiMode.cpp \
	$$PWD/wiFiIndicator.cpp \
	$$PWD/openSocketIndicator.cpp \
	$$PWD/sensorLever.cpp \
	$$PWD/scriptHolder.cpp \
	$$PWD/gamepadIndicator.cpp \
	$$PWD/$$PLATFORM/powerLevel.cpp \
	$$PWD/gyroscopeIndicator.cpp \
        $$PWD/accelerometer.cpp \
        $$PWD/network.cpp \
        $$PWD/camera.cpp \
	$$PWD/pwmCaptureIndicator.cpp \
        $$PWD/communicationSettingsManager.cpp \
        $$PWD/languageManager.cpp \
        $$PWD/mainMenuManager.cpp \
        $$PWD/motorsManager.cpp \
        $$PWD/sensorsManager.cpp \
        $$PWD/settingsManager.cpp \
        $$PWD/testingManager.cpp \
        $$PWD/wiFiManager.cpp \
        $$PWD/accelerometerMock.cpp \
        $$PWD/encoderMock.cpp \
        $$PWD/gyroscopeMock.cpp \
        $$PWD/sensorMock.cpp \
        $$PWD/modeManager.cpp \
        $$PWD/wiFiAPMock.cpp \
        $$PWD/wiFiClientMock.cpp \
        $$PWD/wiFiModeMock.cpp

RESOURCES = trikGui.qrc

OTHER_FILES += \

implementationIncludes(trikKernel trikControl trikCommunicator trikScriptRunner trikWiFi trikTelemetry)
transitiveIncludes(trikNetwork)
PythonQtIncludes()
links(trikQsLog trikKernel trikControl trikCommunicator trikScriptRunner trikWiFi trikTelemetry trikNetwork)

installs()

