#pragma once

#include <QMessageBox>
#include "ui_GreetingMessageBox.h"

class GreetingMessageBox : public QMessageBox{
	Q_OBJECT

public:
	GreetingMessageBox(QWidget *parent = Q_NULLPTR);
	~GreetingMessageBox();

private:
	Ui::GreetingMessageBox ui;

};
