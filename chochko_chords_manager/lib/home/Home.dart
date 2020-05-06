import 'dart:async';
import 'dart:io' as io;
import 'dart:io';

import 'package:chochkochordsmanager/helpers/HTML_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'OfflineViewer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _curFiles = new List<FileSystemEntity>();
  var directory;
  var tempDirectory;
  WebViewController controller;
  String currentUrl = "mychords.net/";
  final initialUrl = "www.mychords.net/";

  @override
  void initState() {
    super.initState();
    initAsync();
    print("init");
  }

  void initAsync() async {
    directory = (await getApplicationDocumentsDirectory()).path;
    directory = directory + "/CCM_files/";

    tempDirectory = (await getTemporaryDirectory()).path;
    print(tempDirectory);

    await checkConnection();

    Directory(directory).create(recursive: true).then((Directory dir) {
      print(dir.path);
    });

    updateDrawerList();
  }

  void updateDrawerList() {
    setState(() {
      //TODO: remake for asynchronous list
      _curFiles = io.Directory(directory).listSync();
    });
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
      return false;
    }

    return true;
  }

  Widget _buildRow(File file) {
    return ListTile(
        title: Text(path.basenameWithoutExtension(file.path)),
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
          } else {
            String text;
            await file.readAsString().then((onValue) {
              print("here");
              text = json.decode(onValue)['text'];
            });
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => OfflineViewer(text)));
            print('not connected');
          }
        },
        trailing: IconButton(
          icon: Icon(Icons.favorite),
          color: Colors.red,
          onPressed: () {
            // showDialog(context: context);
          },
        ));
  }

  Widget _buildDrawerList() {
    var list = new List<Widget>();
    list.add(DrawerHeader(
        child: Text("Saved"),
        decoration: BoxDecoration(
          color: Colors.purple,
        )));
    for (var elem in _curFiles) {
      list.add(_buildRow(elem));
    }

    return ListView(
      children: list,
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Chochko Chords Manager",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.purple,
      ),
      drawer: SizedBox(
          width: size.width,
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
          onPageStarted: (string){
            SystemChannels.textInput.invokeMethod('TextInput.hide');
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
                switch (onValue) {
                  case (0):
                    snackBarMessage = "Unsuccessful loading";
                    break;
                  case (1):
                    snackBarMessage = "Successfully downloaded!";
                    updateDrawerList();
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
    );
  }
}
