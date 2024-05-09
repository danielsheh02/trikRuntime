#include "trikCppWorker.h"
#include <QThread>
#include <QDebug>
#include <trikKernel/exceptions/threadInterruptionException.h>

using namespace trikScriptRunner;
TrikCppWorker::TrikCppWorker(UserCppClassInterface *userObject,
			     trikControl::BrickInterface *brick,
			     trikNetwork::MailboxInterface *mailbox,
			     TrikScriptControlInterface *trikScriptControl,
			     int scriptId)
    : mBrick(brick), mMailbox(mailbox), mTrikScriptControl(trikScriptControl),
      mScriptId(scriptId) {
	mUserObject.reset(userObject);
}

TrikCppWorker::~TrikCppWorker() {}

void TrikCppWorker::run() {

	QString message = "";
	try {
		mUserObject->runMyScript();
		QLOG_INFO() << "ScriptEngineWorker: evaluation ended";
		QThread::currentThread()->quit();
	} catch (trikKernel::ThreadInterruptionException &trik_ex) {
		QLOG_INFO() << "TrikCppWorker: evaluation ended with message"
			    << trik_ex.what();
	} catch (std::exception &std_ex) {
		QLOG_ERROR() << "TrikCppWorker: evaluation ended with error"
			     << std_ex.what();
		message = std_ex.what();
	} catch (...) {
		QLOG_FATAL();
		message = "Fatal error";
	}
	Q_EMIT completed(message, mScriptId);
}
