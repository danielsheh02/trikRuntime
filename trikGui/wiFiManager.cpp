#include "wiFiManager.h"
using namespace trikGui;
WiFiManager::WiFiManager(QQmlEngine *parent) : QObject(parent) {}

void WiFiManager::setWiFiMode(WiFiMode *wiFiMode) { mWiFiMode = wiFiMode; }

void WiFiManager::setWiFiClient(WiFiClient *wiFiClient) {
	mWiFiClient = wiFiClient;
}

void WiFiManager::setWiFiAP(WiFiAP *wiFiAP) { mWiFiAP = wiFiAP; }

WiFiMode *WiFiManager::wiFiMode() { return mWiFiMode; }

WiFiClient *WiFiManager::wiFiClient() { return mWiFiClient; }

WiFiAP *WiFiManager::wiFiAP() { return mWiFiAP; }
