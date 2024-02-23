#pragma once
#include "abstractIndicator.h"
#include "trikControl/vectorSensorInterface.h"
// Q_DECLARE_METATYPE(QVector<int> *)

namespace trikGui {
class Accelerometer : public AbstractIndicator
{
	Q_OBJECT
	Q_PROPERTY(QVector<int> coords READ coords NOTIFY coordsChanged)

public:
	/// Constructor.
	/// @param accelerometer - accelerometer which we will read.
	/// @param parent - parent of this qobject in Qt object parent-child
	/// system.
	explicit Accelerometer(
	    trikControl::VectorSensorInterface *accelerometer,
	    QObject *parent = 0);

	~Accelerometer();

	QVector<int> coords();

public Q_SLOTS:
	void renew() override;

private:
	trikControl::VectorSensorInterface *mAccelerometer;
	QVector<int> mCoords;
Q_SIGNALS:
	void coordsChanged();
};
} // namespace trikGui
