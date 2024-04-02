#include "feedback.h"

#include <trikKernel/paths.h>
#include <QrCodeGenerator.h>
#include <QDir>

Feedback::Feedback(QObject *parent) : QObject(parent) {
	QrCodeGenerator generator;
	QString data = "https://t.me/+l2HH2s-1kRFlMWQy";
	QImage qrCodeImage = generator.generateQr(data, 300);
	QDir dir(trikKernel::Paths::imagesPath());

	if (!dir.exists() && !dir.mkpath(trikKernel::Paths::imagesPath())) {
	} else {
		const QString name = trikKernel::Paths::imagesPath() +
				     "qrCodeImgInviteTelegram.png";
		qrCodeImage.save(name);
		mNameImage = name;
		Q_EMIT nameImageChanged();
	}
}

void Feedback::setQmlParent(QObject *parent) { setParent(parent); }

QString Feedback::nameImage() { return mNameImage; }
