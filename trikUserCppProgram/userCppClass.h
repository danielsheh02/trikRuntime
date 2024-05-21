#pragma once
#include <trikScriptRunner/userCppClassInterface.h>
#include <trikControl/brickInterface.h>
#include <trikNetwork/mailboxInterface.h>
#include <trikScriptRunner/trikScriptControlInterface.h>
class UserCppClass : trikScriptRunner::UserCppClassInterface
{
private:
	UserCppClass(trikControl::BrickInterface *brick, trikNetwork::MailboxInterface *mailbox,
		     trikScriptRunner::TrikScriptControlInterface *trikScriptControl);

public:
	~UserCppClass();
	static UserCppClass *create(trikControl::BrickInterface *brick, trikNetwork::MailboxInterface *mailbox,
				    trikScriptRunner::TrikScriptControlInterface *trikScriptControl);
	trikControl::BrickInterface *mBrick;
	trikNetwork::MailboxInterface *mMailbox;
	trikScriptRunner::TrikScriptControlInterface *mTrikScriptControl;
	void startProgram() override;
};
