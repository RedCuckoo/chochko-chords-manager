import 'dart:async';
import 'dart:io' as io;
import 'dart:io';

import 'package:chochkochordsmanager/helpers/HTML_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'MyHeartButton.dart';
import 'OfflineViewer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream<FileSystemEntity> _curFilesStream;
  var _curFiles = List<FileSystemEntity>();
  var directory;

  WebViewController controller;
  String currentUrl = "mychords.net/";
  final initialUrl = "https://mychords.net/";

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    initAsync();
    print("init");
  }

  void initAsync() async {
    directory = (await getApplicationDocumentsDirectory()).path;
    directory = directory + "/CCM_files/";

    checkConnection();

    print("initasync");

    await Directory(directory).create(recursive: true).then((Directory dir) {
      print("Created dir");
    });

    _curFilesStream = io.Directory(directory).list(recursive: false);

    print("updating drawer list");

    await for (FileSystemEntity entity in _curFilesStream) {
      // setState((){
      print("setting state");
      _curFiles.add(entity);
      // });
    }

    setState(() {});
  }

  Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('www.mychords.net');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("true");
        return true;
      }
    } on io.SocketException catch (_) {
      print("false");
      _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text("You are offline")));
      return false;
    }

    return true;
  }

  Widget _buildDrawerList() {
    var list = List<Widget>();
    list.add(Container(
        height: 65,
        child: DrawerHeader(
            child: Text(
              "Saved",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            decoration: BoxDecoration(
              color: Colors.purple,
            ))));

//TODO:_curFiles
    print("creating a list");
    for (var elem in _curFiles) {
      list.add(_buildRow(elem));
      list.add(Divider());
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
        if (await checkConnection() == true) {
          var url;
          await file.readAsString().then((onValue) {
            print("here");
            url = json.decode(onValue)['url'];
          });
          print(url);
          controller.loadUrl(url);
          Navigator.pop(context);
          print("connected");
          currentUrl = url;
        } else {
          String text;
          await file.readAsString().then((onValue) {
            print("here");
            text = json.decode(onValue)['text'];
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OfflineViewer(title, text)));
          print('not connected');
        }
      },
      trailing: MyHeartButton(_streamController),
    );
  }


  @override
  Widget build(BuildContext context) {
    print("build everything");
    Size size = MediaQuery.of(context).size;
    double webViewHeight = 1000;
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
                icon:Icon(Icons.refresh),
                onPressed:(){
                  controller.reload();
                }
              ),
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  setState(() {
                    controller.loadUrl(initialUrl);
                  });
                },
              )
            ],
          ),
          drawer: SizedBox(
              //width: size.width,
              child: Drawer(
            child: _buildDrawerList(),
          )),
          body: WebView(
            initialUrl: 'https://mychords.net/',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              this.controller = webViewController;
            },
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith('https://mychords.net/')) {
                currentUrl = request.url;
                print("accepted url");
                return NavigationDecision.navigate;
              } else {
                print("rejected url");
                return NavigationDecision.prevent;
              }
            },
            onPageStarted: (string) {
              SystemChannels.textInput.invokeMethod('TextInput.hide');
            },
            onPageFinished: (some) async {
              double height = double.parse(await controller.evaluateJavascript(
                  "document.documentElement.scrollHeight;"));
              setState(() {
                webViewHeight = height;
                print(webViewHeight);
              });
            },
            gestureNavigationEnabled: true,
          ),
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.favorite),
              //// Icon(Icons.favorite,color:Colors.white),
              backgroundColor: Colors.purple,
              onPressed: () {
                // var snackBar;
                if (currentUrl != null) {
                  print(directory);
                  HTMLParser.parseToFile(currentUrl, directory).then((onValue) {
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

                    print(snackBarMessage);
                    final snackBar = SnackBar(content: Text(snackBarMessage));
                    _scaffoldKey.currentState.hideCurrentSnackBar();
                    _scaffoldKey.currentState.showSnackBar(snackBar);
                  });
                }
              }),
        ));
  }

  Future<bool> _onBackButton() async {
    if (_scaffoldKey.currentState.isDrawerOpen) {
      Navigator.of(context).pop();
      return false;
    }

    var goBack = false;
    print("back button pushed");
    print(await controller.canGoBack());
    if (await controller.canGoBack() == true) {
      controller.goBack();
      return false;
    } else {
      print("can't go back");
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
      print(goBack);
      if (goBack) SystemNavigator.pop();
      return goBack;
    }
  }
}
