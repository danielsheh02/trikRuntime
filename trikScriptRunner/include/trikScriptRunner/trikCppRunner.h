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
#include <QObject>
#include <QScopedPointer>
#include <QLibrary>
#include "trikScriptControlInterface.h"

namespace trikScriptRunner {
class TrikCppWorker;
/// Class responsible for executing C++ code
class TrikCppRunner : public QObject
{
	Q_OBJECT
public:
	TrikCppRunner(trikControl::BrickInterface *brick, trikNetwork::MailboxInterface *mailbox,
		      TrikScriptControlInterface *scriptControl);
	~TrikCppRunner();
	/// Running the code
	void run(const QString &filePath, const QString &fileName);
	/// Abort execution
	void abort();
	/// Reset the system after completion of execution
	void reset();

private:
	trikControl::BrickInterface *mBrick{};	      // Does not have ownership.
	trikNetwork::MailboxInterface *mMailbox{};    // Does not have ownership.
	TrikScriptControlInterface *mScriptControl{}; // Does not have ownership.
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
