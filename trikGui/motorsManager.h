#pragma once
#include "motors.h"
#include <QObject>
#include <QQmlEngine>
namespace trikGui {
class MotorsManager : public QObject
{
	Q_OBJECT
	Q_PROPERTY(Motors *motors READ motors CONSTANT)

public:
	explicit MotorsManager(QQmlEngine *parent = nullptr);

	Motors *motors();

	void setMotors(Motors *motors);

private:
	Motors *mMotors;
};
} // namespace trikGui
