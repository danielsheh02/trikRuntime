/* Copyright 2013 Roman Kurbatov
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

/* This file was modified by Yurii Litvinov to make it comply with the
 * requirements of trikRuntime project. See git revision history for detailed
 * changes. */

#pragma once

#include <QtCore/qglobal.h>

#include <QFileIconProvider>
#include <QFileSystemModel>

#include "controller.h"
#include "systemSettings.h"
namespace trikGui {

/// File system browser able to launch executable files and .qts scripts.
class FileManager : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QFileSystemModel *fileSystemModel READ fileSystemModel NOTIFY
		       fileSystemModelChanged)

	Q_PROPERTY(
	    QModelIndex indexOfCurrentPath READ indexOfCurrentPath CONSTANT)
	Q_PROPERTY(QString currentPath READ currentPath CONSTANT)

	/// Default QFileIconProvider spend about 10 seconds for scanning empty
	/// directory for file icons (Qt 5.8.0), so here is suggested the light
	/// overwrite version of QFileIconProvider class. In future it can be
	/// used to divide icons for ".py" and ".js" files.
	class LightFileIconProvider : public QFileIconProvider
	{
	public:
		/// Ligth version of icon method
		QIcon icon(IconType) const override;

		/// Ligth version of icon method
		QIcon icon(const QFileInfo &) const override;

		// /// Ligth version of type method
		// QString type(const QFileInfo &) const override;
	};

public:
	/// Constructor
	/// @param controller - reference to controller object which provides
	/// access to low-level functionality.
	/// @param fileManagerRoot - root directory for file browser.
	/// @param parent - parent of this widget in Qt object hierarchy.
	explicit FileManager(
	    Controller &controller,
	    SystemSettings::FileManagerRootType fileManagerRoot,
	    QObject *parent = 0);

	~FileManager();

	Q_INVOKABLE void open(QModelIndex index);
	Q_INVOKABLE void remove(QModelIndex index);
	Q_INVOKABLE void removeAll();
	Q_INVOKABLE bool isDir(QModelIndex i);
	Q_INVOKABLE void setQmlParent(QObject *parent);

private Q_SLOTS:
	void onDirectoryLoaded(const QString &path);

private:
	void showCurrentDir();
	void setFiltersForCurrentDir();
	QFileSystemModel *fileSystemModel();
	QModelIndex indexOfCurrentPath();
	QString currentPath();
	QScopedPointer<LightFileIconProvider> mFileIconProvider;
	QFileSystemModel mFileSystemModel;
	Controller &mController;
	QString mRootDirPath;
	QString mLastSelectedFile;

Q_SIGNALS:
	void fileSystemModelChanged();
};

} // namespace trikGui
