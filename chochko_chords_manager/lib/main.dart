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
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 2, initialIndex: 1);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SafeArea(child: Home()));
    /* Scaffold(
      drawer: Drawer(child: FirstTab()),
      appBar: AppBar(
        title: Text("Chochko Chords Manager", textAlign: TextAlign.center,),
        backgroundColor: Colors.purple,
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: (){
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ),
    );*/
  }
}
