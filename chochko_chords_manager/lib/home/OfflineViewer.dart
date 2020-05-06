import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OfflineViewer extends StatelessWidget{
  final text;

  OfflineViewer(this.text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO: add title
      appBar: AppBar(),
      body: SingleChildScrollView(child:SelectableText(text), padding:EdgeInsets.only(left:20, right:20, top:20, bottom: 20))

    );
  }

}