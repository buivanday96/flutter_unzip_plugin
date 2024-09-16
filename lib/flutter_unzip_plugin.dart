import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class FlutterUnzipPlugin {
  static const MethodChannel _channel = const MethodChannel('flutter_unzip_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('upzip');
    return version;
  }

  Future<bool> extractToDir({required File zipFile, required Directory directory}) async {
    _channel.setMethodCallHandler((call) {
      if (call.method == 'process') {
        final int process = call.arguments;
        print('process : $process');
        return Future.value(process);
      }
      return Future.value();
    });

    bool result = false;
    try {
      result = await _channel.invokeMethod('unzip', <String, dynamic>{
        "zipPath": zipFile.path,
        "extractPath": directory.path,
      });
    } catch (e) {
      print(e.toString());
    }
    return result;
  }
}
