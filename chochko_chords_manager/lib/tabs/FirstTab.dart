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

class _FirstTabState extends State<FirstTab> with AutomaticKeepAliveClientMixin{
  Directory _curDir;
  List<Directory> _curFiles;
  int _curFilesAmount;
  Directory _folderDirectory;
  Directory _appDirectory;

  @override
  void initState(){
    initAsync();

    super.initState();
  }

  void initAsync() async{
    String _folderPath;
    widget._appPath.then((onValue){
      _appDirectory = Directory(onValue);
      _folderPath = onValue + "/CCM_files/";
      _folderDirectory= Directory(_folderPath);
      _curDir = _folderDirectory;

      _folderDirectory.create(recursive: true).then((Directory dir) {
        print(dir.path);
      });

      _updateCurFiles();
    });
  }

  double sideLength = 50;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: Colors.purple[50],
        body: Center(
          child: Container(
                    child: InkWell(
                      splashColor: Colors.deepPurple[400],
                      highlightColor: Colors.purple[100],
                      radius:50,
                      borderRadius: BorderRadius.circular(3.0),
                      onTap: (){
                      },
                      child:  GridView.count(
                        crossAxisCount: 2,
                        children: List.generate(5,(index){
                          return Column(
                          children: <Widget>[
                          Icon(
                            Icons.folder,
                            size: 160,
                            color: Colors.deepPurple[400],
                            ),
                            Text('folder',
                             textAlign: TextAlign.right,
                              )
                          ]
                        );
                        }),
                    )
                ),


            ),
        ),


        appBar: AppBar(
          title: Text('Playlists'),
          backgroundColor: Colors.deepPurple[400],
        ),
    );

  }

 void _updateCurFiles(){
    _curDir.list(recursive: false, followLinks: false).listen((FileSystemEntity entity) {
        print(entity.path);
        _curFiles.add(Directory(entity.path));
      });
  }

  @override
  bool get wantKeepAlive => true;

}