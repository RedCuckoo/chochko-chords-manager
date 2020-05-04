import 'package:flutter/cupertino.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class HTMLParser {
  static Future<int> parseToFile(String url, String directoryLocation) async {
    print(url);
    if (url.endsWith(".html") == false){
      print(url);
      return 3;
    }

    var response = await http.Client().get(Uri.parse(url));

    if (response.statusCode != 200) {
      //TODO: throw exception?
      return 0;
    }

    var document = parse(response.body);

    var songTextDomElement = document.getElementsByClassName("w-words__text");//[0].text;
    var title = document.getElementsByTagName("title");
    var fileLocation = directoryLocation + title[0].text+".json";

    print(title[0].text);
    print(fileLocation);

    String songText;
    if (songTextDomElement.length != 0){
      songText = songTextDomElement[0].text;

      if (await File(fileLocation).exists() == true){
        return 2;
      }
      
      File(fileLocation).create();
      File(fileLocation).writeAsString(
        json.encode({
          'url': url,
          'text': songText}
        )
      );
    }
    else{
      return 0;
    }

    return 1;
  }



}