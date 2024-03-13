#pragma once
#include "trikControl/gyroSensorInterface.h"
using namespace trikControl;
namespace trikGui {

class GyroscopeMock : public GyroSensorInterface
{
	Q_OBJECT
public:
	GyroscopeMock(QObject *parent = nullptr);
	Status status() const override;
public Q_SLOTS:
	void calibrate(int msec) override;
	QVector<int> getCalibrationValues() override;
	void setCalibrationValues(const QVector<int> &values) override;
	bool isCalibrated() const override;
	QVector<int> readRawData() const override;
	QVector<int> read() const override;
};

} // namespace trikGui
