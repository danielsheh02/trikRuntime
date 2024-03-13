#pragma once
#include "controller.h"
#include "motors.h"
#include "sensors.h"
#include <QObject>
#include <QQmlEngine>

namespace trikGui {
class TestingManager : public QObject
{
	Q_OBJECT
public:
	explicit TestingManager(Controller &controller,
				QObject *parent = nullptr);
	~TestingManager();

	enum class MotorType {
		PowerMotor = static_cast<int>(Motors::MotorType::PowerMotor),
		ServoMotor = static_cast<int>(Motors::MotorType::ServoMotor),
	};
	Q_ENUM(MotorType)

	enum class SensorType {
		Sensors = static_cast<int>(Sensors::SensorType::Sensors),
		Encoder = static_cast<int>(Sensors::SensorType::Encoder),
		Gyroscope = static_cast<int>(Sensors::SensorType::Gyroscope),
		Accelerometer =
		    static_cast<int>(Sensors::SensorType::Accelerometer),
		Camera = static_cast<int>(Sensors::SensorType::Camera),
		PwmCapture = static_cast<int>(Sensors::SensorType::PwmCapture),
	};
	Q_ENUM(SensorType)

	Q_INVOKABLE void createSensors(SensorType type);

	Q_INVOKABLE void createMotors(MotorType type);

	Q_INVOKABLE void setQmlParent(QObject *parent);

	Q_INVOKABLE bool checkPwmCapture();

private:
	Controller &mController;
};
} // namespace trikGui
