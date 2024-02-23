#include "sensorMock.h"
using namespace trikGui;
SensorMock::SensorMock(QObject *parent) { setParent(parent); }

int SensorMock::read() {
	if (!reverse && mValue < maxValue()) {
		mValue += 200;
	} else {
		reverse = true;
	}
	if (reverse && mValue > minValue()) {
		mValue -= 200;
	} else {
		reverse = false;
	}
	return mValue;
}

int SensorMock::readRawData() { return 0; }
trikControl::DeviceInterface::Status SensorMock::status() const {
	return trikControl::DeviceInterface::Status::ready;
}
