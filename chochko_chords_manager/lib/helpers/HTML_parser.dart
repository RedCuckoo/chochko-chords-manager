import 'package:flutter/cupertino.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class HTMLParser {

  void parseToFile(String fileLocation) async {
    var response = await http.Client().get(Uri.parse(
        "https://mychords.net/j_mad/129379-enya-mad-kacheli-ft-enya-mad.html"));

    if (response.statusCode != 200) {
      //TODO: throw exception?
      return null;
    }

    print("KUKU");

    var document = parse(response.body);
    var songTextDomElement = document.getElementsByClassName("w-words__text");//[0].text;
    String songText;
    if (songTextDomElement.length != 0){
      songText = songTextDomElement[0].text;

      File(fileLocation).writeAsString(songText);
      File(fileLocation).readAsString().then((onValue){print(onValue);});
    }

   // print(songText);
  }
}