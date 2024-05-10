/* Copyright 2024 Daniel Chehade.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License. */

#include "feedback.h"

#include <trikKernel/paths.h>
#include <QrCodeGenerator.h>
#include <QDir>

using namespace trikGui;

Feedback::Feedback(QObject *parent) : QObject(parent) {
	QrCodeGenerator generator;
	QString data = "https://t.me/+l2HH2s-1kRFlMWQy";
	QImage qrCodeImage = generator.generateQr(data, 300);
	QDir dir(trikKernel::Paths::imagesPath());

	if (!dir.exists() && !dir.mkpath(trikKernel::Paths::imagesPath())) {
	} else {
		const QString name = trikKernel::Paths::imagesPath() + "qrCodeImgInviteTelegram.png";
		qrCodeImage.save(name);
		mNameImage = name;
		Q_EMIT nameImageChanged();
	}
}

void Feedback::setQmlParent(QObject *parent) { setParent(parent); }

QString Feedback::nameImage() { return mNameImage; }
