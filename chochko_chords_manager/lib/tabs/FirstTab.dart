import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class FirstTab  extends StatefulWidget{
  Future<String> get _appPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  _FirstTabState createState() => _FirstTabState();
}

class _FirstTabState extends State<FirstTab>{
  final items = new List<Directory>();

  @override
  void initState() async{
    String _folderPath;
    Directory _folderDirectory;
    widget._appPath.then((onValue){
      _folderPath = onValue + "/CCM_files/";
      _folderDirectory= Directory(_folderPath);
    });

    _folderDirectory.create(recursive: true).then((Directory dir) {
      print(dir.path);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple[50],
        body: Center(
          child: GridView.count(
            crossAxisCount: 2,
            children: List.generate(100, (index){
              return Center(
                child:Text(
                  'Item $index',
                  style: Theme.of(context).textTheme.headline,
                ),
              );
            }),
          ),
        )
    );
  }

}