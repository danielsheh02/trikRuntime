#include "wiFiAPMock.h"

#include "QsLog.h"
#include <QDir>
#include <QrCodeGenerator.h>
#include <trikKernel/paths.h>
using namespace trikGui;

WiFiAPMock::WiFiAPMock(QObject *parent) : QObject(parent) {

	if (!mNetworkName.isEmpty() && !mPassword.isEmpty() &&
	    !mIpValue.isEmpty()) {
		QrCodeGenerator generator;
		QString data =
		    "WIFI:T:WPA;S:" + mNetworkName + ";P:" + mPassword + ";H:;";
		QImage qrCodeImage = generator.generateQr(data, 300);
		QDir dir(trikKernel::Paths::imagesPath());

		if (!dir.exists() &&
		    !dir.mkpath(trikKernel::Paths::imagesPath())) {
			QLOG_ERROR() << "Cannot create directory for images";
		} else {
			const QString name =
			    trikKernel::Paths::imagesPath() + "qrCodeImg.png";
			qrCodeImage.save(name);
			mNameImage = name;
			Q_EMIT nameImageChanged();
		}
	}
}

QString WiFiAPMock::networkName() { return mNetworkName; }
QString WiFiAPMock::password() { return mPassword; }
QString WiFiAPMock::ipValue() { return mIpValue; }
void WiFiAPMock::setQmlParent(QObject *parent) { setParent(parent); }

QString WiFiAPMock::nameImage() { return mNameImage; }
