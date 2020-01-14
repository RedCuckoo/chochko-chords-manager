#include "AddPlaylistDialog.h"
#include <QValidator>
#include <QDir>
#include <QDebug>

AddPlaylistDialog::AddPlaylistDialog(QWidget *parent) : QDialog(parent) {
	ui.setupUi(this);
	QValidator* valid = new QRegExpValidator(QRegExp("^[\\w-. ]{1,40}$"));
	ui.lineEdit->setValidator(valid);
}

AddPlaylistDialog::~AddPlaylistDialog(){
}

void AddPlaylistDialog::on_pushButton_clicked() {
	if (ui.lineEdit->hasAcceptableInput()) {
		QDir(QDir::currentPath() + "/Playlists").mkdir(ui.lineEdit->text());
		close();
	}
}