import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'color_helper.dart';

String selectedUrl = 'https://blinksarea.wixsite.com/blinkapp';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) {
    runApp(new BlinksArea());
  });
}

class BlinksArea extends StatelessWidget {
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BlinksArea',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        backgroundColor: HexColor("ff91ae")
      ),
      routes: {
        '/': (_) => BlinksAreaWebView(),
      },
    );
  }
}

class BlinksAreaWebView extends StatefulWidget {
  @override
  _BlinksAreaWebViewState createState() => _BlinksAreaWebViewState();
}

class _BlinksAreaWebViewState extends State<BlinksAreaWebView> {

  final flutterWebViewPlugin = FlutterWebviewPlugin();
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  String statusBarHeight = "24.0px";

  @override
  void initState() {
    super.initState();

    flutterWebViewPlugin.close();

    _onStateChanged =
        flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
          if (state.type == WebViewState.finishLoad) {
            flutterWebViewPlugin.evalJavascript("""
              setTimeout(function() {
                var styleNode = document.createElement('style');
                styleNode.type = "text/css";
                var styleText = document.createTextNode('#SITE_HEADER{padding-top: $statusBarHeight !important; }');
                styleNode.appendChild(styleText);
                document.getElementsByTagName('head')[0].appendChild(styleNode);
                var script = document.createElement("script");
                script.src = "https://blinks.app/assets/blinksarea/custom.js?v=${DateTime.now()}";
                document.head.appendChild(script);
              }, 500);
            """);
            flutterWebViewPlugin.show();
          }
        });
  }

  @override
  void dispose() {
    _onStateChanged.cancel();
    flutterWebViewPlugin.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    flutterWebViewPlugin.launch(selectedUrl, debuggingEnabled: true, hidden: true);

    setState(() {
      statusBarHeight = MediaQuery.of(context).padding.top.toString() + "px";
    });

    return Scaffold(
      backgroundColor: HexColor("f8a4bb"),
      body: Container(
        color: HexColor("f8a4bb"),
        height: MediaQuery.of(context).size.height,
        width:  MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 200.0,
                child: Stack(
                  children: <Widget>[
                    Center(child: Image.asset("assets/logo.jpg", width: 50.0,),),
                    Center(
                      child: Container(
                        width: 50,
                        height: 50,
                        child: new CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }
}
