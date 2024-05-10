/* Copyright 2023 Nick Ponomarev
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

#include <QtCore/qglobal.h>

#include "abstractIndicator.h"
#include <QObject>

namespace trikControl {
class PwmCaptureInterface;
}

namespace trikGui {

/// Widget that shows current PWM capture reading.
class PwmCaptureIndicator : public AbstractIndicator
{
	Q_OBJECT
	Q_PROPERTY(QString nameLabel READ nameLabel CONSTANT)
	Q_PROPERTY(int maxValue READ maxValue CONSTANT)
	Q_PROPERTY(int minValue READ minValue CONSTANT)
	Q_PROPERTY(int value READ value NOTIFY valueChanged)
public:
	/// Constructor.
	/// @param port - port to which PWM input is plugged.
	/// @param pwmCapture - PWM duty value which we will read.
	/// @param parent - parent of this widget in Qt widget parent-child
	/// system.
	PwmCaptureIndicator(const QString &port, trikControl::PwmCaptureInterface &pwmCapture,
			    QObject *parent = nullptr);

private Q_SLOTS:
	void renew() override;

private:
	trikControl::PwmCaptureInterface &mPwmCapture;
	int mMinValue;
	int mMaxValue;
	int mValue;
	QString mNameLabel;
	QString nameLabel();
	int maxValue();
	int minValue();
	int value();
Q_SIGNALS:
	/// Emitted when value changed
	void valueChanged();
};

} // namespace trikGui
