TEMPLATE = lib
include(../global.pri)
DEFINES += TRIKUSERCPPPROGRAM_LIBRARY

CONFIG += c++11

SOURCES += \
    main.cpp \
    userCppClass.cpp

HEADERS += \
    trikUserCppProgram_global.h \
    userCppClass.h

implementationIncludes(trikKernel trikNetwork trikControl trikScriptRunner)
