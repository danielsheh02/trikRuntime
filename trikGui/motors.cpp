/* Copyright 2014 Roman Kurbatov
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

#include "motors.h"

#include <QtCore/QTimer>
#include <QtGui/QKeyEvent>

#if QT_VERSION < QT_VERSION_CHECK(5, 0, 0)
#include <QtGui/QScrollArea>
#include <QtGui/QVBoxLayout>
#else
#include <QtWidgets/QScrollArea>
#include <QtWidgets/QVBoxLayout>
#endif

#include "motorLever.h"
#include <QApplication>
using namespace trikGui;

Motors::Motors(trikControl::BrickInterface &brick, QStringList ports, QObject *parent)
	: QAbstractListModel(parent), mBrick(brick), mPorts(ports), mLevers(mPorts.size()) {

	int i = 0;
	for (const QString &port : mPorts) {
		MotorLever *lever = new MotorLever(port, *mBrick.motor(port), this);
		mLevers[i] = lever;
		++i;
	}
}

Motors::~Motors() {}

int Motors::rowCount(const QModelIndex &parent) const {
	if (parent.isValid()) {
		return -1;
	}
	return mLevers.size();
}

QVariant Motors::data(const QModelIndex &index, int role) const {
	if (!index.isValid() || role != Qt::DisplayRole) {
		return {};
	}

	const int index_row{static_cast<int>(index.row())};
	return QVariant::fromValue(mLevers[index_row]);
}

void Motors::setQmlParent(QObject *parent) { setParent(parent); }
