import 'package:flutter/cupertino.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class HTMLParser {

  static Future<int> parseToFile(String url, String directoryLocation) async {
    if (url.endsWith(".html") == false)
      return 3;

    var response = await http.Client().get(Uri.parse(url));

    if (response.statusCode != 200) {
      //TODO: throw exception?
      return 0;
    }

    print("KUKU");

    var document = parse(response.body);
    var songTextDomElement = document.getElementsByClassName("w-words__text");//[0].text;
    var title = document.getElementsByTagName("title");
    var fileLocation = directoryLocation + title[0].text+".html";
    print(title[0].text);
    print(fileLocation);
    String songText;
    if (songTextDomElement.length != 0){
      songText = songTextDomElement[0].text;

      if (await File(fileLocation).exists() == true){
        return 2;
      }

      File(fileLocation).create();

      File(fileLocation).writeAsString(songText);
      //File(fileLocation).readAsString().then((onValue){print(onValue);});
    }
    return 1;
   // print(songText);
  }
}