#pragma once

#include "sensors.h"
#include <QObject>
#include <QQmlEngine>
using namespace trikGui;
class SensorsManager : public QObject
{
	Q_OBJECT
	Q_PROPERTY(Sensors *sensors READ sensors CONSTANT)
public:
	explicit SensorsManager(QQmlEngine *parent = nullptr);

	Sensors *sensors();

	void setSensors(Sensors *sensors);

private:
	Sensors *mSensors;
};
