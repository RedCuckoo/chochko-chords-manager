#pragma once

#include <QDialog>
#include "ui_AddPlaylistDialog.h"

class AddPlaylistDialog : public QDialog {
	Q_OBJECT

public:
	AddPlaylistDialog(QWidget *parent = Q_NULLPTR);
	~AddPlaylistDialog();

private:
	Ui::AddPlaylistDialog ui;

private slots:
	void on_pushButton_clicked();
};