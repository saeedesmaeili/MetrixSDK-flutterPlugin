import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;

import 'package:metrix/metrixConfig.dart';

class Metrix {
  static const MethodChannel _channel = const MethodChannel('metrix');

  static Future<void> onCreate(MetrixConfig config) async {
    if (defaultTargetPlatform != TargetPlatform.android && !kIsWeb) {
      await _channel
          .invokeMethod('initialize', <String, dynamic>{'appId': config.appId});
    } else {
      if (config.deferredDeeplinkCallback != null)
        _channel.invokeMethod("setDeferredDeeplinkMethod", "").then((onVal) {
          config.deferredDeeplinkCallback(onVal);
        });
      if (config.attributionCallback != null)
        _channel.invokeMethod("setAttributionMethod", "").then((onVal) {
          config.attributionCallback(jsonDecode(onVal));
        });
      if (config.userIdCallback != null)
        _channel.invokeMethod("setUserIdMethod", "").then((onVal) {
          config.userIdCallback(onVal);
        });
      if (config.sessionIdCallback != null)
        _channel.invokeMethod("setSessionIdMethod", "").then((onVal) {
          config.sessionIdCallback(onVal);
        });

      await _channel.invokeMethod('onCreate',config.toJson());
    }
    return;
  }

  static Future<void> newEvent(String slug, Map<String, String> attributes) async {
    await _channel.invokeMethod('newEvent', <String, dynamic>{
      'slug': slug,
      'attributes': attributes,
    });
    return;
  }


  static Future<void> addUserAttributes(Map<String, String> attributes) async {
    await _channel.invokeMethod('addUserAttributes', <String, dynamic>{
      'attributes': attributes
    });
    return;
  }

  static Future<void> appWillOpenUrl(String url) async {
    await _channel.invokeMethod('appWillOpenUrl', <String, dynamic>{
      'uri': url
    });
    return;
  }

  static Future<void> newRevenue(
      String slug, double amount, int currency, String orderId) async {
    await _channel.invokeMethod('newRevenue', <String, dynamic>{
      'slug': slug,
      'amount': amount,
      'currency': currency,
      'orderId': orderId
    });
    return;
  }
}
