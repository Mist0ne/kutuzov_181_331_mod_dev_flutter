import 'package:flutter/material.dart';
import 'package:kutuzovva_181_331_mob_dev/First_lab.dart';
import 'package:kutuzovva_181_331_mob_dev/Second_lab.dart';
import 'package:kutuzovva_181_331_mob_dev/Third_lab.dart';
import 'package:kutuzovva_181_331_mob_dev/Fourth_lab.dart';
import 'package:kutuzovva_181_331_mob_dev/Fifth_lab.dart';

import 'package:flutter/cupertino.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Главное окно')),
      body: Center(child: Column(children: [
        RaisedButton(onPressed: (){Navigator.pushNamed(context, '/first_lab');}, child: Text('Первая лаба')),
        RaisedButton(onPressed: (){Navigator.pushNamed(context, '/second_lab');}, child: Text('Вторая лаба')),
        RaisedButton(onPressed: (){Navigator.pushNamed(context, '/third_lab');}, child: Text('Третья лаба')),
        RaisedButton(onPressed: (){Navigator.pushNamed(context, '/fourth_lab');}, child: Text('Четвертая лаба')),
        RaisedButton(onPressed: (){Navigator.pushNamed(context, '/fifth_lab');}, child: Text('Пятая лаба')),
      ],)),
    );
  }
}

void main(){
  // Fetch the available cameras before initializing the app.
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/':(BuildContext context) => MainScreen(),
      '/first_lab':(BuildContext context) => FirstLab(),
      '/second_lab':(BuildContext context) => VideoPlayerApp(),
      '/third_lab':(BuildContext context) => Third_lab(),
      '/fourth_lab':(BuildContext context) => Fourth_lab(),
      '/fifth_lab':(BuildContext context) => FifthLab(),
    },
  ));
}