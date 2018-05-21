import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:arcgis_flutter/map_view.dart';

///This API Key will be used for both the interactive maps as well as the static maps.
///Make sure that you have enabled the following APIs in the Google API Console (https://console.developers.google.com/apis)
/// - Static Maps API
/// - Android Maps API
/// - iOS Maps API
var apiKey = "AIzaSyCzGs0MnqCcztKOIdxh8MEGDhUJflJ96Vo";

void main() {
  MapView.setApiKey(apiKey);
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MapView mapView = new MapView();
  CameraPosition cameraPosition;
  var compositeSubscription = new CompositeSubscription();

  List<Marker> _markers = <Marker>[
    new Marker("1", "USC", 34.0224, -118.2851, color: Colors.purple),
  ];

  @override
  initState() {
    super.initState();
    cameraPosition = new CameraPosition(Locations.portland, 2.0);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text('Map View Example'),
          ),
          body: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Container(
                    child: new MaterialButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: new Text("Show the arcGIS map"),
                  onPressed: showMap,
                )),
                new Container(
                  padding: new EdgeInsets.only(top: 25.0),
                  child: new Text("Camera Position: \nLat: "
                      "${cameraPosition.center.latitude}\n"
                      "Lng:${cameraPosition.center.longitude}\n"
                      "Zoom: ${cameraPosition.zoom}\n"),
                ),
              ],
            ),
          )),
    );
  }

  showMap() {
    mapView.show(
        new MapOptions(
            mapViewType: MapViewType.normal,
            showUserLocation: true,
            initialCameraPosition: new CameraPosition(
                new Location(45.5235258, -122.6732493), 14.0),
            title: "Recently Visited"),
        toolbarActions: [new ToolbarAction("Close", 1)]);

    var sub = mapView.onMapReady.listen((_) {
      mapView.setLayers(_mapLayers);
      mapView.setMarkers(_markers);
      mapView.setCameraPosition(34.0224, -118.2851, 16.0);
    });
    compositeSubscription.add(sub);

    sub = mapView.onLocationUpdated
        .listen((location) => print("Location updated $location"));
    compositeSubscription.add(sub);

    sub = mapView.onCameraChanged.listen((cameraPosition) =>
        this.setState(() => this.cameraPosition = cameraPosition));
    compositeSubscription.add(sub);

    sub = mapView.onToolbarAction.listen((id) {
      if (id == 1) {
        _handleDismiss();
      }
    });
    compositeSubscription.add(sub);
    compositeSubscription.add(sub);
  }

  _handleDismiss() async {
//    double zoomLevel = await mapView.zoomLevel;
//    Location centerLocation = await mapView.centerLocation;
//    List<Marker> visibleAnnotations = await mapView.visibleAnnotations;
//    print("Zoom Level: $zoomLevel");
//    print("Center: $centerLocation");
//    print("Visible Annotation Count: ${visibleAnnotations.length}");
//    var uri = await staticMapProvider.getImageUriFromMap(mapView,
//        width: 900, height: 400);
//    setState(() => staticMapUri = uri);
    var centerLocation = await mapView.centerLocation;
    var zoomLevel = await mapView.zoomLevel;

    setState(() {
      cameraPosition = new CameraPosition(centerLocation, zoomLevel);
    });

    mapView.dismiss();
    compositeSubscription.cancel();
  }
}

class CompositeSubscription {
  Set<StreamSubscription<dynamic>> _subscriptions = new Set();

  void cancel() {
    for (var n in this._subscriptions) {
      n.cancel();
    }
    this._subscriptions = new Set();
  }

  void add(StreamSubscription subscription) {
    this._subscriptions.add(subscription);
  }

  void addAll(Iterable<StreamSubscription> subs) {
    _subscriptions.addAll(subs);
  }

  bool remove(StreamSubscription subscription) {
    return this._subscriptions.remove(subscription);
  }

  bool contains(StreamSubscription subscription) {
    return this._subscriptions.contains(subscription);
  }

  List<StreamSubscription> toList() {
    return this._subscriptions.toList();
  }
}

List<MapLayer> get _mapLayers => (json.decode(r"""
{
    "mapLayers": [{
            "name": "Ramps",
            "url": "http://fmsmaps3.usc.edu:6080/arcgis/rest/services/Accessibility/Accessibility/MapServer/9",
            "visible_by_default": true
        },
        {
            "name": "Building Entrances",
            "url": "http://fmsmaps3.usc.edu:6080/arcgis/rest/services/Accessibility/Accessibility/MapServer/3",
            "visible_by_default": false
        },
        {
            "name": "Elevators",
            "url": "http://fmsmaps3.usc.edu:6080/arcgis/rest/services/Accessibility/Accessibility/MapServer/2",
            "visible_by_default": false
        },
        {
            "name": "Accessible Parking",
            "url": "http://fmsmaps3.usc.edu:6080/arcgis/rest/services/Accessibility/Accessibility/MapServer/6",
            "visible_by_default": false
        },
        {
            "name": "Curb Access",
            "url": "http://fmsmaps3.usc.edu:6080/arcgis/rest/services/Accessibility/Accessibility/MapServer/10",
            "visible_by_default": true
        },
        {
            "name": "Buildings",
            "url": "http://fmsmaps3.usc.edu:6080/arcgis/rest/services/Accessibility/Accessibility/MapServer/11",
            "visible_by_default": false
        },
        {
            "name": "Sculptures",
            "url": "http://fmsmaps3.usc.edu:6080/arcgis/rest/services/Basemap/BasemapUPCColor4NAD83/MapServer/11",
            "visible_by_default": false
        },
        {
            "name": "Benches",
            "url": "http://fmsmaps3.usc.edu:6080/arcgis/rest/services/Basemap/BasemapUPCColor4NAD83/MapServer/12",
            "visible_by_default": false
        },
        {
            "name": "Courtyards",
            "url": "http://fmsmaps3.usc.edu:6080/arcgis/rest/services/Basemap/BasemapUPCColor4NAD83/MapServer/14",
            "visible_by_default": false
        },
        {
            "name": "Fences",
            "url": "http://fmsmaps3.usc.edu:6080/arcgis/rest/services/Basemap/BasemapUPCColor4NAD83/MapServer/18",
            "visible_by_default": false
        },
        {
            "name": "Fountains",
            "url": "http://fmsmaps3.usc.edu:6080/arcgis/rest/services/Basemap/BasemapUPCColor4NAD83/MapServer/19",
            "visible_by_default": false
        },
        {
            "name": "Flowerbeds",
            "url": "http://fmsmaps3.usc.edu:6080/arcgis/rest/services/Basemap/BasemapUPCColor4NAD83/MapServer/25",
            "visible_by_default": false
        },
        {
            "name": "Planters",
            "url": "http://fmsmaps3.usc.edu:6080/arcgis/rest/services/Basemap/BasemapUPCColor4NAD83/MapServer/26",
            "visible_by_default": false
        },
        {
            "name": "Shrubs",
            "url": "http://fmsmaps3.usc.edu:6080/arcgis/rest/services/Basemap/BasemapUPCColor4NAD83/MapServer/34",
            "visible_by_default": false
        }
    ]
}
""")['mapLayers'] as List).map((json) => new MapLayer.fromJson(json)).toList();
