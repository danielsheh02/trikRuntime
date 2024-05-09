#include "userCppClass.h"

UserCppClass::UserCppClass(
    trikControl::BrickInterface *brick, trikNetwork::MailboxInterface *mailbox,
    trikScriptRunner::TrikScriptControlInterface *trikScriptControl)
    : mBrick(brick), mMailbox(mailbox), mTrikScriptControl(trikScriptControl) {}

UserCppClass::~UserCppClass() {}

UserCppClass *UserCppClass::create(
    trikControl::BrickInterface *brick, trikNetwork::MailboxInterface *mailbox,
    trikScriptRunner::TrikScriptControlInterface *trikScriptControl) {
	return new UserCppClass(brick, mailbox, trikScriptControl);
}

void UserCppClass::runMyScript() {
	double kp = 2.5;
	double kd = -3;
	double dist = mBrick->sensor("A1")->read();
	double errOld = 0;
	double s = 0, err = 0, u = 0;
	while (true) {
		s = mBrick->sensor("A1")->read();
		err = dist - mBrick->sensor("A1")->read();
		u = kp * (dist - s) + kd * (errOld - err);
		errOld = err;

		mBrick->motor("M1")->setPower(50 + u);
		mBrick->motor("M2")->setPower(50 - u);

		mTrikScriptControl->wait(100);
	}
}
