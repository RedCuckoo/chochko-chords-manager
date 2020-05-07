import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OfflineViewer extends StatelessWidget{
  final title;
  final text;

  OfflineViewer(this.title, this.text);

  @override
  Widget build(BuildContext context) {
    print(title);
    return Scaffold(
      //TODO: add title
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(title),
      ),
      body: SingleChildScrollView(child:SelectableText(text), padding:EdgeInsets.only(left:20, right:20, top:20, bottom: 20))

    );
  }

}