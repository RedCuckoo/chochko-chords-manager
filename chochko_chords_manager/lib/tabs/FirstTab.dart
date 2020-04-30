import 'package:chochkochordsmanager/helpers/HTML_parser.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:io' as io;
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class FirstTab  extends StatefulWidget{
  final TabController controller;

  FirstTab(this.controller);

  @override
  _FirstTabState createState() => _FirstTabState();
}

class _FirstTabState extends State<FirstTab>{
  var _curFiles = new List<FileSystemEntity>();

  @override
  void initState(){
    super.initState();
    initAsync();
    print("init");
  }

  void initAsync() async{
    var directory = (await getApplicationDocumentsDirectory()).path;
    directory = directory + "/CCM_files/";
    Directory(directory).create(recursive: true).then((Directory dir) {
      print(dir.path);
    });

    setState(() {
      //TODO: remake for asynchronous list
      _curFiles = io.Directory(directory).listSync();
    });
  }

  double sideLength = 50;

  @override
  Widget build(BuildContext context) {
    print("build");
    return Scaffold(
       appBar: AppBar(
         title: Text("Saved"),
         backgroundColor: Colors.deepPurple[400],
       ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _buildList(),
          )
        ],
      ),
    );

  }
  var _iconType = 1;
  Widget _buildRow(File file){
    return ListTile(
      title: Text(path.basenameWithoutExtension(file.path)),
      onTap: (){
        widget.controller.animateTo(1);
      },
      trailing: IconButton(
        icon: Icon((_iconType == 0)? Icons.favorite_border : Icons.favorite),
        color: Colors.red,
        onPressed: (){
          setState((){
            _iconType = (_iconType == 0) ? 1 : 0;
          });
        },
      )

    );
  }

  Widget _buildList(){
    var list = new List<Widget>();
    for (var elem in _curFiles){
      list.add(_buildRow(elem));
    }

    return ListView(
        children: list,
    );
  }

}