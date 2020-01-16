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
	//qDebug() << QDir::currentPath();
	playlistsModel->setRootPath(QDir::currentPath());
	
	ui.treeView->setModel(playlistsModel);
	ui.treeView->resizeColumnToContents(0);
	
	for (int i = 1, size = playlistsModel->columnCount(); i < size; ++i) {
		ui.treeView->setColumnHidden(i, true);
	}

	ui.treeView->setHeaderHidden(true);
	ui.treeView->setRootIndex(playlistsModel->index("Playlists"));

	(topStatusBar = new QStatusBar(this))->addWidget(progressBar = new QProgressBar(this));
	QVBoxLayout* verticalLayout = new QVBoxLayout(this);
	verticalLayout->addWidget(topStatusBar);
	verticalLayout->addWidget(ui.statusBar);
	ui.verticalLayout->addLayout(verticalLayout);
	progressBar->hide();

	ui.statusBar->addWidget(label = new QLabel(this));
	label->setText("");

	ui.actionNew_Song->setDisabled(true);


	validatedSongUrl = QRegExp("^(https\\:\\/\\/(www\\.)?mychords\\.net\\/)([\\da-z-_\\.]+\\/)*([\\da-z-_\\.]+\\.html)$");

}

MainWindow::~MainWindow(){

}

//redo
void MainWindow::on_actionNew_Song_triggered() {
	
	ui.webEngineView->page()->toHtml([this](const QString& a) {
		QString title = ui.webEngineView->title();
		QModelIndexList selectedIndexes = ui.treeView->selectionModel()->selectedIndexes();
		if (selectedIndexes.size() > 0) {
			QString playlistName = selectedIndexes.at(0).data().toString();
			QFile* newSong = new QFile();

			newSong->setFileName(QDir::currentPath() + "/Playlists/" + playlistName + '/' + title + ".html");
			newSong->open(QIODevice::WriteOnly);
			QTextStream outputHTML(newSong);
			outputHTML << a;
			newSong->close();

			
		
		}

	});

	QFile testQFile(QDir::currentPath() + "/Playlists/" + ui.treeView->selectionModel()->selectedIndexes().at(0).data().toString() + '/' + ui.webEngineView->title() + ".html");
	testQFile.open(QIODevice::ReadOnly);
	ui.webEngineView->setHtml(QTextStream(&testQFile).readAll());
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

void MainWindow::on_actionHome_page_triggered() {
	ui.webEngineView->load(QUrl("https://mychords.net/"));
}

void MainWindow::on_webEngineView_loadFinished() {
	progressBar->hide();
}

void MainWindow::on_webEngineView_loadProgress(int progress) {
	progressBar->show();
	progressBar->setValue(progress);
}

void MainWindow::on_webEngineView_urlChanged(QUrl newUrl) {
	QString currentUrl = newUrl.toString();

	label->setText(currentUrl);
	
	if (currentUrl.contains(validatedSongUrl)){
		ui.actionNew_Song->setEnabled(true);
	}
	else {
		ui.actionNew_Song->setDisabled(true);
	}
}

