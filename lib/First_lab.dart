// URL на скриншот настроек телеграмма (с которого копировалс дизайн):
// https://sun1-21.userapi.com/TQt5rNrrWyN434gFq4bpVzKYKJRr30ANqUAfcQ/v_REm9OhDUI.jpg


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class FirstLab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FirstLabState();
  }
}

class FirstLabState extends State<FirstLab> {

  bool _value1 = false;
  bool _value2 = false;
  bool _value3 = false;

  bool _SwitchValue1 = false;

  void _value1Changed(bool value) => setState(() => _value1 = value);
  void _value2Changed(bool value) => setState(() => _value2 = value);
  void _value3Changed(bool value) => setState(() => _value3 = value);

  void _onChanged1(bool value) {
    _SwitchValue1 = value;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/tg.png', width: 40, height: 40,),
            Spacer(),
            Column(
              children: [
                Text('Основы разработки приложений Qt QML.', style: TextStyle(fontSize: 13.0)),
                Text('Элементы графического интерфейса', style: TextStyle(fontSize: 13.0))
              ],
            ),
          ],
        ),
        backgroundColor: Color(0xff4680C2),
      ),
      body: Container(
        color: Colors.white10,
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 4),
              Text('Когда будет пара?',
                  style: TextStyle(
                    fontSize: 19.0,
                    color: Color(0xff0088cc),
                    fontWeight: FontWeight.w500,
                  )
              ),
              CheckboxListTile(
                value: _value1,
                onChanged: _value1Changed,
                title: Text('ПН'),
                subtitle: Text('Желательно, после физры'),
                activeColor: Colors.blue,
              ),
              CheckboxListTile(
                value: _value2,
                onChanged: _value2Changed,
                title: Text('СР'),
                subtitle: Text('Ехать в выходной на пары'),
                activeColor: Colors.blue,
              ),
              CheckboxListTile(
                value: _value3,
                onChanged: _value3Changed,
                title: Text('ЧТ'),
                subtitle: Text('Самое удобное, перед парами'),
                activeColor: Colors.blue,
              ),
              Divider(),
              SizedBox(height: 10),
              Divider(),
              Text('Есть предложение? Пиши!',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Color(0xff0088cc),
                      fontWeight: FontWeight.w500
                  )),
              TextField(
                decoration: InputDecoration(
                    hintText: 'Свой вариант'
                ),
              ),
              Divider(),
              SizedBox(height: 10),
              Divider(),
              SwitchListTile(
                value: _SwitchValue1,
                onChanged: _onChanged1,
                title: Text('Прогулять пару'),
              ),
              Divider(),
              Spacer(),
              LinearProgressIndicator(
                //ToDo Rewrite this segment
              ),
              Row(
                  children: <Widget>[
                    FlatButton(onPressed: () async {
                      const url = 'https://vk.com/lowpolykek';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                      child:
                      Text('Клацай на мемас'),
                      color: Colors.white10,
                      textColor: Colors.blue,
                    ),
                    Spacer(),
                    FlatButton(onPressed: ()=> exit(0),
                      child:
                      Text('Выйти'),
                      color: Colors.white10,
                      textColor: Colors.red,
                    ),
                  ]
              )
            ],
          ),
        ),
      ),
    );
  }
}