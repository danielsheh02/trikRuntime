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

#include <QEventLoop>
#include <trikKernel/rcReader.h>
#include <trikWiFi/trikWiFi.h>

namespace trikGui {

class WiFiModeMock : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString initStatus READ initStatus NOTIFY initStatusChanged)

public:
	enum class Mode { AccessPoint, Client, Unknown };
	Q_ENUM(Mode)

	explicit WiFiModeMock(QObject *parent = 0);

	QString initStatus();

	Q_INVOKABLE void setQmlParent(QObject *parent);
	Q_INVOKABLE Mode currentMode();
	Q_INVOKABLE void createWiFiClient();
	Q_INVOKABLE void createWiFiAP();

public Q_SLOTS:
	void setMode(Mode mode);

private:
	QString mInitStatus;
	Mode mCurrentMode;

Q_SIGNALS:
	void initStatusChanged();
};

} // namespace trikGui
