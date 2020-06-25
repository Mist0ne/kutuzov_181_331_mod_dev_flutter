import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kutuzovva_181_331_mob_dev/Fifth_lab_UnusedFacebook.dart';


class TestClass extends StatefulWidget {
  @override
  _TestClassState createState() => _TestClassState();
}

class _TestClassState extends State<TestClass> {
  @override
  Widget build(BuildContext context) {
    if (CURL.token == null) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("Facebook Friends"),
          ),
          body: Text("Вы не авторизованы, зайдите в 5 лабу и авторизуйтесь"),
        ),
      );
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Facebook Friends"),
        ),
        body: RaisedButton(
        child: Text("Show json"),
          onPressed: () async {
          CURL test = new CURL();
          await test.postRequest();
          }
        )
      ),
    );
  }
}


class CURL{
  static Token token;
  static String profile_id;
  List _response;


  void postRequest() async {
    String url = "https://graph.facebook.com/v7.0/${profile_id}/friends?access_token=${CURL.token.access.toString()}";


    var response = await http.get(
      url,
    );

    // todo - handle non-200 status code, etc
    print(json.decode(response.body));
    print(url);
    print(profile_id);
    print(json.decode(response.body));
    //_response = json.decode(response.body)['data'];
    //_response.forEach((value) {print(value);});
  }
}