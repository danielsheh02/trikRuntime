#pragma once

#include "trikRuntimeException.h"

namespace trikKernel {

/// Exception that is thrown when something is wrong with implementation of
/// trikRuntime.
class ThreadInterruptionException : public std::runtime_error
{
public:
	/// Constructor.
	/// @param message - information about what went wrong.
	explicit ThreadInterruptionException(const QString &message)
	    : std::runtime_error(message.toStdString()) {}
};

} // namespace trikKernel
