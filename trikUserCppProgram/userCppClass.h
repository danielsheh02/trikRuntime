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

#pragma once
#include <trikScriptRunner/userCppClassInterface.h>
#include <trikControl/brickInterface.h>
#include <trikNetwork/mailboxInterface.h>
#include <trikScriptRunner/trikScriptControlInterface.h>
/// Custom class with an algorithm for a robot in C++
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
