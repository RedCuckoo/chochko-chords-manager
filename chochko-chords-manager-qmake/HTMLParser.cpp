#include "HTMLParser.h"
#include <QDebug>
#include <QWebEnginePage>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QUrl>
#include <QImageReader>
#include <QImage>
#include <QDir>
#include <QLabel>

HTMLParser::HTMLParser(QString toParse, QObject *parent) : QObject(parent), originalCode(toParse){
    expressionToParse.setMinimal(true);

    expressionToParse.indexIn(toParse, 0);
    strokeType = expressionToParse.cap(2);
    textWithChords = expressionToParse.cap(3);

    expressionToFixChords.setMinimal(true);
    textWithChords.replace(expressionToFixChords, "<a href=\"../../\\1\">\\2</a>");


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

        QNetworkAccessManager* manager = new QNetworkAccessManager();
        QNetworkReply* reply = manager->get(QNetworkRequest(QUrl(urlToDownload)));

        QEventLoop eventLoop;
        connect(reply, SIGNAL(finished()), &eventLoop, SLOT(quit()));
        eventLoop.exec();

        QImage img;
        if (reply->error() == QNetworkReply::NoError) {
            QImageReader imageReader(reply);
            img = imageReader.read();

            if (!img.isNull())
                img.save(fileLocation);
        }
    }
}
