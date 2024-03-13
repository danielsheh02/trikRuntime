#pragma once
#include "wiFiAP.h"
#include "wiFiClient.h"
#include "wiFiMode.h"
#include <QObject>
#include <QQmlEngine>
namespace trikGui {
class WiFiManager : public QObject
{
	Q_OBJECT
	Q_PROPERTY(WiFiMode *wiFiMode READ wiFiMode CONSTANT)
	Q_PROPERTY(WiFiClient *wiFiClient READ wiFiClient CONSTANT)
	Q_PROPERTY(WiFiAP *wiFiAP READ wiFiAP CONSTANT)

public:
	explicit WiFiManager(QQmlEngine *parent = nullptr);
	WiFiMode *wiFiMode();
	WiFiClient *wiFiClient();
	WiFiAP *wiFiAP();

	void setWiFiMode(WiFiMode *wiFiMode);
	void setWiFiClient(WiFiClient *wiFiClient);
	void setWiFiAP(WiFiAP *wiFiAP);

private:
	WiFiMode *mWiFiMode;
	WiFiClient *mWiFiClient = nullptr;
	WiFiAP *mWiFiAP = nullptr;
};
} // namespace trikGui
