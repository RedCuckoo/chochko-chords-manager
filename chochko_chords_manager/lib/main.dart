import 'package:flutter/material.dart';
import 'package:chochkochordsmanager/home/Home.dart';

void main() {
  runApp(MaterialApp(title: "Chochko Chords Manager", home: MyHome()));
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home:SafeArea(child:Home()));
  }
}
