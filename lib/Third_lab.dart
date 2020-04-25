import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import 'package:path/path.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;
import 'package:image_picker/image_picker.dart';

class BlurMultipleDynamicRegionPage extends StatefulWidget {
  BlurMultipleDynamicRegionPage({Key key}) : super(key: key);

  @override
  _BlurMultipleDynamicRegionPageState createState() =>
      _BlurMultipleDynamicRegionPageState();
}

class _BlurMultipleDynamicRegionPageState
    extends State<BlurMultipleDynamicRegionPage> {
  final double _width = 350;
  final double _height = 300;
  double _sigmaX = 0.0;
  double _sigmaY = 0.0;
  double _opacity = 0.0;
  double _blurWidth;
  double _blurHeight;

  _BlurMultipleDynamicRegionPageState() {
    _blurWidth = _width;
    _blurHeight = _height;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blur multiple widgets with dynamic region'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            _buildImageContainer(),
            SizedBox(height: 5),
            _buildBlurContainerSizeAction(),
            SizedBox(height: 5),
            ..._buildBlurSigmaAndOpacity(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContainer() {
    return Stack(
      children: <Widget>[
        Image.asset(
          'assets/tg.png',
          width: _width,
          height: _height,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 0,
          left: 0,
          width: _blurWidth,
          height: _blurHeight,
          // Note: without ClipRect, the blur region will be expanded to full
          // size of the Image instead of custom size
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
              child: Container(
                color: Colors.black.withOpacity(_opacity),
              ),
            ),
          ),
        )
      ],
    );
  }

  List<Widget> _buildBlurSigmaAndOpacity() {
    return [
      Text('Change blur sigmaX: ${_sigmaX.toStringAsFixed(2)}'),
      Slider(
        min: 0,
        max: 10,
        value: _sigmaX,
        label: '$_sigmaX',
        onChanged: (value) {
          setState(() {
            _sigmaX = value;
          });
        },
      ),
      SizedBox(height: 5),
      Text('Change blur sigmaY: ${_sigmaY.toStringAsFixed(2)}'),
      Slider(
        min: 0,
        max: 10,
        value: _sigmaY,
        onChanged: (value) {
          setState(() {
            _sigmaY = value;
          });
        },
      ),
      SizedBox(height: 5),
      Text('Change blur opacity: ${_opacity.toStringAsFixed(2)}'),
      Slider(
        min: 0,
        max: 1,
        value: _opacity,
        onChanged: (value) {
          setState(() {
            _opacity = value;
          });
        },
      ),
    ];
  }

  Row _buildBlurContainerSizeAction() {
    return Row(
      children: <Widget>[
        Text('Blur size: Width: '),
        SizedBox(
          width: 30,
          height: 30,
          child: RaisedButton(
            child: Text('-'),
            onPressed: () {
              setState(() {
                _blurWidth = math.max(_blurWidth - 10, 0);
              });
            },
          ),
        ),
        Text(' ${_blurWidth.toInt()} '),
        SizedBox(
          width: 30,
          height: 30,
          child: RaisedButton(
            child: Text('+'),
            onPressed: () {
              setState(() {
                _blurWidth = math.min(_blurWidth + 10, _width);
              });
            },
          ),
        ),
        Text(' Height:'),
        SizedBox(
          width: 30,
          height: 30,
          child: RaisedButton(
            child: Text('-'),
            onPressed: () {
              setState(() {
                _blurHeight = math.max(_blurHeight - 10, 0);
              });
            },
          ),
        ),
        Text(' ${_blurHeight.toInt()} '),
        SizedBox(
          width: 30,
          height: 30,
          child: RaisedButton(
            child: Text('+'),
            onPressed: () {
              setState(() {
                _blurHeight = math.min(_blurHeight + 10, _height);
              });
            },
          ),
        ),
      ],
    );
  }
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  imageLib.Image _image;
  String fileName;
  Filter _filter;
  List<Filter> filters = presetFiltersList;

  Future getImage() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    fileName = basename(imageFile.path);
    var image = imageLib.decodeImage(imageFile.readAsBytesSync());
    image = imageLib.copyResizeCropSquare(image, 600);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Photo Filter Example'),
      ),
      body: new Container(
        alignment: Alignment(0.0, 0.0),
        child: _image == null
            ? new Text('No image selected.')
            : new PhotoFilterSelector(
                image: _image,
                filters: presetFiltersList,
                filename: fileName,
                loader: Center(child: CircularProgressIndicator()),
              ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }
}



class MyColorFilter extends StatefulWidget {
  int _r;
  int _g;
  int _b;
  var _opacity;

  MyColorFilter(r, g, b, opacity){
    _r = r;
    _g = g;
    _b = b;
    _opacity = opacity;
  }

  @override
  _MyColorFilterState createState() =>
      _MyColorFilterState(_r, _g, _b, _opacity);
}

class _MyColorFilterState
  extends State<MyColorFilter> {
  int _r;
  int _g;
  int _b;
  Color _color;
  var _opacity;

  _MyColorFilterState(r, g, b, opacity) {
    _r = r;
    _g = g;
    _b = b;
    _opacity = opacity;
    _color = Color.fromARGB(0, r, g, b);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          ColorFiltered(
            colorFilter: ColorFilter.mode(
                _color.withOpacity(_opacity), BlendMode.srcOver),
            child: Image.asset('assets/tg.png'),
          ),
          Row(
            children: [
              SizedBox(
                width: 130.0,
                child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'R',
                    ),
                    onChanged: (text) {
                      setState(() {
                        _r = int.parse(text);
                      });
                    },
                ),
              ),
              SizedBox(
                width: 130.0,
                child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'G',
                    ),
                    onChanged: (text) {
                      setState(() {
                        _g = int.parse(text);
                      });
                    },
                ),
              ),
              SizedBox(
                width: 130.0,
                child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'B',
                    ),
                    onChanged: (text) {
                      setState(() {
                        _b = int.parse(text);
                      });
                    },
                ),
              ),
            ],
          ),
          TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'from 0 to 1',
              ),
              onChanged: (text) {
                setState(() {
                  _opacity = double.parse(text);
                });
              },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {_color = Color.fromARGB(0, _r, _g, _b); print(_color.toString());},
      ),
    );
  }
}



class Third_lab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PageView(
        children: <Widget>[
          Container(
            child: BlurMultipleDynamicRegionPage(),
          ),
          Container(
            child: MyApp(),
          ),
          Container(
            child: MyColorFilter(10, 10, 10, 0.4)
          ),
        ],
      ),
    );
  }
}
