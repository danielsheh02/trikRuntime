#include "communicationSettingsManager.h"

CommunicationSettingsManager::CommunicationSettingsManager(QQmlEngine *parent)
    : QObject(parent) {}

void CommunicationSettingsManager::setCommunicationSettings(
    trikGui::CommunicationSettings *communicationSettings) {
	mCommunicationSettings = communicationSettings;
}

trikGui::CommunicationSettings *
CommunicationSettingsManager::communicationSettings() {
	return mCommunicationSettings;
}
