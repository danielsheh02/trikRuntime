#ifdef DESKTOP
#include "wiFiModeMock.h"
#endif

#include "batteryIndicator.h"
#include "communicationSettings.h"
#include "fileManager.h"
#include "gamepadIndicator.h"
#include "information.h"
#include "languageSelection.h"
#include "mainMenuManager.h"
#include "managers.h"
#include "modeManager.h"
#include "network.h"
#include "openSocketIndicator.h"
#include "testingManager.h"
#include "wiFiIndicator.h"
#include <QApplication>
#include <QProcess>
#include <QQmlContext>
using namespace trikGui;
MainMenuManager::MainMenuManager(const QString &configPath, QObject *parent)
    : QObject(parent), mController(configPath),
      mFileManagerRoot(SystemSettings::FileManagerRootType::ScriptsDir) {
	RunningCode *runningCode = new RunningCode(mController, this);
	qQmlEngine->rootContext()->setContextProperty("RunningCode",
						      runningCode);

	Network *network = new Network(this);
	qQmlEngine->rootContext()->setContextProperty("Network", network);

	BatteryIndicator *batteryIndicator =
	    new BatteryIndicator(mController.brick(), this);
	qQmlEngine->rootContext()->setContextProperty("BatteryIndicator",
						      batteryIndicator);

	WiFiIndicator *wiFiIndicator = new WiFiIndicator(mController, this);
	qQmlEngine->rootContext()->setContextProperty("WiFiIndicator",
						      wiFiIndicator);
	qmlRegisterUncreatableType<WiFiMode>("WiFiMode", 1, 0, "Mode",
					     "Enum is not a type");

	GamepadIndicator *gamepadIndicator =
	    new GamepadIndicator(mController, this);
	qQmlEngine->rootContext()->setContextProperty("GamepadIndicator",
						      gamepadIndicator);
	OpenSocketIndicator *mailboxIndicator =
	    new OpenSocketIndicator(mController.mailbox()->isConnected(), this);
	connect(&mController, &Controller::mailboxStatusChanged,
		mailboxIndicator, &OpenSocketIndicator::changeStatus);
	qQmlEngine->rootContext()->setContextProperty("MailboxIndicator",
						      mailboxIndicator);

	OpenSocketIndicator *communicatorIndicator = new OpenSocketIndicator(
	    mController.communicatorConnectionStatus(), this);
	connect(&mController, &Controller::communicatorStatusChanged,
		communicatorIndicator, &OpenSocketIndicator::changeStatus);
	qQmlEngine->rootContext()->setContextProperty("CommunicatorIndicator",
						      communicatorIndicator);

	mController.brick().playTone(2000, 10);
}

MainMenuManager::~MainMenuManager() {}

void MainMenuManager::createApp(AppType appType) {
	switch (appType) {
	case AppType::Files: {
		FileManager *fileManager =
		    new FileManager(mController, mFileManagerRoot, this);
		qQmlEngine->rootContext()->setContextProperty(
		    "FileManagerServer", fileManager);
		break;
	}
	case AppType::Testing: {
		QProcess::startDetached("/etc/trik/init-ov7670-320x240.sh",
					{"0"});
		QProcess::startDetached("/etc/trik/init-ov7670-320x240.sh",
					{"1"});
		TestingManager *testingManager =
		    new TestingManager(mController, this);
		qQmlEngine->rootContext()->setContextProperty("TestingManager",
							      testingManager);
		break;
	}
	case AppType::Network: {
#ifndef DESKTOP
		WiFiMode *wiFiMode = new WiFiMode(mController.wiFi(), this);
#else
		WiFiModeMock *wiFiMode = new WiFiModeMock(this);
#endif
		qQmlEngine->rootContext()->setContextProperty("WiFiModeServer",
							      wiFiMode);
		break;
	}
	case AppType::CommSettings: {
		if (mController.mailbox()) {
			CommunicationSettings *communicationSettings =
			    new CommunicationSettings(*mController.mailbox(),
						      this);
			qQmlEngine->rootContext()->setContextProperty(
			    "CommunicationSettingsServer",
			    communicationSettings);
		} else {
			Q_ASSERT(!"Mailbox is disabled but "
				  "commmunications widget "
				  "still tries "
				  "to be shown");
		}
		break;
	}
	case AppType::Language: {
		LanguageSelection *languageSelection =
		    new LanguageSelection(this);
		qQmlEngine->rootContext()->setContextProperty(
		    "LanguageSelection", languageSelection);
		break;
	}
	case AppType::SystemSettings: {
		SystemSettings *systemSettings =
		    new SystemSettings(mFileManagerRoot, this);
		connect(systemSettings, &SystemSettings::currentFilesDirPath,
			this, &MainMenuManager::changeFileManagerRoot);
		qQmlEngine->rootContext()->setContextProperty(
		    "SystemSettingsComponent", systemSettings);
		break;
	}
	case AppType::AppearanceMode: {
		ModeManager *modeManager = new ModeManager(this);
		qQmlEngine->rootContext()->setContextProperty("ModeManager",
							      modeManager);
		break;
	}
	case AppType::Information: {
		Information *information = new Information(this);
		qQmlEngine->rootContext()->setContextProperty(
		    "SystemInformation", information);
		break;
	}
	default:
		break;
	}
}

void MainMenuManager::changeFileManagerRoot(
    SystemSettings::FileManagerRootType const &path) {
	mFileManagerRoot = path;
	Q_EMIT fileManagerRootChanged(mFileManagerRoot);
}

void MainMenuManager::shutdown() {
	QProcess::startDetached("/sbin/shutdown", {"-h", "-P", "now"});
	QCoreApplication::quit();
}
