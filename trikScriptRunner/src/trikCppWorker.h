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
#include <trikControl/brickInterface.h>
#include <trikNetwork/mailboxInterface.h>
#include <trikScriptControlInterface.h>
#include <userCppClassInterface.h>
#include <QThread>

namespace trikScriptRunner {
/// Class is responsible for executing C++ code in a separate thread
class TrikCppWorker : public QThread
{
	Q_OBJECT
public:
	TrikCppWorker(UserCppClassInterface *userObject, trikControl::BrickInterface *brick,
		      trikNetwork::MailboxInterface *mailbox, TrikScriptControlInterface *trikScriptControl,
		      int scriptId);
	~TrikCppWorker();

	/// Signal about the end of the program
	Q_SIGNAL void completed(const QString &error, int scriptId);

public:
	trikControl::BrickInterface *mBrick; // Does not have ownership.
	trikNetwork::MailboxInterface *mMailbox; // Does not have ownership.
	TrikScriptControlInterface *mTrikScriptControl; // Does not have ownership.
	void (*mMyFunction)(trikControl::BrickInterface *, trikNetwork::MailboxInterface *,
			    TrikScriptControlInterface *);
	QScopedPointer<UserCppClassInterface> mUserObject;

	int mScriptId;

protected:
	void run() override;
};
} // namespace trikScriptRunner
