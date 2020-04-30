import 'dart:wasm';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:chochkochordsmanager/helpers/HTML_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SecondTab extends StatefulWidget{
  final TabController controller;

  SecondTab(this.controller);

  @override
  _SecondTabState createState() => _SecondTabState();
}

class _SecondTabState extends State<SecondTab> with AutomaticKeepAliveClientMixin {
  String saveDirectory;

  @override
  void initState(){
    super.initState();
    initAsync();
  }

  void initAsync() async{
    var directory = (await getApplicationDocumentsDirectory()).path;
    directory = directory + "/CCM_files/";

    setState(() {
      //TODO: remake for asynchronous list
      saveDirectory = directory;
      print("finally");
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    String currentUrl = "https://mychords.net/";
    return Scaffold(
        backgroundColor: Colors.white30,
        body: WebView(
          initialUrl: "https://mychords.net/",
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request){
            if (request.url.startsWith('https://mychords.net/')){
              currentUrl = request.url;
              return NavigationDecision.navigate;
            }
            else{
              return NavigationDecision.prevent;
            }
          },
          gestureNavigationEnabled: true,
        ),
        floatingActionButton: FloatingActionButton(
          child:Icon(Icons.favorite,color:Colors.white),
          backgroundColor: Colors.purple,
          onPressed: (){
            if (currentUrl != null) {
              print(saveDirectory);
              HTMLParser.parseToFile(currentUrl, saveDirectory).then((onValue){
                String snackBarMessage;
               switch(onValue){
                 case(0):{
                    snackBarMessage = "Unsuccessful loading";
                    break;
                 }
                 case (1):
                   snackBarMessage = "Successfully downloaded!";
                   break;
                 case(2):
                   snackBarMessage = "Already saved";
                   break;
                 case (3):
                   snackBarMessage = "That's not a chords page";
                   break;
                }

                final snackBar = SnackBar(content: Text(snackBarMessage));
                Scaffold.of(context).showSnackBar(snackBar);
              });
            }
          },
        ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}