#include "MainWindow.h"
#include "AddPlaylistDialog.h"
#include <QDir>
#include <QFileSystemModel>
#include <QDebug>
#include <QMessageBox>
#include <QWebEngineProfile>
#include "HTMLParser.h"

MainWindow::MainWindow(QWidget *parent) : QMainWindow(parent){
	ui.setupUi(this);

	if (!QDir("Playlists").exists()) {
		QDir().mkdir("Playlists");
	}
	
	if (!QDir("i").exists()) {
		QDir().mkdir("i");
		QDir().mkdir("i/img");
		QDir().mkdir("i/img/akkords");
	}


	QFileSystemModel* playlistsModel = new QFileSystemModel;
	playlistsModel->setRootPath(QDir::currentPath());
	
	ui.treeView->setModel(playlistsModel);
	ui.treeView->resizeColumnToContents(0);
	
	for (int i = 1, size = playlistsModel->columnCount(); i < size; ++i) {
		ui.treeView->setColumnHidden(i, true);
	}

	ui.treeView->setHeaderHidden(true);
	ui.treeView->setRootIndex(playlistsModel->index("Playlists"));

	QVBoxLayout* verticalLayout = new QVBoxLayout(this);

	progressBar = new QProgressBar();
	progressBar->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Fixed);
	verticalLayout->addWidget(progressBar);
	progressBar->hide();

	verticalLayout->addWidget(ui.statusBar);
	ui.verticalLayout->addLayout(verticalLayout);
	
	ui.statusBar->addWidget(label = new QLabel(this));
	label->setText("");

	ui.actionNew_song->setDisabled(true);

	validatedSongUrl = QRegExp("^(https\\:\\/\\/(www\\.)?mychords\\.net\\/)([\\da-z-_\\.]+\\/)*([\\da-z-_\\.]+\\.html)$");

	homepage = "https://mychords.net/";
	on_actionHome_page_triggered();
}

MainWindow::~MainWindow(){

}

//redo
void MainWindow::on_actionNew_song_triggered() {
	//get html code
	ui.webEngineView->page()->toHtml([this](const QString& a) {
		ui.actionNew_song->setEnabled(false);
		progressBar->setMaximum(0);
		progressBar->setTextVisible(false);
		progressBar->show();
		QString parsedPage = HTMLParser(a, this).getText();
		parsedPage.replace(QRegExp("^"), "For original page click <a href=\"" + ui.webEngineView->url().toString() + "\">here</a>");

		QString title = ui.webEngineView->title();

		QModelIndexList selectedIndexes = ui.treeView->selectionModel()->selectedIndexes();
		if (selectedIndexes.size() > 0) {
			QString playlistName = selectedIndexes.at(0).data().toString();
			QFile* newSong = new QFile();

			newSong->setFileName(QDir::currentPath() + "/Playlists/" + playlistName + '/' + title + ".html");
			newSong->open(QIODevice::WriteOnly);
			QTextStream outputHTML(newSong);
			outputHTML.setCodec("UTF-8");
			outputHTML.setGenerateByteOrderMark(false);
			outputHTML << parsedPage.toUtf8();
				qDebug() << parsedPage;
			newSong->close();
		}
		progressBar->hide();
		progressBar->setMaximum(100);
		progressBar->setTextVisible(true);
	});
}

void MainWindow::on_actionNew_playlist_triggered() {
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
			QString parentName = selectedIndexes.at(0).parent().data().toString();
			//QString removePath;
			//QString filePath = ((parentName == "Playlists") ? "" : parentName + "/") + selectionName;
			//qDebug() << filePath;
			//QDir(QDir::currentPath() + "/Playlists/" + filePath).removeRecursively();

			if (parentName == "Playlists") {
				QDir(QDir::currentPath() + "/Playlists/" + selectionName).removeRecursively();
			}
			else {
				QFile::remove(QDir::currentPath() + "/Playlists/" + parentName + '/' + selectionName);
			}
		}
	}
}

void MainWindow::on_actionHome_page_triggered() {
	ui.webEngineView->load(homepage);
}

void MainWindow::on_actionGo_back_triggered() {
	ui.webEngineView->triggerPageAction(QWebEnginePage::Back);
}

void MainWindow::on_actionGo_forward_triggered() {
	ui.webEngineView->triggerPageAction(QWebEnginePage::Forward);
}

void MainWindow::on_actionRefresh_triggered() {
	ui.webEngineView->triggerPageAction(QWebEnginePage::Reload);
}

void MainWindow::on_webEngineView_loadFinished() {
	progressBar->hide();

	QString currentUrl = label->text();

	if (currentUrl.contains(validatedSongUrl)) {
		ui.actionNew_song->setEnabled(true);
	}
	else {
		ui.actionNew_song->setDisabled(true);
	}
}

void MainWindow::on_webEngineView_loadProgress(int progress) {
	progressBar->show();
	progressBar->setValue(progress);
}

void MainWindow::on_webEngineView_urlChanged(QUrl newUrl) {
	QString currentUrl = newUrl.toString();

	label->setText(currentUrl);
}

void MainWindow::on_treeView_doubleClicked(QModelIndex index) {
	QString parentName = index.parent().data().toString();
	if (!(parentName == "Playlists")) {
		ui.webEngineView->load(QDir::currentPath() + "/Playlists/" + parentName + "/" + index.data().toString());
	}
}