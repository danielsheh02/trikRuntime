#pragma once

#include <trikControl/encoderInterface.h>
using namespace trikControl;
namespace trikGui {

class EncoderMock : public EncoderInterface
{
	Q_OBJECT
public:
	EncoderMock(QObject *parent = nullptr);

	Status status() const override;

	const int mMaxValue{360};
	const int mMinValue{-360};

	bool reverse{false};

	int mValue{mMinValue};

public Q_SLOTS:
	int read() override;

	int readRawData() override;

	void reset() override;
};
} // namespace trikGui
