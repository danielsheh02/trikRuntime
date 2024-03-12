#include "modeManager.h"
#include "managers.h"
#include <QQmlContext>
#include <QSettings>
#include <trikKernel/paths.h>
using namespace trikKernel;

QString ModeManager::mCurrentMode;
ModeManager::ModeManager(QObject *parent) : QObject(parent) {}
void ModeManager::initMode() {
	QSettings settings(trikKernel::Paths::localSettings(),
			   QSettings::IniFormat);
	QString mode = settings.value("mode", "").toString();
	if (mode.isEmpty()) {
		settings.setValue("mode", "light");
		mode = "light";
	}
	ModeManager::mCurrentMode = mode;
	qQmlEngine->rootContext()->setContextProperty("ThemeMode", mode);
}

void ModeManager::switchMode(QString mode) {
	if (ModeManager::mCurrentMode != mode) {
		QSettings settings(trikKernel::Paths::localSettings(),
				   QSettings::IniFormat);
		settings.setValue("mode", mode);
		ModeManager::mCurrentMode = mode;
		qQmlEngine->rootContext()->setContextProperty("ThemeMode",
							      mode);
	}
}

void ModeManager::setQmlParent(QObject *parent) { setParent(parent); }

QString ModeManager::getCurrentMode() { return mCurrentMode; }
