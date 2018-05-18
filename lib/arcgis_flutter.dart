import 'dart:async';

import 'package:arcgis_flutter/src/options.dart';
import 'package:flutter/services.dart';

export 'package:arcgis_flutter/src/options.dart';

class ArcgisFlutter {
  static const MethodChannel _channel = const MethodChannel('arcgis_flutter');

  static Future<String> show(ArcgisMapOptions options) async {
    final String version = await _channel.invokeMethod('showMap');
    return version;
  }

}
