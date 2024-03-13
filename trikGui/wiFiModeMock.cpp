#include "wiFiModeMock.h"

#include <QtGui/QKeyEvent>

#include <QsLog.h>
#include <trikKernel/paths.h>

#include "managers.h"
#include "wiFiAPMock.h"
#include "wiFiClientMock.h"
#include "wiFiInit.h"
#include <QDebug>
#include <QQmlContext>
#include <unistd.h>

using namespace trikGui;

WiFiModeMock::WiFiModeMock(QObject *parent) : QObject(parent) {}

void WiFiModeMock::createWiFiClient() {
	WiFiClientMock *wiFiClient = new WiFiClientMock(this);
	qQmlEngine->rootContext()->setContextProperty("WiFiClientServer",
						      wiFiClient);
	wiFiClient->scanWiFi();
}

void WiFiModeMock::createWiFiAP() {
	WiFiAPMock *wiFiAP = new WiFiAPMock(this);
	qQmlEngine->rootContext()->setContextProperty("WiFiAPServer", wiFiAP);
}

void WiFiModeMock::setMode(Mode mode) {
	if (mCurrentMode != mode) {
		WiFiInit wiFiInit;
		qQmlEngine->rootContext()->setContextProperty("WiFiInitServer",
							      &wiFiInit);
		mInitStatus = "start";
		Q_EMIT initStatusChanged();
	}
	mCurrentMode = mode;
	switch (mode) {
	case Mode::Client: {
		createWiFiClient();
		mInitStatus = "WiFiClient";
		Q_EMIT initStatusChanged();
		break;
	}
	case Mode::AccessPoint: {
		createWiFiAP();
		mInitStatus = "WiFiAP";
		Q_EMIT initStatusChanged();
		break;
	}
	case Mode::Unknown: {
		QLOG_ERROR()
		    << "Error: unknown WiFi mode in WiFiModeWidget::setMode()";
		break;
	}
	}
}

QString WiFiModeMock::initStatus() { return mInitStatus; }

void WiFiModeMock::setQmlParent(QObject *parent) { setParent(parent); }

WiFiModeMock::Mode WiFiModeMock::currentMode() { return mCurrentMode; }
