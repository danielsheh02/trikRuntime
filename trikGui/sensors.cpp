#include "sensors.h"

#include "accelerometer.h"
#include "accelerometerMock.h"
#include "camera.h"
#include "encoderIndicator.h"
#include "encoderMock.h"
#include "gyroscopeIndicator.h"
#include "gyroscopeMock.h"
#include "managers.h"
#include "pwmCaptureIndicator.h"
#include "sensorIndicator.h"
#include "sensorMock.h"
#include <QDebug>
#include <QQmlContext>

using namespace trikGui;

Sensors::Sensors(trikControl::BrickInterface &brick, const QStringList &ports,
		 SensorType sensorType, QObject *parent)
    : QAbstractListModel(parent), mBrick(brick), mInterval(100),
      mSensorType(sensorType) {
	mTimer.setInterval(mInterval);

	int i = 0;
	if (mSensorType == Sensors::SensorType::Gyroscope ||
	    mSensorType == Sensors::SensorType::Accelerometer ||
	    mSensorType == Sensors::SensorType::Camera) {
#ifndef DESKTOP
		AbstractIndicator *indicator =
		    produceIndicator(QString(""), mSensorType);
#else
		AbstractIndicator *indicator =
		    produceIndicatorMock(QString(""), mSensorType);
#endif
		mIndicators.resize(1);

		if (indicator) {
			connect(&mTimer, &QTimer::timeout, indicator,
				&AbstractIndicator::renew);
			mIndicators[i] = indicator;
		}

	} else {
		mIndicators.resize(ports.size());
		for (const QString &port : ports) {
#ifndef DESKTOP
			AbstractIndicator *indicator =
			    produceIndicator(port, mSensorType);
#else
			AbstractIndicator *indicator =
			    produceIndicatorMock(port, mSensorType);
#endif
			if (indicator) {
				connect(&mTimer, &QTimer::timeout, indicator,
					&AbstractIndicator::renew);
				mIndicators[i] = indicator;
				++i;
			}
		}
	}
	mTimer.start();
}

Sensors::~Sensors() {}

AbstractIndicator *Sensors::produceIndicator(const QString &port,
					     SensorType sensorType) {
	switch (sensorType) {
	case SensorType::Sensors: {
		return new SensorIndicator(port, *mBrick.sensor(port), this);
	}
	case SensorType::Encoder: {
		return new EncoderIndicator(port, *mBrick.encoder(port), this);
	}
	case SensorType::Gyroscope: {
		return new GyroscopeIndicator(mBrick.gyroscope(), this);
	}
	case SensorType::Accelerometer: {
		return new Accelerometer(mBrick.accelerometer(), this);
	}
	case SensorType::PwmCapture: {
		return new PwmCaptureIndicator(port, *mBrick.pwmCapture(port),
					       this);
	}
	case SensorType::Camera: {
		Camera *camera = new Camera(mBrick, this);
		qQmlEngine->addImageProvider("cameraImageProvider", camera);
		return camera;
	}
	default: {
		return nullptr;
	}
	}

	return nullptr;
}

AbstractIndicator *Sensors::produceIndicatorMock(const QString &port,
						 SensorType sensorType) {
	switch (sensorType) {
	case SensorType::Sensors: {
		SensorMock *sensorMock = new SensorMock(this);
		return new SensorIndicator(port, *sensorMock, this);
	}
	case SensorType::Encoder: {
		EncoderMock *encoderMock = new EncoderMock(this);
		return new EncoderIndicator(port, *encoderMock, this);
	}
	case SensorType::Gyroscope: {
		GyroscopeMock *gyroscopeMock = new GyroscopeMock(this);
		return new GyroscopeIndicator(gyroscopeMock, this);
	}
	case SensorType::Accelerometer: {
		AccelerometerMock *accelerometerMock =
		    new AccelerometerMock(this);
		return new Accelerometer(accelerometerMock, this);
	}
	case SensorType::PwmCapture: {
		return new PwmCaptureIndicator(port, *mBrick.pwmCapture(port),
					       this);
	}
	case SensorType::Camera: {
		Camera *camera = new Camera(mBrick, this);
		qQmlEngine->addImageProvider("cameraImageProvider", camera);
		return camera;
	}
	default: {
		return nullptr;
	}
	}

	return nullptr;
}

int Sensors::rowCount(const QModelIndex &parent) const {
	if (parent.isValid()) {
		return -1;
	}
	return mIndicators.size();
}

QVariant Sensors::data(const QModelIndex &index, int role) const {
	if (!index.isValid() || role != Qt::DisplayRole) {
		return {};
	}

	const int index_row{static_cast<int>(index.row())};
	return QVariant::fromValue(mIndicators[index_row]);
}

void Sensors::setQmlParent(QObject *parent) { setParent(parent); }
