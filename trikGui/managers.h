#pragma once
#include "communicationSettingsManager.h"
#include "languageManager.h"
#include "motorsManager.h"
#include "sensorsManager.h"
#include "testingManager.h"
#include "wiFiManager.h"
#include <QQmlApplicationEngine>
#include <QTranslator>
using namespace trikGui;
extern MotorsManager *motorsManager;
extern SensorsManager *sensorsManager;
extern QQmlApplicationEngine *qQmlEngine;
extern CommunicationSettingsManager *communicationSettingsManager;
extern WiFiManager *wiFiManager;
extern TestingManager *testingManager;
extern LanguageManager *languageManager;
