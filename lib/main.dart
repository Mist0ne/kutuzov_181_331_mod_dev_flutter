import 'package:flutter/material.dart';
import 'package:app_4_test/First_lab.dart';
import 'package:app_4_test/Second_lab.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Главное окно')),
      body: Center(child: Column(children: [
        RaisedButton(onPressed: (){Navigator.pushNamed(context, '/first_lab');}, child: Text('Первая лаба')),
        RaisedButton(onPressed: (){Navigator.pushNamed(context, '/second_lab');}, child: Text('Вторая лаба')),
      ],)),
    );
  }
}

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/':(BuildContext context) => MainScreen(),
      '/first_lab':(BuildContext context) => FirstLab(),
      '/second_lab':(BuildContext context) => Second_lab()
    },
  ));
}