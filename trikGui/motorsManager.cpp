#include "motorsManager.h"
using namespace trikGui;
MotorsManager::MotorsManager(QQmlEngine *parent) : QObject(parent) {}

void MotorsManager::setMotors(Motors *motors) { mMotors = motors; }

Motors *MotorsManager::motors() { return mMotors; }
