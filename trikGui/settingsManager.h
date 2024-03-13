#pragma once
#include <QObject>
namespace trikGui {
class SettingsManager : public QObject
{
	Q_OBJECT
public:
	explicit SettingsManager(QObject *parent = nullptr);
	enum class AppType {
		Network,
		CommSettings,
		Language,
		SystemSettings,
		Information
	};
	Q_ENUM(AppType)
	Q_INVOKABLE void createApp(AppType appType);
};
} // namespace trikGui
