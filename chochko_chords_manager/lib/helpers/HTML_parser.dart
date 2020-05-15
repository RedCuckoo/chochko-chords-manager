import 'dart:io';
import 'dart:convert';

import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class HTMLParser {
  static Future<Pair> parseToFile(String url, String directoryLocation) async {
    if (url.endsWith(".html") == false){
      return Pair(null, 3);
    }

    var response = await http.Client().get(Uri.parse(url));

    if (response.statusCode != 200) {
      return Pair(null, 0);
    }

    var document = parse(response.body);
    var songTextDomElement = document.getElementsByClassName("w-words__text");
    var title = document.getElementsByClassName("b-title");
    var modifiedTitle = title[0].text.replaceAll(RegExp(r"^\s+"), "");
    var fileLocation = directoryLocation + modifiedTitle+".json";
    var file = File(fileLocation);
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
          'text': "Material is taken from the website https://mychords.net\n\n" + songText,
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