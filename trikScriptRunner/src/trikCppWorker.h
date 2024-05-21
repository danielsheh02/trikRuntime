#pragma once
#include <trikControl/brickInterface.h>
#include <trikNetwork/mailboxInterface.h>
#include <QThread>
#include "../include/trikScriptRunner/userCppClassInterface.h"
#include "../include/trikScriptRunner/trikScriptControlInterface.h"

namespace trikScriptRunner {
class TrikCppWorker : public QThread
{
	Q_OBJECT
public:
	TrikCppWorker(UserCppClassInterface *userObject,
		      trikControl::BrickInterface *brick,
		      trikNetwork::MailboxInterface *mailbox,
		      TrikScriptControlInterface *trikScriptControl,
		      int scriptId);
	~TrikCppWorker();

	Q_SIGNAL void completed(const QString &error, int scriptId);

public:
	trikControl::BrickInterface *mBrick;
	trikNetwork::MailboxInterface *mMailbox;
	TrikScriptControlInterface *mTrikScriptControl;
	void (*mMyFunction)(trikControl::BrickInterface *,
			    trikNetwork::MailboxInterface *,
			    TrikScriptControlInterface *);
	QScopedPointer<UserCppClassInterface> mUserObject;

	int mScriptId;

protected:
	void run() override;
};
} // namespace trikScriptRunner
