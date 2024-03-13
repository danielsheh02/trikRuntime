#include "languageManager.h"

using namespace trikGui;
LanguageManager::LanguageManager(QQmlEngine *parent) : QObject(parent) {}

void LanguageManager::setLanguageSelection(
    LanguageSelection *languageSelection) {
	mLanguageSelection = languageSelection;
}

LanguageSelection *LanguageManager::languageSelection() {
	return mLanguageSelection;
}
