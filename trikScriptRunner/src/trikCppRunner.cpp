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

#include <QsLog.h>
#include <QThread>
#include "trikCppRunner.h"
#include "trikCppWorker.h"
#include "userCppClassInterface.h"

using namespace trikScriptRunner;
typedef void (*myFunction)(trikControl::BrickInterface *, trikNetwork::MailboxInterface *,
			   trikScriptRunner::TrikScriptControlInterface *);

TrikCppRunner::TrikCppRunner(trikControl::BrickInterface *brick, trikNetwork::MailboxInterface *mailbox,
			     TrikScriptControlInterface *scriptControl)
	: mBrick(brick), mMailbox(mailbox), mScriptControl(scriptControl) {}

void TrikCppRunner::run(const QString &filePath, const QString &fileName) {
	int scriptId = mMaxScriptId++;
	Q_EMIT startedScript(fileName, scriptId);
	mLib.setFileName(filePath);

	auto symptr = mLib.resolve("createMyObject");
	if (!symptr) {
		Q_EMIT completed("Function createMyObject was not resolve", scriptId);
		return;
	}
	UserCppClassInterface *(*userCppClassFactory)(
	    trikControl::BrickInterface * brick, trikNetwork::MailboxInterface * mailbox,
	    trikScriptRunner::TrikScriptControlInterface * trikScriptControl) =
	    reinterpret_cast<
		UserCppClassInterface *(*)(trikControl::BrickInterface * brick, trikNetwork::MailboxInterface * mailbox,
					   trikScriptRunner::TrikScriptControlInterface * trikScriptControl)>(symptr);
	if (!userCppClassFactory) {
		Q_EMIT completed("Error returning or casting a pointer to a user object", scriptId);
		return;
	}
	if (trikCppWorker.isNull()) {
		trikCppWorker.reset(new TrikCppWorker(userCppClassFactory(mBrick, mMailbox, mScriptControl), mBrick,
						      mMailbox, mScriptControl, scriptId));
	}
	connect(trikCppWorker.data(), &TrikCppWorker::completed, this, &TrikCppRunner::completed);
	connect(trikCppWorker.data(), &QThread::finished, this, &TrikCppRunner::clean);
	trikCppWorker->start();
}

void TrikCppRunner::abort() {
	if (!trikCppWorker.isNull()) {
		trikCppWorker->requestInterruption();
		trikCppWorker->quit();
		trikCppWorker->wait();
	}
}

void TrikCppRunner::clean() {
	reset();
	trikCppWorker.reset();
	mLib.unload();
}

void TrikCppRunner::reset() {
	QLOG_INFO() << "Stopping robot";
	mScriptControl->reset();
	if (mMailbox) {
		mMailbox->stopWaiting();
		mMailbox->clearQueue();
	}
	mBrick->reset();
}

TrikCppRunner::~TrikCppRunner() {}
