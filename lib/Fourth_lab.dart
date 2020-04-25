import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';


class Fourth_lab extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PageView (
        children: <Widget> [
          Container (
            child: CCList(),
          ),
//          Container (
//            child: MaterialApp(
//              routes: {
//                "/": (_) => WebviewScaffold(
//                  url: "https://www.google.com",
//                  appBar: new AppBar(
//                    title: new Text("Widget webview"),
//                  ),
//                ),
//              },
//            ),
//          ),
        ],
      ),
    );
  }
}


class CCData{
  String name;
  String symbol;
  int rank;
  double price;

  CCData({this.name, this.symbol, this.rank, this.price});
}


class CCList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return CCListState();
  }

}

class CCListState extends State<CCList>{
  List<CCData> data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CryptoCoinTracker'),
      ),
      body: Container(
        child: ListView(
          children: _buildList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () => _loadCC(),
      ),
    );
  }

  _loadCC() async{
    final response = await http.get('https://api.coincap.io/v2/assets?limit=100');
    if (response.statusCode == 200){
      var allData = (json.decode(response.body) as Map)['data'];
      var ccDataList = List<CCData>();
      allData.forEach((val){
        var record = CCData(
            name: val['name'],
            symbol: val['symbol'],
            price: double.parse(val['priceUsd']),
            rank: int.parse(val['rank'])
        );
        ccDataList.add(record);
      });
      setState(() {
        data = ccDataList;
      });
    }
  }

  List<Widget> _buildList(){
    return data.map((CCData f) => ListTile(
      subtitle: Text(f.symbol),
      title: Text(f.name),
      leading: CircleAvatar(child: Text(f.rank.toString()),),
      trailing: Text('\$${f.price.toString()}'),
    )).toList();
  }

  @override
  void initState(){
    super.initState();
    _loadCC();
  }


}