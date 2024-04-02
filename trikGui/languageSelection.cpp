/* Copyright 2015 CyberTech Labs Ltd.
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

#include "languageSelection.h"

#include <QsLog.h>

#include <QApplication>
#include <QDir>
#include <QDirIterator>
#include <QKeyEvent>
#include <QMessageBox>
#include <QSettings>
#include <QStringLiteral>

#include <trikKernel/paths.h>

using namespace trikGui;

LanguageSelection::LanguageSelection(QObject *parent)
    : QAbstractListModel(parent) {
	mAvailableLocales.push_back("en");
	loadLocales();
}

void LanguageSelection::loadLocales() {
	const QDir translationsDirectory(trikKernel::Paths::translationsPath());
	QDirIterator files(translationsDirectory.absolutePath(), QDir::Files);
	while (files.hasNext()) {
		const QFileInfo localeInfo(files.next());
		if (localeInfo.exists()) {
			QString baseName = localeInfo.baseName();
			if (!baseName.isEmpty() && baseName.contains('_')) {
				QStringList parts = baseName.split('_');
				QString langCode = parts.at(1);
				if (langCode != "") {
					mAvailableLocales.push_back(langCode);
				}
			}
		}
	}
}

int LanguageSelection::rowCount(const QModelIndex &parent) const {
	if (parent.isValid()) {
		return -1;
	}
	return mAvailableLocales.size();
}

QVariant LanguageSelection::data(const QModelIndex &index, int role) const {
	if (!index.isValid() || role != Qt::DisplayRole) {
		return {};
	}

	const int index_row{static_cast<int>(index.row())};
	return QVariant::fromValue(mAvailableLocales[index_row]);
}

QVector<QString> LanguageSelection::availableLocales() {
	return mAvailableLocales;
}

void LanguageSelection::switchLanguage(QString targetLanguage) {
	QSettings settings(trikKernel::Paths::localSettings(),
			   QSettings::IniFormat);
	settings.setValue("locale", targetLanguage);
	settings.sync();
	QApplication::exit();
	// Translation does not work in real time on Qt version 5.10.
	// Uncomment these lines when updating the Qt version in Trik.
	// trikKernel::TranslationsHelper::initLocale(false);
	// qQmlEngine->retranslate();
}

void LanguageSelection::setQmlParent(QObject *parent) { setParent(parent); }
