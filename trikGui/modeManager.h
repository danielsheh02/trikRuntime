#pragma once
#include <QObject>

class ModeManager : public QObject
{
	Q_OBJECT
public:
	ModeManager(QObject *parent);
	static void initMode();
	Q_INVOKABLE void switchMode(QString mode);
	Q_INVOKABLE void setQmlParent(QObject *parent);
	Q_INVOKABLE QString getCurrentMode();

private:
	static QString mCurrentMode;
};
