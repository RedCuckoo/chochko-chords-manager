#pragma once

#include <QMainWindow>
#include <QFile>
#include "ui_MainWindow.h"

class MainWindow : public QMainWindow{
	Q_OBJECT

public:
	MainWindow(QWidget *parent = Q_NULLPTR);
	~MainWindow();

private:
	Ui::MainWindow ui;

private slots:
	void on_actionNew_Song_triggered();
	void on_actionNew_Playlist_triggered();
	void on_actionDelete_selection_triggered();
};