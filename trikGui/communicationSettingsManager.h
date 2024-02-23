#ifndef COMMUNICATIONSETTINGSMANAGER_H
#define COMMUNICATIONSETTINGSMANAGER_H
#include <QObject>
#include <QQmlEngine>
#include <communicationSettings.h>

class CommunicationSettingsManager : public QObject
{
	Q_OBJECT
	Q_PROPERTY(trikGui::CommunicationSettings *communicationSettings READ
		       communicationSettings CONSTANT)
public:
	explicit CommunicationSettingsManager(QQmlEngine *parent = nullptr);
	trikGui::CommunicationSettings *communicationSettings();

	void setCommunicationSettings(
	    trikGui::CommunicationSettings *communicationSettings);

private:
	trikGui::CommunicationSettings *mCommunicationSettings;
};

#endif // COMMUNICATIONSETTINGSMANAGER_H
