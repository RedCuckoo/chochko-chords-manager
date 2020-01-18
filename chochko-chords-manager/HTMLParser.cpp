#include "HTMLParser.h"
#include <QDebug>

HTMLParser::HTMLParser(QString toParse, QObject *parent) : QObject(parent), originalCode(toParse){
	expressionToParse.setMinimal(true);

	expressionToParse.indexIn(toParse, 0);
	strokeType = expressionToParse.cap(2);
	textWithChords = expressionToParse.cap(3);

	expressionToFixChords.setMinimal(true);

	
	//expressionToFixChords.indexIn()



	textWithChords.replace(expressionToFixChords, "<a href=\"\\1\">\\2</a>");
	
	textWithChords.replace(QRegExp("^"), "<html>\n<body>" + ((strokeType == "") ? ("Рекомендованный бой: " + strokeType + '\n') : "")); 
	textWithChords.replace(QRegExp("$"), "</body>\n</html>");
	textWithChords.replace(QRegExp("\n"), "<br>");

}

HTMLParser::~HTMLParser()
{
}

QString HTMLParser::getText() {
	return textWithChords;
}

