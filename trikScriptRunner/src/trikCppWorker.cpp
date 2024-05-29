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

#include "trikCppWorker.h"
#include <QThread>
#include <QsLog.h>
#include <trikKernel/exceptions/threadInterruptionException.h>

using namespace trikScriptRunner;
TrikCppWorker::TrikCppWorker(UserCppClassInterface *userObject, trikControl::BrickInterface *brick,
			     trikNetwork::MailboxInterface *mailbox, TrikScriptControlInterface *trikScriptControl,
			     int scriptId)
	: mBrick(brick), mMailbox(mailbox), mTrikScriptControl(trikScriptControl), mScriptId(scriptId) {
	mUserObject.reset(userObject);
}

TrikCppWorker::~TrikCppWorker() {}

void TrikCppWorker::run() {
	QString message = "";
	try {
		mUserObject->startProgram();
		QLOG_INFO() << "ScriptEngineWorker: evaluation ended";
		QThread::currentThread()->quit();
	} catch (trikKernel::ThreadInterruptionException &trik_ex) {
		QLOG_INFO() << "TrikCppWorker: evaluation ended with message" << trik_ex.what();
	} catch (std::exception &std_ex) {
		QLOG_ERROR() << "TrikCppWorker: evaluation ended with error" << std_ex.what();
		message = std_ex.what();
	} catch (...) {
		QLOG_FATAL();
		message = "Fatal error";
	}
	Q_EMIT completed(message, mScriptId);
}
