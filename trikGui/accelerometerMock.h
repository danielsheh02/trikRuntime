#pragma once
#include <trikControl/vectorSensorInterface.h>
using namespace trikControl;
namespace trikGui {
class AccelerometerMock : public VectorSensorInterface
{
	Q_OBJECT
public:
	AccelerometerMock(QObject *parent = nullptr);
	Status status() const override;
public Q_SLOTS:
	QVector<int> read() const override;
};
} // namespace trikGui
