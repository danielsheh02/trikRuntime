#include "trikCppRunner.h"
#include <QThread>
#include "trikCppWorker.h"
#include <QsLog.h>
#include "userCppClassInterface.h"

using namespace trikScriptRunner;
typedef void (*myFunction)(trikControl::BrickInterface *,
			   trikNetwork::MailboxInterface *,
			   trikScriptRunner::TrikScriptControlInterface *);

TrikCppRunner::TrikCppRunner(trikControl::BrickInterface *brick,
			     trikNetwork::MailboxInterface *mailbox,
			     TrikScriptControlInterface *scriptControl)
    : mBrick(brick), mMailbox(mailbox), mScriptControl(scriptControl) {}

void TrikCppRunner::run(const QString &filePath, const QString &fileName) {
	int scriptId = mMaxScriptId++;
	Q_EMIT startedScript(fileName, scriptId);
	mLib.setFileName(filePath);

	auto symptr = mLib.resolve("createMyObject");
	if (!symptr) {
		Q_EMIT completed("Function createMyObject was not resolve",
				 scriptId);
		return;
	}
	UserCppClassInterface *(*userCppClassFactory)(
	    trikControl::BrickInterface * brick,
	    trikNetwork::MailboxInterface * mailbox,
	    trikScriptRunner::TrikScriptControlInterface * trikScriptControl) =
	    reinterpret_cast<UserCppClassInterface *(
		    *)(trikControl::BrickInterface * brick,
		       trikNetwork::MailboxInterface * mailbox,
		       trikScriptRunner::TrikScriptControlInterface *
			   trikScriptControl)>(symptr);
	if (!userCppClassFactory) {
		Q_EMIT completed(
		    "Error returning or casting a pointer to a user object",
		    scriptId);
		return;
	}
	if (trikCppWorker.isNull()) {
		trikCppWorker.reset(new TrikCppWorker(
		    userCppClassFactory(mBrick, mMailbox, mScriptControl),
		    mBrick, mMailbox, mScriptControl, scriptId));
	}
	connect(trikCppWorker.data(), &TrikCppWorker::completed, this,
		&TrikCppRunner::completed);
	connect(trikCppWorker.data(), &QThread::finished, this,
		&TrikCppRunner::clean);
	trikCppWorker->start();
}

void TrikCppRunner::abort() {
	if (!trikCppWorker.isNull()) {
		trikCppWorker->requestInterruption();
		trikCppWorker->quit();
		trikCppWorker->wait();
	}
}

void TrikCppRunner::clean() { trikCppWorker.reset(); }

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
