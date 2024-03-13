#include "accelerometerMock.h"
using namespace trikControl;
namespace trikGui {
AccelerometerMock::AccelerometerMock(QObject *parent) { setParent(parent); }
QVector<int> AccelerometerMock::read() const {
	int x = rand() % 2000 - 1000;
	int y = rand() % 2000 - 1000;
	int z = rand() % 2000 - 1000;
	return QVector<int>{x, y, z};
}
trikControl::DeviceInterface::Status AccelerometerMock::status() const {
	return trikControl::DeviceInterface::Status::ready;
}
} // namespace trikGui
