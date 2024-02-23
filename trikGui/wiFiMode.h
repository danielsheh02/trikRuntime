/* Copyright 2014 CyberTech Labs Ltd.
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

#pragma once

// #include <QtCore/qglobal.h>

// #include <QtCore/QString>

#include "wiFiClient.h"
#include <QEventLoop>
#include <trikKernel/rcReader.h>
#include <trikWiFi/trikWiFi.h>

namespace trikGui {

/// Widget which allows to set wi-fi mode (client or access point) and then
/// opens corresponding configuration widget.
class WiFiMode : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString initStatus READ initStatus NOTIFY initStatusChanged)

public:
	enum class Mode { AccessPoint, Client, Unknown };
	Q_ENUM(Mode)

	/// Constructor
	/// @param parent - parent of this widget in Qt object hierarchy.
	explicit WiFiMode(trikWiFi::TrikWiFi &wiFi, QObject *parent = 0);

	~WiFiMode();

	QString initStatus();

	Q_INVOKABLE void setQmlParent(QObject *parent);
	Q_INVOKABLE Mode currentMode();
	Q_INVOKABLE void createWiFiClient();
	Q_INVOKABLE void createWiFiAP();

public Q_SLOTS:
	void setMode(Mode mode);

private:
	trikWiFi::TrikWiFi &mWiFi;
	trikKernel::RcReader mRcReader;
	QString mInitStatus;
	QEventLoop mEventLoop;

Q_SIGNALS:
	void initStatusChanged();
};

} // namespace trikGui
