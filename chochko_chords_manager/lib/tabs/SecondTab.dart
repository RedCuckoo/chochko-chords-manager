import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SecondTab extends StatefulWidget{
  @override
  _SecondTabState createState() => _SecondTabState();
}

class _SecondTabState extends State<SecondTab> with AutomaticKeepAliveClientMixin {
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: Colors.white30,
        body: WebView(
          initialUrl: "https://mychords.net/",
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request){
            if (request.url.startsWith('https://mychords.net/')){
              return NavigationDecision.navigate;
            }
            else{
              return NavigationDecision.prevent;
            }
          },
          gestureNavigationEnabled: true,
        )
    );
  }

  @override
  bool get wantKeepAlive => true;
}