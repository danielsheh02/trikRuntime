/* Copyright 2024 Daniel Chehade.
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

#include "testingManager.h"
#include "managers.h"
#include <QQmlEngine>
#include <QQmlContext>

using namespace trikGui;
using trikControl::MotorInterface;
TestingManager::TestingManager(Controller &controller, QObject *parent) : QObject(parent), mController(controller) {
	qmlRegisterUncreatableType<TestingManager>("TestingManager", 1, 0, "Type", "Enum is not a type");
}
TestingManager::~TestingManager() {}
void TestingManager::createSensors(SensorType type) {
	QStringList ports;
	switch (static_cast<Sensors::SensorType>(type)) {
	case Sensors::SensorType::Sensors:
		ports.append((mController.brick()).sensorPorts(trikControl::SensorInterface::Type::analogSensor));

		ports.append((mController.brick()).sensorPorts(trikControl::SensorInterface::Type::digitalSensor));

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
	Sensors *sensors = new Sensors(mController.brick(), ports, static_cast<Sensors::SensorType>(type), this);
	qQmlEngine->rootContext()->setContextProperty("Sensors", sensors);
}

void TestingManager::createMotors(MotorType type) {
	QStringList ports;
	switch (static_cast<Motors::MotorType>(type)) {
	case Motors::MotorType::PowerMotor:
		ports = (mController.brick()).motorPorts(MotorInterface::Type::powerMotor);
		ports.sort();
		break;
	case Motors::MotorType::ServoMotor:
		ports = (mController.brick()).motorPorts(MotorInterface::Type::servoMotor);
		ports.sort();
		break;
	default:
		break;
	}
	Motors *motors = new Motors(mController.brick(), ports, this);
	qQmlEngine->rootContext()->setContextProperty("MotorsManager", motors);
}

void TestingManager::setQmlParent(QObject *parent) { setParent(parent); }
bool TestingManager::checkPwmCapture() { return mController.brick().pwmCapturePorts().length() != 0; }
