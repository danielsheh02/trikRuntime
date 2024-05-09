#include "userCppClass.h"
#include <trikControl/brickInterface.h>
#include <trikNetwork/mailboxInterface.h>
#include <trikScriptRunner/trikScriptControlInterface.h>

extern "C" {
Q_DECL_EXPORT UserCppClass *
createMyClass(trikControl::BrickInterface *brick,
	      trikNetwork::MailboxInterface *mailbox,
	      trikScriptRunner::TrikScriptControlInterface *trikScriptControl) {
	return UserCppClass::create(brick, mailbox, trikScriptControl);
}
}
