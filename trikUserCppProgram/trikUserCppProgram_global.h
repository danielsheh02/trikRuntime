#pragma once

#include <QtCore/qglobal.h>

#if defined(TRIKUSERCPPPROGRAM_LIBRARY)
#define TRIKUSERCPPPROGRAM_EXPORT Q_DECL_EXPORT
#else
#define TRIKUSERCPPPROGRAM_EXPORT Q_DECL_IMPORT
#endif
