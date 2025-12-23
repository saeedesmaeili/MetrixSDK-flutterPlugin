import 'dart:async';
import 'dart:js';
import 'dart:js_util' as js_util;

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class MetrixWeb {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel =
        MethodChannel('metrix', const StandardMethodCodec(), registrar);
    channel.setMethodCallHandler(_handleMethodCall);
  }

  static Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onCreate':
        _handleOnCreate(call.arguments);
        return;
      case 'setDeferredDeeplinkMethod':
        await _registerCallback('setDeferredDeeplinkCallback');
        return;
      case 'setAttributionMethod':
        await _registerCallback('setAttributionCallback');
        return;
      case 'setUserIdMethod':
        await _registerCallback('setUserIdCallback');
        return;
      case 'setSessionIdMethod':
        await _registerCallback('setSessionIdCallback');
        return;
      case 'newEvent':
        _handleNewEvent(call.arguments);
        return;
      case 'newRevenue':
        _handleNewRevenue(call.arguments);
        return;
      case 'addUserAttributes':
        _handleAddUserAttributes(call.arguments);
        return;
      case 'appWillOpenUrl':
        _handleAppWillOpenUrl(call.arguments);
        return;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'metrix for web doesn\'t implement ${call.method}',
        );
    }
  }

  static void _handleOnCreate(dynamic arguments) {
    final settings = _asMap(arguments);
    final appId = settings['appId'];
    final options = Map<String, dynamic>.from(settings)..remove('appId');
    final jsOptions = _jsify(options);
    final jsSettings = _jsify(settings);
    if (_callMetrixMethod('onCreate', [jsSettings])) {
      return;
    }
    if (_callMetrixMethod('initialize', [appId, jsOptions])) {
      return;
    }
    if (_callMetrixMethod('init', [appId, jsOptions])) {
      return;
    }
    _callMetrixMethod('create', [appId, jsOptions]);
  }

  static void _handleNewEvent(dynamic arguments) {
    final data = _asMap(arguments);
    final slug = data['slug'];
    final attributes = _jsify(data['attributes'] ?? <String, String>{});
    if (_callMetrixMethod('newEvent', [slug, attributes])) {
      return;
    }
    if (_callMetrixMethod('event', [slug, attributes])) {
      return;
    }
    _callMetrixMethod('trackEvent', [slug, attributes]);
  }

  static void _handleNewRevenue(dynamic arguments) {
    final data = _asMap(arguments);
    final slug = data['slug'];
    final amount = data['amount'];
    final currency = data['currency'];
    final orderId = data['orderId'];
    if (_callMetrixMethod('newRevenue', [slug, amount, currency, orderId])) {
      return;
    }
    if (_callMetrixMethod('revenue', [slug, amount, currency, orderId])) {
      return;
    }
    _callMetrixMethod('trackRevenue', [slug, amount, currency, orderId]);
  }

  static void _handleAddUserAttributes(dynamic arguments) {
    final data = _asMap(arguments);
    final attributes = _jsify(data['attributes'] ?? <String, String>{});
    if (_callMetrixMethod('addUserAttributes', [attributes])) {
      return;
    }
    if (_callMetrixMethod('setUserAttributes', [attributes])) {
      return;
    }
    _callMetrixMethod('setUserProperties', [attributes]);
  }

  static void _handleAppWillOpenUrl(dynamic arguments) {
    final data = _asMap(arguments);
    final uri = data['uri'];
    if (_callMetrixMethod('appWillOpenUrl', [uri])) {
      return;
    }
    _callMetrixMethod('openUrl', [uri]);
  }

  static Future<dynamic> _registerCallback(String methodName) async {
    final completer = Completer<dynamic>();
    final callback = allowInterop((dynamic payload) {
      if (!completer.isCompleted) {
        completer.complete(payload);
      }
    });
    if (_callMetrixMethod(methodName, [callback])) {
      return completer.future;
    }
    return null;
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return <String, dynamic>{};
  }

  static dynamic _jsify(dynamic value) {
    if (value is Map || value is List) {
      return js_util.jsify(value);
    }
    return value;
  }

  static bool _callMetrixMethod(String method, List<dynamic> args) {
    final metrixObject = _getMetrixObject();
    if (metrixObject != null && js_util.hasProperty(metrixObject, method)) {
      js_util.callMethod(metrixObject, method, args);
      return true;
    }
    if (context.hasProperty('metrix')) {
      context.callMethod('metrix', <dynamic>[method, ...args]);
      return true;
    }
    return false;
  }

  static dynamic _getMetrixObject() {
    if (context.hasProperty('Metrix')) {
      return context['Metrix'];
    }
    if (context.hasProperty('metrix')) {
      final metrix = context['metrix'];
      if (metrix is JsObject && js_util.hasProperty(metrix, 'call')) {
        return metrix;
      }
    }
    return null;
  }
}
