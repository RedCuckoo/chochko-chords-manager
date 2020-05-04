import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OfflineViewer extends StatelessWidget{
  final text;

  OfflineViewer(this.text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(child:Text(text))

    );
  }

}