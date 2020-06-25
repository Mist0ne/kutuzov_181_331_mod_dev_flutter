import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'Eight_lab.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  String token;

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.close();

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      print("destroy");
    });

    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
          print("onStateChanged: ${state.type} ${state.url}");
        });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          print("URL changed: $url");
          if (url.contains('https://oauth.vk.com/blank.html#access_token=')) {

            var first = url.toString().split("access_token=");
            var _final = first[1].split("&");

            Token.token_ = _final[0];
            Navigator.of(context).pushNamedAndRemoveUntil(
                "/", (Route<dynamic> route) => false);
            flutterWebviewPlugin.close();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String AppId = '7520005';
    String RedirectUrl = 'https://oauth.vk.com/blank.html';
    String loginUrl = "https://oauth.vk.com/authorize?client_id=$AppId&display=page&redirect_uri=$RedirectUrl&scope=friends&response_type=token&v=5.110&state=123456";

    return new WebviewScaffold(
        url: loginUrl,
        appBar: new AppBar(
          title: new Text("Login to someservise..."),
        ));
  }
}
