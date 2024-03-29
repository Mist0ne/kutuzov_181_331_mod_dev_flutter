import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kutuzovva_181_331_mob_dev/Sixth_lab.dart';


import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<Stream<String>> _server() async {
  final StreamController<String> onCode = StreamController();
  HttpServer server =
  await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080);
  server.listen((HttpRequest request) async {
    final String code = request.uri.queryParameters["code"];
    request.response
      ..statusCode = 200
      ..headers.set("Content-Type", ContentType.HTML.mimeType)
      ..write("<html><h1>You can now close this window</h1></html>");
    await request.response.close();
    await server.close(force: true);
    onCode.add(code);
    await onCode.close();
  });
  return onCode.stream;
}

Future<Token> getToken(String appId, String appSecret) async {
  Stream<String> onCode = await _server();
  String url =
      "https://www.facebook.com/dialog/oauth?client_id=$appId&redirect_uri=http://localhost:8080/&scope=public_profile";
  _launchURL(url);
  final String code = await onCode.first;
  final http.Response response = await http.get(
      "https://graph.facebook.com/v2.2/oauth/access_token?client_id=$appId&redirect_uri=http://localhost:8080/&client_secret=$appSecret&code=$code");
  return new Token.fromMap(json.decode(response.body));
}
class Token {
  final String access;
  final String type;
  final num expiresIn;

  Token(this.access, this.type, this.expiresIn);

  Token.fromMap(Map<String, dynamic> json)
      : access = json['access_token'],
        type = json['token_type'],
        expiresIn = json['expires_in'];
}

class Id {
  final String id;

  Id(this.id);
}

class Cover {
  final String id;
  final int offsetY;
  final String source;

  Cover(this.id, this.offsetY, this.source);

  Cover.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        offsetY = json['offset_y'],
        source = json['source'];
}

class PublicProfile extends Id {
  final Cover cover;
  final String name;

  PublicProfile.fromMap(Map<String, dynamic> json)
      : cover =
  json.containsKey('cover') ? new Cover.fromMap(json['cover']) : null,
        name = json['name'],
        super(json['id']);
}

class FacebookGraph {
  final String _baseGraphUrl = "https://graph.facebook.com/v2.8/";
  final Token token;

  FacebookGraph(this.token);

  Future<PublicProfile> me(List<String> fields) async {
    String _fields = fields.join(",");
    final http.Response response = await http
        .get("$_baseGraphUrl/me?fields=$_fields&access_token=${token.access}");
    return PublicProfile.fromMap(json.decode(response.body));
  }
}


const String appId = "839610913196394";
const String appSecret = "19bc1e5f7ef877c611c46be2625f9b99";


class FifthLab extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MyApp();
  }
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Token token;
  FacebookGraph graph;
  PublicProfile profile;

  @override
  Widget build(BuildContext context) {
    if (token == null) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("Facebook OAuthv2.0"),
          ),
          body: Center(
            child: RaisedButton(
              child: Text("Login with Facebook"),
              onPressed: () async {
                final Token _token = await getToken(appId, appSecret);
                FacebookGraph _graph = FacebookGraph(_token);
                PublicProfile _profile = await _graph.me(["name"]);
                setState(() {
                  token = _token;
                  CURL.token = _token;
                  graph = _graph;
                  profile = _profile;
                  CURL.profile_id = _profile.id;
                });
              },
            ),
          ),
        ),
      );
    }


    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Facebook Registration'),
          ),
          body: Text("Hello ${profile.name}"),
        )
    );
  }
}