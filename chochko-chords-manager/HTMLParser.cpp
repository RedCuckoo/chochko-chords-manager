#include "HTMLParser.h"
#include <QDebug>
#include <QDir>
#include <QWebEnginePage>

HTMLParser::HTMLParser(QString toParse, QObject *parent) : QObject(parent), originalCode(toParse){
	expressionToParse.setMinimal(true);

	expressionToParse.indexIn(toParse, 0);
	strokeType = expressionToParse.cap(2);
	textWithChords = expressionToParse.cap(3);

	expressionToFixChords.setMinimal(true);
	textWithChords.replace(expressionToFixChords, "<a href=\"../\\1\">\\2</a>");


	parseAndDownload();

	textWithChords.replace(QRegExp("^"), "<html>\n<body>" + ((strokeType == "") ? ("Рекомендованный бой: " + strokeType + '\n') : "")); 
	textWithChords.replace(QRegExp("  "), "&nbsp;&nbsp;");
	textWithChords.replace(QRegExp("\n"), "\n<br>");
	textWithChords.append("</body>\n</html>");
}

HTMLParser::~HTMLParser()
{
}

QString HTMLParser::getText() {
	return textWithChords;
}

void HTMLParser::parseAndDownload() {
	expressionToDownloadChords.setMinimal(true);
	int lastPos = 0;
	while((lastPos = expressionToDownloadChords.indexIn(textWithChords, lastPos)) != -1){
		lastPos += expressionToDownloadChords.matchedLength();

		QString urlToDownload = "https://mychords.net/" + expressionToDownloadChords.cap(1);
		QString fileLocation = QDir::currentPath() + "/" + expressionToDownloadChords.cap(1);


		//download.setPath()

		QWebEnginePage toSave;
		toSave.setUrl(QUrl(urlToDownload));

		qDebug() << toSave.url();
		toSave.save(QDir::currentPath());
	}
}
