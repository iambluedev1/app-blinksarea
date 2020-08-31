import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'color_helper.dart';

String selectedUrl = 'https://blinksarea.wixsite.com/blinkapp';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(BlinksArea());
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
              var styleNode = document.createElement('style');
              styleNode.type = "text/css";
              var styleText = document.createTextNode('#c1dmpinlineContent-gridContainer{margin-top: 0px!important} #comp-kef0558m{left: 0!important;justify-self: normal!important;align-self: normal!important;} #SITE_ROOT{ top: 0 !important} #SITE_HEADER{ margin-top:0!important } body{ background-color:#e8e6e7!important } #TPASection_keexdggh{left:0!important} #mafl5inlineContent{width: 100%!important} #c1dmpinlineContent-gridWrapper{padding: 20px;} #SITE_HEADER{ padding-top: $statusBarHeight !important; } #MENU_AS_CONTAINERoverlay > div{left:0!important;} #c1dmp > div {left:0!important; right:0!important} body.device-mobile-optimized #SITE_CONTAINER {width: 100%!important;}.style-keev1rnv[data-state~="mobileView"] .style-keev1rnvbg {left:0!important; right:0!important;}#QUICK_ACTION_BAR{left:0!important}');
              styleNode.appendChild(styleText);
              document.getElementsByTagName('head')[0].appendChild(styleNode);
              document.getElementById("comp-keewrxoq").remove()
              document.getElementById("WIX_ADS").remove()
              document.getElementsByTagName("style").forEach((node) => {node.innerHTML = node.innerHTML.replace("320px", "100%").replace("319px", "100%").replace("260px", "100%");})
              document.querySelectorAll("[style]").forEach((node) => node.attributes["style"].value = node.attributes["style"].value.replace("320px", "100%").replace("319px", "100%").replace("260px", "100%"));
              
              var targetNode = document.getElementById('MENU_AS_CONTAINERoverlay');
              var callback = function(mutationsList) {
                  document.getElementById("MENU_AS_CONTAINERoverlay").style.left = 0;
                  document.getElementById("MENU_AS_CONTAINERoverlay").style.width = "100%";
              };
              var observer = new MutationObserver(callback);
              observer.observe(targetNode, { attributes: true, childList: true });
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
