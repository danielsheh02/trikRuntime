#pragma once
#include <trikControl/brickInterface.h>
#include <trikNetwork/mailboxInterface.h>
#include "trikScriptControlInterface.h"
#include <QObject>
#include "../../src/trikCppWorker.h"
#include <QSharedPointer>
#include <QScopedPointer>
#include <QLibrary>

namespace trikScriptRunner {
class TrikCppRunner : public QObject
{
	Q_OBJECT
public:
	TrikCppRunner(trikControl::BrickInterface *brick,
		      trikNetwork::MailboxInterface *mailbox,
		      TrikScriptControlInterface *scriptControl);
	~TrikCppRunner();
	void run(const QString &filePath, const QString &fileName);
	void abort();
	void reset();
	static void runParallel();

private:
	trikControl::BrickInterface *mBrick{};	   // Does not have ownership.
	trikNetwork::MailboxInterface *mMailbox{}; // Does not have ownership.
	TrikScriptControlInterface
	    *mScriptControl{}; // Does not have ownership.
	QScopedPointer<TrikCppWorker> trikCppWorker;

	QLibrary mLib;
	int mMaxScriptId = 0;
private Q_SLOTS:
	void clean();
Q_SIGNALS:
	/// Emitted when current script completes execution (for event-driven
	/// mode it means that script requested to quit or was aborted).
	/// @param error - localized error message if any error occured during
	/// script execution or empty string if everything is fine.
	/// @param scriptId - unique identifier of a script completed
	void completed(const QString &error, int scriptId);
	void abortCpp();

	/// Emitted when new script from file started.
	/// @param fileName - name of a file from where the script was loaded.
	/// @param scriptId - unique id of executed script assigned when script
	/// started.
	void startedScript(const QString &fileName, int scriptId);
};
} // namespace trikScriptRunner
