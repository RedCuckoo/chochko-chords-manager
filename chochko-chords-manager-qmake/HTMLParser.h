#ifndef HTMLPARSER_H
#define HTMLPARSER_H

#include <QObject>

class HTMLParser : public QObject{
    Q_OBJECT

public:
    HTMLParser(QString toParse, QObject *parent);
    ~HTMLParser();
    QString getText();
private:
    /*capturing groups
        1 - trash
        2 - stroke
        3 - text
    */
    QRegExp expressionToParse = QRegExp("<div class=\"b-words__text\".*<pre class=\"w-words__text\" itemprop=\"text\">(.*<a href=.*>(.*)?\\(.*<\\/a><\\/div>)?(.*)<\\/pre>");
    QRegExp expressionToFixChords = QRegExp("<span.*'\\/(.*)\\?ch201.*>\">(.*)<\\/a><\\/span>");
    QRegExp expressionToDownloadChords = QRegExp("<a href=\"..\\/..\\/([^\"]+.png)");
    QString originalCode;
    QString strokeType;
    QString textWithChords;

    void parseAndDownload();
};

#endif // HTMLPARSER_H
