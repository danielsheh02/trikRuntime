#include "encoderMock.h"
#include <QDebug>
using namespace trikControl;
using namespace trikGui;

EncoderMock::EncoderMock(QObject *parent) { setParent(parent); }

int EncoderMock::read() {
	if (!reverse && mValue < mMaxValue) {
		mValue += 30;
	} else {
		reverse = true;
	}
	if (reverse && mValue > mMinValue) {
		mValue -= 30;
	} else {
		reverse = false;
	}
	return mValue;
}

int EncoderMock::readRawData() { return 0; }

void EncoderMock::reset() {}

trikControl::DeviceInterface::Status EncoderMock::status() const {
	return trikControl::DeviceInterface::Status::ready;
}
