#pragma once

#include <QObject>

namespace trikGui {

class WiFiAPMock : public QObject
{
	Q_OBJECT
	Q_PROPERTY(
	    QString networkName READ networkName NOTIFY networkNameChanged)
	Q_PROPERTY(QString password READ password NOTIFY passwordChanged)
	Q_PROPERTY(QString ipValue READ ipValue NOTIFY ipValueChanged)
	Q_PROPERTY(QString nameImage READ nameImage NOTIFY nameImageChanged)

public:
	explicit WiFiAPMock(QObject *parent = nullptr);
	Q_INVOKABLE void setQmlParent(QObject *parent);

private:
	QString mNetworkName{"trik-f6fec0"};
	QString mPassword{"54124221"};
	QString mIpValue{"192.168.77.1"};

	QString networkName();
	QString password();
	QString ipValue();
	QString mNameImage;
	QString nameImage();
Q_SIGNALS:
	void networkNameChanged();
	void passwordChanged();
	void ipValueChanged();
	void nameImageChanged();
};

} // namespace trikGui
