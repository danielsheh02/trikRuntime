#include "settingsManager.h"

using namespace trikGui;
SettingsManager::SettingsManager(QObject *parent) : QObject(parent) {}
void SettingsManager::createApp(AppType appType) {
	switch (appType) {
	case AppType::Network: {

		break;
	}
	case AppType::CommSettings: {

		break;
	}
	case AppType::Language: {

		break;
	}
	case AppType::SystemSettings: {

		break;
	}
	case AppType::Information: {

		break;
	}
	default:
		break;
	}
}
