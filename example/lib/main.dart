import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:arcgis_flutter/arcgis_flutter.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  initState() {
    super.initState();
  }

  void _openMap() {
    var options = new ArcgisMapOptions();
    ArcgisFlutter.show(options);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('ArcGIS in flutter'),
        ),
        body: new Center(
          child: new MaterialButton(
            child: new Text("Tap to open"),
            onPressed: _openMap,
          ),
        ),
      ),
    );
  }
}
