/* Copyright 2013 - 2015 Roman Kurbatov and CyberTech Labs Ltd.
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
 * limitations under the License.
 *
 * This file was modified by Yurii Litvinov to make it comply with the
 * requirements of trikRuntime project. See git revision history for detailed
 * changes. */

#include "fileManager.h"

#include <QtCore/QDir>
#include <QtCore/QSettings>

#include "managers.h"
#include <QQmlContext>
#include <QsLog.h>
#include <trikKernel/exceptions/trikRuntimeException.h>
#include <trikKernel/paths.h>

using namespace trikGui;

FileManager::FileManager(Controller &controller,
			 SystemSettings::FileManagerRootType fileManagerRoot,
			 QObject *parent)
    : QObject(parent), mFileIconProvider(new LightFileIconProvider()),
      mController(controller) {
	QDir dir(trikKernel::Paths::userScriptsPath());

	if (!dir.exists()) {
		const bool result =
		    dir.mkpath(trikKernel::Paths::userScriptsPath());
		if (!result) {
			QLOG_ERROR() << "Incorrect user scripts directory";
		}
	}

	if (dir.exists()) {
		QDir::setCurrent(trikKernel::Paths::userScriptsPath());
	} else {
		// Fallback directory, if user scripts are unavailable for some
		// reason.
		QDir::setCurrent("/home/root/");
	}

	if (fileManagerRoot == SystemSettings::FileManagerRootType::AllFS) {
		mRootDirPath = QDir::rootPath();
	} else { // if (fileManagerRoot ==
		 // MainWidget::FileManagerRootType::scriptsDir)
		mRootDirPath = trikKernel::Paths::userScriptsPath();
	}

	mFileSystemModel.setIconProvider(mFileIconProvider.data());
	mFileSystemModel.setRootPath(mRootDirPath);
	mFileSystemModel.setFilter(QDir::AllEntries | QDir::Hidden |
				   QDir::System | QDir::NoDot);

	connect(&mFileSystemModel, &QFileSystemModel::directoryLoaded, this,
		&FileManager::onDirectoryLoaded);

	setFiltersForCurrentDir();
}

FileManager::~FileManager() {}

void FileManager::open(QModelIndex index) {
	if (mFileSystemModel.isDir(index)) {
		if (QDir::setCurrent(mFileSystemModel.filePath(index))) {
			showCurrentDir();
		}
	} else {
		mController.runFile(mFileSystemModel.filePath(index));
	}
}

void FileManager::remove(QModelIndex index) {
	if (!mFileSystemModel.isDir(index)) {
		mFileSystemModel.remove(index);
	}
}

bool FileManager::isDir(QModelIndex i) {
	// QModelIndex index = mFileSystemModel.index(
	//     i, 0, mFileSystemModel.index(QDir::currentPath()));
	return mFileSystemModel.isDir(i);
}

void FileManager::removeAll() {
	QDir dir(trikKernel::Paths::userScriptsPath());
	dir.setNameFilters({"*.js", "*.py"});
	dir.setFilter(QDir::Files);
	for (auto &&dirFile : dir.entryList()) {
		dir.remove(dirFile);
	}
}

QString FileManager::currentPath() {
	QString result = QDir(QDir::currentPath()).canonicalPath();
	if (mRootDirPath != "/") {
		/// @todo: fix this.
		const auto prefixLength =
		    result.indexOf("scripts") + QString("scripts").length();
		result = result.replace(0, prefixLength, "");
	}
	if (result.isEmpty()) {
		result = "/";
	} else if (result.count("/") > 2) {
		result = "/../" + result.section("/", result.count("/") - 1,
						 result.count("/"));
	}

	return result;
}

void FileManager::showCurrentDir() {
	setFiltersForCurrentDir();
	mFileSystemModel.sort(0);
	Q_EMIT fileSystemModelChanged();
}

void FileManager::setFiltersForCurrentDir() {
	QDir::Filters filters = mFileSystemModel.filter();
	if (QFileInfo(QDir::currentPath()) == QFileInfo(mRootDirPath)) {
		filters |= QDir::NoDotDot;
	} else {
		filters &= ~QDir::NoDotDot;
	}

	filters &= ~QDir::Hidden;
	mFileSystemModel.setFilter(filters);
}

void FileManager::onDirectoryLoaded(const QString &path) {
	if (QDir::currentPath() != path) {
		return;
	}

	mFileSystemModel.sort(0);

	Q_EMIT fileSystemModelChanged();
}

QIcon FileManager::LightFileIconProvider::icon(
    QFileIconProvider::IconType) const {
	return QIcon();
}

QIcon FileManager::LightFileIconProvider::icon(const QFileInfo &) const {
	return QIcon();
}

// QString FileManager::LightFileIconProvider::type(const QFileInfo &) const {
//     return QString();
// }

QFileSystemModel *FileManager::fileSystemModel() { return &mFileSystemModel; }

QModelIndex FileManager::indexOfCurrentPath() {
	return mFileSystemModel.index(QDir::currentPath());
}

void FileManager::setQmlParent(QObject *parent) { setParent(parent); }
