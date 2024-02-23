#pragma once
#include "languageSelection.h"
#include <QObject>
#include <QQmlEngine>

namespace trikGui {
class LanguageManager : public QObject
{
	Q_OBJECT
	Q_PROPERTY(LanguageSelection *languageSelection READ languageSelection
		       CONSTANT)
public:
	explicit LanguageManager(QQmlEngine *parent = nullptr);
	LanguageSelection *languageSelection();

	void setLanguageSelection(LanguageSelection *languageSelection);

private:
	LanguageSelection *mLanguageSelection;
};
} // namespace trikGui
