import 'package:flutter/cupertino.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class HTMLParser {
  static Future<Pair> parseToFile(String url, String directoryLocation) async {
    print(url);
    if (url.endsWith(".html") == false){
      print(url);
      return Pair(null, 3);
    }

    var response = await http.Client().get(Uri.parse(url));

    if (response.statusCode != 200) {
      //TODO: throw exception?
      return Pair(null, 0);
    }

    var document = parse(response.body);

    var songTextDomElement = document.getElementsByClassName("w-words__text");//[0].text;
    var title = document.getElementsByClassName("b-title");
    print(title.length);
    var modifiedTitle = title[0].text.replaceAll(RegExp(r"^\s+"), "");
    print(modifiedTitle);

    var fileLocation = directoryLocation + modifiedTitle+".json";

    var file = File(fileLocation);
    print(fileLocation);

    String songText;
    if (songTextDomElement.length != 0){
      songText = songTextDomElement[0].text;

      if (await file.exists() == true){
        return Pair(null, 2);
      }

      file.create();

      file.writeAsString(
        json.encode({
          'url': url,
          'text': "Материал взято из сайта https://mychords.net\n\n" + songText,
        }
        )
      );
    }
    else{
      return Pair(null, 0);
    }

    return Pair(file, 1);
  }
}


class Pair {
  final dynamic left;
  final dynamic right;

  Pair(this.left, this.right);

  @override
  String toString() => 'Pair[$left, $right]';
}