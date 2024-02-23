#include "gyroscopeMock.h"
using namespace trikControl;
using namespace trikGui;
GyroscopeMock::GyroscopeMock(QObject *parent) { setParent(parent); }
QVector<int> GyroscopeMock::read() const {
	int x = rand() % 200000 - 100000;
	int y = rand() % 200000 - 100000;
	int z = rand() % 200000 - 100000;
	return QVector<int>{x, y, z};
}

void GyroscopeMock::calibrate(int msec) { Q_UNUSED(msec) }
QVector<int> GyroscopeMock::getCalibrationValues() { return QVector<int>(); }
void GyroscopeMock::setCalibrationValues(const QVector<int> &values) {
	Q_UNUSED(values)
}
bool GyroscopeMock::isCalibrated() const { return true; }
QVector<int> GyroscopeMock::readRawData() const { return QVector<int>(); }

trikControl::DeviceInterface::Status GyroscopeMock::status() const {
	return trikControl::DeviceInterface::Status::ready;
}
