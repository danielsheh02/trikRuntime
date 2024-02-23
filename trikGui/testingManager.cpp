#include "testingManager.h"
#include "managers.h"
#include <QQmlEngine>

using namespace trikGui;
using trikControl::MotorInterface;
TestingManager::TestingManager(Controller &controller, QObject *parent)
    : QObject(parent), mController(controller) {
	qmlRegisterUncreatableType<TestingManager>(
	    "TestingManager", 1, 0, "Type", "Enum is not a type");
}
TestingManager::~TestingManager() {}
void TestingManager::createSensors(SensorType type) {
	QStringList ports;
	switch (static_cast<Sensors::SensorType>(type)) {
	case Sensors::SensorType::Sensors:
		ports.append(
		    (mController.brick())
			.sensorPorts(
			    trikControl::SensorInterface::Type::analogSensor));

		ports.append(
		    (mController.brick())
			.sensorPorts(
			    trikControl::SensorInterface::Type::digitalSensor));

		ports.sort();
		break;
	case Sensors::SensorType::Encoder:
		ports = (mController.brick()).encoderPorts();
		ports.sort();
		break;
	case Sensors::SensorType::PwmCapture:
		ports = (mController.brick()).pwmCapturePorts();
		ports.sort();
		break;
	default:
		break;
	}
	Sensors *sensors =
	    new Sensors(mController.brick(), ports,
			static_cast<Sensors::SensorType>(type), this);
	sensorsManager->setSensors(sensors);
}

void TestingManager::createMotors(MotorType type) {
	QStringList ports;
	switch (static_cast<Motors::MotorType>(type)) {
	case Motors::MotorType::PowerMotor:
		ports = (mController.brick())
			    .motorPorts(MotorInterface::Type::powerMotor);
		ports.sort();
		break;
	case Motors::MotorType::ServoMotor:
		ports = (mController.brick())
			    .motorPorts(MotorInterface::Type::servoMotor);
		ports.sort();
		break;
	default:
		break;
	}
	Motors *motors = new Motors(mController.brick(), ports, this);
	motorsManager->setMotors(motors);
}

void TestingManager::setQmlParent(QObject *parent) { setParent(parent); }
bool TestingManager::checkPwmCapture() {
	return mController.brick().pwmCapturePorts().length() != 0;
}
