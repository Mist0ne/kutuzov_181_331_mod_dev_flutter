import 'package:encrypt/encrypt.dart' as Enc;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;


class SeventhLab extends StatefulWidget{
  @override
  _SeventhLabState createState() => _SeventhLabState();
}

class _SeventhLabState extends State<SeventhLab> {
  bool flag = true;
  String _enc;
  String _dec;

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/my_file.txt');
  }


  Future<String> main() async {
    final plainText = await loadAsset();//'Lorem ipsum dolor sit amet, consectetur adipiscing elit';
    final key = Enc.Key.fromUtf8('my 32 length key................');
    final iv = Enc.IV.fromLength(16);

    final encrypter = Enc.Encrypter(Enc.AES(key, iv));

    final encrypted = encrypter.encrypt(plainText);
    final decrypted = encrypter.decrypt(encrypted);

    _enc = encrypted.base64.toString();
    _dec = decrypted;


    print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
    print(encrypted.base64); // R4PxiU3h8YoIRqVowBXm36ZcCeNeZ4s1OvVBTfFlZRdmohQqOpPQqD1YecJeZMAop/hZ4OxqgC1WtwvX/hP9mw==
    return _enc;
  }

  Future<String> demain() async {
    final plainText = await loadAsset();//'Lorem ipsum dolor sit amet, consectetur adipiscing elit';
    final key = Enc.Key.fromUtf8('my 32 length key................');
    final iv = Enc.IV.fromLength(16);

    final encrypter = Enc.Encrypter(Enc.AES(key, iv));

    final encrypted = encrypter.encrypt(plainText);
    final decrypted = encrypter.decrypt(encrypted);

    _enc = encrypted.base64.toString();
    _dec = decrypted;


    print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
    print(encrypted.base64); // R4PxiU3h8YoIRqVowBXm36ZcCeNeZ4s1OvVBTfFlZRdmohQqOpPQqD1YecJeZMAop/hZ4OxqgC1WtwvX/hP9mw==
    return _dec;
  }

  @override
  Widget build(BuildContext context) {
    if(flag){
      return MaterialApp(
          home: Scaffold(
              appBar: AppBar(
                title: Text('Encryption'),
              ),
              body:
              Center(
                child:
                ListView( children: <Widget>[
                      RaisedButton(
                          child: Text("Decrypt"),
                          onPressed: () async {
                            String enc = await main();
                            setState(() {
                              _enc = enc;
                              flag = !flag;
                            });
                          }),

                          Text("Encrypted text:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                          Text("${_enc}"),
                    ]
                ),
              )
          )
      );
    }
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text('Encryption'),
            ),
            body:
            Center(
              child:
              ListView( children: <Widget>[
                    RaisedButton(
                        child: Text("Encrypt"),
                        onPressed: () async {
                          String dec = await demain();
                          setState(() {
                            _dec = dec;
                            flag = !flag;
                          });
                        }),
                      Text("Decrypted text:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                      Text("${_dec}"),
                    ],
              ),
            )
        )
    );
  }
}