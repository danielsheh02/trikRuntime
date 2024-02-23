#include "sensorsManager.h"
using namespace trikGui;
SensorsManager::SensorsManager(QQmlEngine *parent) : QObject(parent) {}

void SensorsManager::setSensors(Sensors *sensors) { mSensors = sensors; }

Sensors *SensorsManager::sensors() { return mSensors; }
