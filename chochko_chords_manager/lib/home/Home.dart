import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as io;

import 'package:chochkochordsmanager/helpers/HTML_parser.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

import 'MyHeartButton.dart';
import 'OfflineViewer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _initialUrl = "https://mychords.net/";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var _curFiles = List<FileSystemEntity>();
  var _directory;

  WebViewController _controller;
  Stream<FileSystemEntity> _curFilesStream;
  String _currentUrl;

  @override
  void initState() {
    super.initState();

    _currentUrl = _initialUrl;

    _initAsync();
  }

  void _initAsync() async {
    _directory = (await getApplicationDocumentsDirectory()).path + "/CCM_files/";
    await Directory(_directory).create(recursive: true);
    _curFilesStream = io.Directory(_directory).list(recursive: false);
    await for (FileSystemEntity entity in _curFilesStream) {
      _curFiles.add(entity);
    }
    _checkConnection();
  }

  Future<bool> _checkConnection() async {
    try {
      final result = await InternetAddress.lookup('www.mychords.net');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on io.SocketException catch (_) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("You are offline")));
      return false;
    }
    return true;
  }

  Widget _buildDrawerList() {
    var list = List<Widget>();
    list.add(Container(
        height: 65,
        child: DrawerHeader(
            child: Text("Saved",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            decoration: BoxDecoration(
              color: Colors.purple,
            )
        )
    ));

    if (_curFiles.length == 0){
      list.add(Text("Nothing saved yet...", textAlign: TextAlign.center,style:TextStyle(fontSize: 16,fontStyle:FontStyle.italic, color: Colors.grey)));
    }
    else {
      for (var elem in _curFiles) {
        list.add(_buildRow(elem));
        list.add(Divider());
      }
    }

    return ListView(
      children: list,
    );
  }

  Widget _buildRow(File file) {
    var title = path.basenameWithoutExtension(file.path);

    StreamController<bool> _streamController = StreamController<bool>();
    _streamController.stream.listen((bool value) {
      if (value) {
        _curFiles.remove(file);
        setState(() {
          file.delete().then((value) {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Deleted successfully"),
            ));
          });
        });
      }
    });

    return ListTile(
      title: Text(title),
      onTap: () async {
        if (await _checkConnection() == true) {
          var url;
          await file.readAsString().then((onValue) {
            url = json.decode(onValue)['url'];
          });
          _controller.loadUrl(url);
          Navigator.pop(context);
          _currentUrl = url;
        } else {
          String text;
          await file.readAsString().then((onValue) {
            text = json.decode(onValue)['text'];
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OfflineViewer(title, text)));
        }
      },
      trailing: MyHeartButton(_streamController),
    );
  }

  Future<bool> _onBackButton() async {
    if (_scaffoldKey.currentState.isDrawerOpen) {
      Navigator.of(context).pop();
      return false;
    }

    var goBack = false;

    if (await _controller.canGoBack() == true) {
      _controller.goBack();
      return false;
    }
    else {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Close app"),
              content: Text("Are you sure you want to exit?"),
              actions: <Widget>[
                FlatButton(
                    child: Text("Yes",
                        style: TextStyle(
                          color: Colors.purple,
                        )),
                    onPressed: () {
                      goBack = true;
                      Navigator.of(context).pop(true);
                    }),
                FlatButton(
                  child: Text("No",
                      style: TextStyle(
                        color: Colors.purple,
                      )),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                )
              ],
            );
          });
      if (goBack) SystemNavigator.pop();
      return goBack;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackButton,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(
              "Chochko CM",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            backgroundColor: Colors.purple,
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    _controller.reload();
                  }),
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  setState(() {
                    _controller.loadUrl(_initialUrl);
                  });
                },
              )
            ],
          ),
          drawer: SizedBox(
              child: Drawer(
            child: _buildDrawerList(),
          )),
          body: WebView(
            initialUrl: _initialUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              this._controller = webViewController;
            },
            /*navigationDelegate: (NavigationRequest request) {
              /*if (request.url.startsWith('https://mychords.net/')) {
                currentUrl = request.url;
                print("accepted url");
                return NavigationDecision.navigate;
              } else {
                print("rejected url");
                return NavigationDecision.prevent;
              }*/
              currentUrl = request.url;
              return NavigationDecision.navigate;
            },*/
            onPageStarted: (string) {
              _checkConnection();
              _currentUrl = string;
              SystemChannels.textInput.invokeMethod('TextInput.hide');
            },
            gestureNavigationEnabled: true,
          ),
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.favorite),
              //// Icon(Icons.favorite,color:Colors.white),
              backgroundColor: Colors.purple,
              onPressed: () {
                if (_currentUrl != null) {
                  print(_directory);
                  HTMLParser.parseToFile(_currentUrl, _directory)
                      .then((onValue) {
                    String snackBarMessage;

                    switch (onValue.right) {
                      case (0):
                        snackBarMessage = "Unsuccessful loading";
                        break;
                      case (1):
                        snackBarMessage = "Successfully downloaded!";
                        setState(() {
                          _curFiles.add(onValue.left);
                        });
                        break;
                      case (2):
                        snackBarMessage = "Already saved";
                        break;
                      case (3):
                        snackBarMessage = "That's not a chords page";
                        break;
                    }

                    final snackBar = SnackBar(content: Text(snackBarMessage));
                    _scaffoldKey.currentState.hideCurrentSnackBar();
                    _scaffoldKey.currentState.showSnackBar(snackBar);
                  });
                }
              }),
        ));
  }
}
