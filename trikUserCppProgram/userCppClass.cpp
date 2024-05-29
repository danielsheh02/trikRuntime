/* Copyright 2024 Daniel Chehade
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

#include "userCppClass.h"

UserCppClass::UserCppClass(trikControl::BrickInterface *brick, trikNetwork::MailboxInterface *mailbox,
			   trikScriptRunner::TrikScriptControlInterface *trikScriptControl)
	: mBrick(brick), mMailbox(mailbox), mTrikScriptControl(trikScriptControl) {}

UserCppClass::~UserCppClass() {}

UserCppClass *UserCppClass::create(trikControl::BrickInterface *brick, trikNetwork::MailboxInterface *mailbox,
				   trikScriptRunner::TrikScriptControlInterface *trikScriptControl) {
	return new UserCppClass(brick, mailbox, trikScriptControl);
}

void UserCppClass::startProgram() {
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
