#pragma once
#include <trikControl/sensorInterface.h>
using namespace trikControl;
namespace trikGui {
class SensorMock : public SensorInterface
{
	Q_OBJECT
public:
	SensorMock(QObject *parent = nullptr);

	int minValue() const override { return -10000; }

	int maxValue() const override { return 10000; }

	int mValue{minValue()};

	bool reverse{false};

	Status status() const override;

public Q_SLOTS:
	int read() override;

	int readRawData() override;
};
} // namespace trikGui
