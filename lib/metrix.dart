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

  static Future<void> newEventByName(String name, Map<String, String> attributes) async {
    await _channel.invokeMethod('newEventByName', <String, dynamic>{
      'name': name,
      'attributes': attributes,
    });
    return;
  }

  static Future<void> authorizeUser(String customUserId) async {
    await _channel.invokeMethod('authorizeUser', <String, dynamic>{
      'customUserId': customUserId,
    });
    return;
  }

  static Future<void> deauthorizeUser() async {
    await _channel.invokeMethod('deauthorizeUser');
    return;
  }

  static Future<void> setFirstName(String firstName) async {
    await _channel.invokeMethod('setFirstName', <String, dynamic>{
      'firstName': firstName,
    });
    return;
  }

  static Future<void> setLastName(String lastName) async {
    await _channel.invokeMethod('setLastName', <String, dynamic>{
      'lastName': lastName,
    });
    return;
  }

  static Future<void> setEmail(String email) async {
    await _channel.invokeMethod('setEmail', <String, dynamic>{
      'email': email,
    });
    return;
  }

  static Future<void> setHashedEmail(String hashedEmail) async {
    await _channel.invokeMethod('setHashedEmail', <String, dynamic>{
      'hashedEmail': hashedEmail,
    });
    return;
  }

  static Future<void> setPhoneNumber(String phoneNumber) async {
    await _channel.invokeMethod('setPhoneNumber', <String, dynamic>{
      'phoneNumber': phoneNumber,
    });
    return;
  }

  static Future<void> setHashedPhoneNumber(String hashedPhoneNumber) async {
    await _channel.invokeMethod('setHashedPhoneNumber', <String, dynamic>{
      'hashedPhoneNumber': hashedPhoneNumber,
    });
    return;
  }

  static Future<void> setCountry(String country) async {
    await _channel.invokeMethod('setCountry', <String, dynamic>{
      'country': country,
    });
    return;
  }

  static Future<void> setCity(String city) async {
    await _channel.invokeMethod('setCity', <String, dynamic>{
      'city': city,
    });
    return;
  }

  static Future<void> setRegion(String region) async {
    await _channel.invokeMethod('setRegion', <String, dynamic>{
      'region': region,
    });
    return;
  }

  static Future<void> setLocality(String locality) async {
    await _channel.invokeMethod('setLocality', <String, dynamic>{
      'locality': locality,
    });
    return;
  }

  static Future<void> setGender(String gender) async {
    await _channel.invokeMethod('setGender', <String, dynamic>{
      'gender': gender,
    });
    return;
  }

  static Future<void> setBirthday(String birthday) async {
    await _channel.invokeMethod('setBirthday', <String, dynamic>{
      'birthday': birthday,
    });
    return;
  }

  static Future<void> setCustomAttribute(String key, String value) async {
    await _channel.invokeMethod('setCustomAttribute', <String, dynamic>{
      'key': key,
      'value': value,
    });
    return;
  }

  static Future<String> onAutomationUserIdReceived() async {
    final response = await _channel.invokeMethod('onAutomationUserIdReceived');
    return response;
  }

  static Future<String> onMetrixUserIdReceived() async {
    final response = await _channel.invokeMethod('onMetrixUserIdReceived');
    return response;
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
