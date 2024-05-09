#pragma once

#include "trikScriptRunnerDeclSpec.h"
namespace trikScriptRunner {
class TRIKSCRIPTRUNNER_EXPORT UserCppClassInterface
{
	Q_DISABLE_COPY(UserCppClassInterface)

public:
	UserCppClassInterface() = default;

	virtual ~UserCppClassInterface() = default;

	virtual void runMyScript() = 0;
};
} // namespace trikScriptRunner
