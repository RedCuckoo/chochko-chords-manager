#include "MainWindow.h"
#include "AddPlaylistDialog.h"
#include <QDir>
#include <QFileSystemModel>
#include <QDebug>
#include <QMessageBox>

MainWindow::MainWindow(QWidget *parent) : QMainWindow(parent){
	ui.setupUi(this);

	if (!QDir("Playlists").exists()) {
		QDir().mkdir("Playlists");
	}

	QFileSystemModel* playlistsModel = new QFileSystemModel;
	qDebug() << QDir::currentPath();
	playlistsModel->setRootPath(QDir::currentPath());
	
	ui.treeView->setModel(playlistsModel);
	ui.treeView->resizeColumnToContents(0);
	
	for (int i = 1, size = playlistsModel->columnCount(); i < size; ++i) {
		ui.treeView->setColumnHidden(i, true);
	}

	ui.treeView->setHeaderHidden(true);
	ui.treeView->setRootIndex(playlistsModel->index("Playlists"));
}

MainWindow::~MainWindow(){

}

void MainWindow::on_actionNew_Song_triggered() {

}

void MainWindow::on_actionNew_Playlist_triggered() {
	AddPlaylistDialog* createPlaylist = new AddPlaylistDialog(this);
	createPlaylist->open();
}

void MainWindow::on_actionDelete_selection_triggered() {
	QModelIndexList selectedIndexes = ui.treeView->selectionModel()->selectedIndexes();

	if (selectedIndexes.size() > 0) {
		QString selectionName = selectedIndexes.at(0).data().toString();

		QMessageBox::StandardButton sure;
		sure = QMessageBox::question(this, "Attention", "Are you sure you would like to delete \"" + selectionName + "\"?", QMessageBox::Yes | QMessageBox::No);

		if (sure == QMessageBox::Yes) {
			QDir(QDir::currentPath() + "/Playlists/" + selectionName).removeRecursively();
		}
	}
}