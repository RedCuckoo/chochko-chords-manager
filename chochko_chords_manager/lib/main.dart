import 'package:flutter/material.dart';
import 'package:chochkochordsmanager/tabs/FirstTab.dart';
import 'package:chochkochordsmanager/tabs/SecondTab.dart';
import 'package:path_provider/path_provider.dart';

void main(){
  runApp(MaterialApp(
    title: "Chochko Chords Manager",
    home: MyHome()
  ));
}

class MyHome extends StatefulWidget{
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> with SingleTickerProviderStateMixin{
  TabController controller;

  @override
  void initState(){
    super.initState();
    controller = TabController(vsync: this, length: 2, initialIndex: 1);
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chochko Chords Manager"),
        backgroundColor: Colors.purple,
      ),
      body: TabBarView(
        children: <Widget>[FirstTab(controller),SecondTab(controller)],
        controller: controller,
      ),
      bottomNavigationBar: Material(
        color: Colors.purple,
        child: TabBar(
          tabs:<Tab>[
            Tab(
              icon: Icon(Icons.favorite),
            ),
            Tab(
              icon:Icon(Icons.audiotrack),
            )
          ],
          controller: controller,
          indicatorColor: Colors.white,
        ),
      ),
    );
  }
}