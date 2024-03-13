#pragma once
#include "controller.h"
#include "fileManager.h"
#include "runningCode.h"
#include "systemSettings.h"
#include <QObject>
namespace trikGui {

class MainMenuManager : public QObject

{
	Q_OBJECT
public:
	explicit MainMenuManager(const QString &configPath,
				 QObject *parent = nullptr);
	~MainMenuManager();
	enum class AppType {
		Files,
		Testing,
		Settings,
		Network,
		CommSettings,
		Language,
		SystemSettings,
		AppearanceMode,
		Information
	};
	Q_ENUM(AppType)
	Q_INVOKABLE void createApp(AppType appType);
	Q_INVOKABLE void shutdown();

private Q_SLOTS:
	void
	changeFileManagerRoot(SystemSettings::FileManagerRootType const &path);

private:
	Controller mController;
	SystemSettings::FileManagerRootType
	    mFileManagerRoot; // current FilesManegerRoot
Q_SIGNALS:
	void fileManagerRootChanged(
	    SystemSettings::FileManagerRootType fileManagerRoot);
};
} // namespace trikGui
