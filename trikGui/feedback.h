#pragma once

#include <QObject>

class Feedback : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString nameImage READ nameImage NOTIFY nameImageChanged)

public:
	Feedback(QObject *parent = nullptr);

	Q_INVOKABLE void setQmlParent(QObject *parent);

	QString mNameImage;

private:
	QString nameImage();

Q_SIGNALS:
	void nameImageChanged();
};
