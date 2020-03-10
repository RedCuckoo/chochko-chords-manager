#ifndef MAINWINDOW_H
#define MAINWINDOW_H

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
    Ui::MainWindow* ui;
    QProgressBar* progressBar;
    QLabel* label;
    QUrl* homepage;
    QRegExp validatedSongUrl;


private slots:
    void on_actionGo_back_triggered();
    void on_actionGo_forward_triggered();
    void on_actionRefresh_triggered();
    void on_actionHome_page_triggered();
    void on_actionNew_playlist_triggered();
    void on_actionDelete_selection_triggered();
    void on_actionNew_song_triggered();

    void on_webEngineView_loadFinished();
    void on_webEngineView_loadProgress(int);
    void on_webEngineView_urlChanged(const QUrl&);

    void on_treeView_doubleClicked(const QModelIndex&);
};

#endif // MAINWINDOW_H
