import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'color_helper.dart';
import 'dart:io' show Platform;

String selectedUrl = 'https://blinksarea.wixsite.com/blinkapp';
const kAndroidUserAgent = 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: HexColor("ff91ae")));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
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
          primarySwatch: Colors.pink, backgroundColor: HexColor("ff91ae")),
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

  String statusBarHeight = (Platform.isAndroid) ? "24.0px" : "0px";
  bool launched = false;

  @override
  void initState() {
    super.initState();

    flutterWebViewPlugin.close();

    _onStateChanged =
        flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
          if(state.type == WebViewState.startLoad){
            flutterWebViewPlugin.evalJavascript("""
              setTimeout(function() {
                /*var styleNode = document.createElement('style');
                styleNode.type = "text/css";
                var styleText = document.createTextNode('#SITE_HEADER{padding-top: $statusBarHeight !important; }');
                styleNode.appendChild(styleText);
                document.getElementsByTagName('head')[0].appendChild(styleNode);*/
                var script = document.createElement("script");
                script.src = "https://blinks.app/assets/blinksarea/custom.js?v=${DateTime.now()}";
                document.head.appendChild(script);
              }, 500);
            """);
          }

          if (state.type == WebViewState.finishLoad) {
            flutterWebViewPlugin.show();
          }
    });
  }

  Rect _buildRect(MediaQueryData mediaQuery) {
    final topPadding = mediaQuery.padding.top;
    final top = topPadding;
    var height = mediaQuery.size.height - top;

    if (height < 0.0) {
      height = 0.0;
    }

    return new Rect.fromLTWH(0.0, top, mediaQuery.size.width, height);
  }

  @override
  void dispose() {
    _onStateChanged.cancel();
    flutterWebViewPlugin.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    flutterWebViewPlugin.launch(selectedUrl,
        debuggingEnabled: true,
        hidden: true,
        rect: _buildRect(MediaQuery.of(context)),
      userAgent: kAndroidUserAgent,
      useWideViewPort: true,
      enableAppScheme: false,
        withLocalStorage: true
    );

    if ((Platform.isAndroid)) {
      setState(() {
        statusBarHeight = MediaQuery.of(context).padding.top.toString() + "px";
      });
    }

    return Scaffold(
      backgroundColor: HexColor("ff91ae"),
      body: Container(
          color: HexColor("ff91ae"),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 200.0,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Image.asset(
                        "assets/logo.jpg",
                        width: 50.0,
                      ),
                    ),
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
          )),
    );
  }
}
