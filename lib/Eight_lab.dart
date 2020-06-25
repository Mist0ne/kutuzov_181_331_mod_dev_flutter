import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';


class EightLab extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("SQL LAB"),
        ),
        body: PageView (
          children: <Widget> [
            Container (
              child: Friends(),
            ),
          ],
        ),
      ),
    );
  }

}


class Token{
  static String token_;
}


class Friend {
  final int id;
  final String firstName;
  final String lastName;
  final String photo;

  Friend({this.id, this.firstName, this.lastName, this.photo});

  Map<String, dynamic> toMap() {
    return {
      'IdFromVK': id,
      'name': firstName,
      'surname': lastName,
      'photo' : photo,
    };
  }
}


Future<http.Response> fetchFriends() async {
  String token = Token.token_;
  return await http.get('https://api.vk.com/method/friends.get?out=0&v=5.92&order=random&count=12&fields=photo_100&access_token=$token');
}


class Friends extends StatefulWidget{
  @override
  _FriendsState createState() => _FriendsState();
}


class _FriendsState extends State<Friends> {

  List<Friend> FriendsList = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: _buildList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () => _loadData(),
      ),
    );
  }


  _loadData() async {
    if (Token.token_ == null) {
      print("Token is null");
      return;
    }
    var response = await fetchFriends();
    var all_data = (json.decode(response.body) as Map)['response']['items'];

    final Database database = await openDatabase(
      join(await getDatabasesPath(), 'friends_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE friends(id INTEGER PRIMARY KEY, IdFromVK INTEGER, name TEXT, surname TEXT, photo TEXT)",
        );
      },
      version: 1,
    );
    database.execute("DELETE FROM friends");

    List<Friend> _FriendsList = [];
    all_data.forEach((val) {
      var record = Friend(
        id: val['id'],
        firstName: val['first_name'],
        lastName: val['last_name'],
        photo: val['photo_100'],
      );
      insertFriends(record);
      _FriendsList.add(record);
    });

    await GetFriends();
//    FriendsList.forEach((val){
//      print(val.firstName);
//    });
  }


  GetFriends() async {
    final Database db = await openDatabase(
      join(await getDatabasesPath(), 'friends_database.db'),
    );

    final List<Map<String, dynamic>> maps = await db.query('friends');

    List<Friend> _FriendsList = [];
    _FriendsList = List.generate(maps.length, (i) {
      return Friend(
        id: maps[i]['IdFromVK'],
        firstName: maps[i]['name'],
        lastName: maps[i]['surname'],
        photo: maps[i]['photo'],
      );
    }
    );

    setState(() {
      FriendsList = _FriendsList;
    });
  }


  Future<void> insertFriends(Friend friend) async {
    final Database db = await openDatabase(
      join(await getDatabasesPath(), 'friends_database.db'),
    );

    await db.insert(
      'friends',
      friend.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  List<Widget> _buildList() {
    return FriendsList.map((Friend f) =>
    ListTile(
      subtitle: Text(f.lastName),
      title: Text(f.firstName),
      leading: CircleAvatar(child: Image.network(f.photo,)),
      trailing: Text(f.id.toString()),
      )).toList();
  }


  @override void initState(){
    super.initState();
    GetFriends();
  }
}
