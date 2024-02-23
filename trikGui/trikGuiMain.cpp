/* Copyright 2013 - 2015 Roman Kurbatov and CyberTech Labs Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * This file was modified by Yurii Litvinov to make it comply with the
 * requirements of trikRuntime project. See git revision history for detailed
 * changes. */

#include <QtCore/qglobal.h>

#include <QtCore/QDir>

#include <QsLog.h>
#include <trikKernel/applicationInitHelper.h>
#include <trikKernel/deinitializationHelper.h>

#include "mainMenuManager.h"
#include "managers.h"
#include <QApplication>
#include <QFont>
#include <QObject>
#include <QQmlApplicationEngine>
#include <QQmlContext>

using namespace trikGui;
QQmlApplicationEngine *qQmlEngine = nullptr;
MotorsManager *motorsManager = nullptr;
SensorsManager *sensorsManager = nullptr;
CommunicationSettingsManager *communicationSettingsManager = nullptr;
WiFiManager *wiFiManager = nullptr;
TestingManager *testingManager = nullptr;
LanguageManager *languageManager = nullptr;

int main(int argc, char *argv[]) {
	QApplication app(argc, argv);

	trikKernel::DeinitializationHelper helper;
	Q_UNUSED(helper);

	trikKernel::ApplicationInitHelper initHelper(app);
	//  qRegisterMetaType<trikGui::WiFiClient::NetworkInfo>(
	//      "trikGui::WiFiClient::NetworkInfo");
	qQmlEngine = new QQmlApplicationEngine(&app);
	motorsManager = new MotorsManager(qQmlEngine);
	sensorsManager = new SensorsManager(qQmlEngine);
	communicationSettingsManager =
	    new CommunicationSettingsManager(qQmlEngine);
	wiFiManager = new WiFiManager(qQmlEngine);
	languageManager = new LanguageManager(qQmlEngine);

	qQmlEngine->rootContext()->setContextProperty("MotorsManager",
						      motorsManager);
	qQmlEngine->rootContext()->setContextProperty("SensorsManager",
						      sensorsManager);
	qQmlEngine->rootContext()->setContextProperty(
	    "CommunicationSettingsManager", communicationSettingsManager);
	qQmlEngine->rootContext()->setContextProperty("WiFiManager",
						      wiFiManager);
	qQmlEngine->rootContext()->setContextProperty("LanguageManager",
						      languageManager);

	initHelper.commandLineParser().addApplicationDescription(QObject::tr(
	    "Graphical user interface, TRIK Studio runtime environment "
	    "and script runner of a robot"));

	if (!initHelper.parseCommandLine()) {
		return 0;
	}

	initHelper.init();

	if (QDir::current().exists("scripts")) {
		QDir::setCurrent("scripts");
	}

	QLOG_INFO() << "TrikGui started";

	// BackgroundWidget w(initHelper.configPath());
	// w.setFixedWidth(240);
	// w.setFixedHeight(320);
	// w.show();

	MainMenuManager mainMenuManager(initHelper.configPath());
	qmlRegisterUncreatableType<MainMenuManager>(
	    "MainMenuManager", 1, 0, "AppType", "Enum is not a type");
	qQmlEngine->rootContext()->setContextProperty("MainMenuManager",
						      &mainMenuManager);
	const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
	QObject::connect(
	    qQmlEngine, &QQmlApplicationEngine::objectCreated, &app,
	    [url](QObject *obj, const QUrl &objUrl) {
		    if (!obj && url == objUrl)
			    QCoreApplication::exit(-1);
	    },
	    Qt::QueuedConnection);
	qQmlEngine->load(url);

	return app.exec();
}
