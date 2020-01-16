#pragma once

#include <QMainWindow>
#include <QFile>
#include "ui_MainWindow.h"
#include <QProgressBar>
#include <QStatusBar>
#include <QLabel>
#include <QRegExp>

class MainWindow : public QMainWindow{
	Q_OBJECT

public:
	MainWindow(QWidget *parent = Q_NULLPTR);
	~MainWindow();

private:
	Ui::MainWindow ui;
	QStatusBar* topStatusBar;
	QProgressBar* progressBar;
	QLabel* label;

	QRegExp validatedSongUrl;
	

private slots:
	void on_actionNew_Song_triggered();
	void on_actionNew_Playlist_triggered();
	void on_actionDelete_selection_triggered();
	void on_actionHome_page_triggered();
	void on_webEngineView_loadFinished();
	void on_webEngineView_loadProgress(int);
	void on_webEngineView_urlChanged(QUrl);

};