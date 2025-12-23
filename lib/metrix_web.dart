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

  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onCreate':
        _handleOnCreate(call.arguments);
        return null;
      case 'setDeferredDeeplinkMethod':
        return _registerCallback('setDeferredDeeplinkCallback');
      case 'setAttributionMethod':
        return _registerCallback('setAttributionCallback');
      case 'setUserIdMethod':
        return _handlePromiseMethod('onMetrixUserIdReceived');
      case 'setSessionIdMethod':
        return _registerCallback('setSessionIdCallback');
      case 'newEvent':
        _handleNewEvent(call.arguments);
        return null;
      case 'newEventByName':
        _handleNewEventByName(call.arguments);
        return null;
      case 'newRevenue':
        _handleNewRevenue(call.arguments);
        return null;
      case 'authorizeUser':
        _handleAuthorizeUser(call.arguments);
        return null;
      case 'deauthorizeUser':
        _handleDeauthorizeUser();
        return null;
      case 'setFirstName':
        _handleSimpleAttribute('setFirstName', call.arguments, 'firstName');
        return null;
      case 'setLastName':
        _handleSimpleAttribute('setLastName', call.arguments, 'lastName');
        return null;
      case 'setEmail':
        _handleSimpleAttribute('setEmail', call.arguments, 'email');
        return null;
      case 'setHashedEmail':
        _handleSimpleAttribute('setHashedEmail', call.arguments, 'hashedEmail');
        return null;
      case 'setPhoneNumber':
        _handleSimpleAttribute('setPhoneNumber', call.arguments, 'phoneNumber');
        return null;
      case 'setHashedPhoneNumber':
        _handleSimpleAttribute('setHashedPhoneNumber', call.arguments, 'hashedPhoneNumber');
        return null;
      case 'setCountry':
        _handleSimpleAttribute('setCountry', call.arguments, 'country');
        return null;
      case 'setCity':
        _handleSimpleAttribute('setCity', call.arguments, 'city');
        return null;
      case 'setRegion':
        _handleSimpleAttribute('setRegion', call.arguments, 'region');
        return null;
      case 'setLocality':
        _handleSimpleAttribute('setLocality', call.arguments, 'locality');
        return null;
      case 'setGender':
        _handleSimpleAttribute('setGender', call.arguments, 'gender');
        return null;
      case 'setBirthday':
        _handleSimpleAttribute('setBirthday', call.arguments, 'birthday');
        return null;
      case 'setCustomAttribute':
        _handleCustomAttribute(call.arguments);
        return null;
      case 'onAutomationUserIdReceived':
        return _handlePromiseMethod('onAutomationUserIdReceived');
      case 'onMetrixUserIdReceived':
        return _handlePromiseMethod('onMetrixUserIdReceived');
      case 'addUserAttributes':
        _handleAddUserAttributes(call.arguments);
        return null;
      case 'appWillOpenUrl':
        _handleAppWillOpenUrl(call.arguments);
        return null;
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
    final apiKey = settings['apiKey'];
    final options = Map<String, dynamic>.from(settings)
      ..remove('appId')
      ..remove('apiKey');
    final jsOptions = _jsify(options);
    final jsSettings = _jsify(settings);
    if (apiKey != null) {
      if (_callMetrixMethod('init', [appId, apiKey, jsOptions])) {
        return;
      }
      if (_callMetrixMethod('initialize', [appId, apiKey, jsOptions])) {
        return;
      }
      if (_callMetrixMethod('create', [appId, apiKey, jsOptions])) {
        return;
      }
    }
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

  static void _handleNewEventByName(dynamic arguments) {
    final data = _asMap(arguments);
    final name = data['name'];
    final attributes = _jsify(data['attributes'] ?? <String, String>{});
    if (_callMetrixMethod('newEventByName', [name, attributes])) {
      return;
    }
    if (_callMetrixMethod('eventByName', [name, attributes])) {
      return;
    }
    _callMetrixMethod('trackEventByName', [name, attributes]);
  }

  static void _handleNewRevenue(dynamic arguments) {
    final data = _asMap(arguments);
    final slug = data['slug'];
    final amount = data['amount'];
    final currency = _normalizeCurrency(data['currency']);
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
    final attributes = Map<String, dynamic>.from(data['attributes'] ?? <String, String>{});
    if (_callMetrixMethod('addUserAttributes', [_jsify(attributes)])) {
      return;
    }
    if (_callMetrixMethod('setUserAttributes', [_jsify(attributes)])) {
      return;
    }
    if (_callMetrixMethod('setUserProperties', [_jsify(attributes)])) {
      return;
    }
    if (_hasMetrixMethod('setCustomAttribute')) {
      attributes.forEach((key, value) {
        _callMetrixMethod('setCustomAttribute', [key, value?.toString()]);
      });
    }
  }

  static void _handleAppWillOpenUrl(dynamic arguments) {
    final data = _asMap(arguments);
    final uri = data['uri'];
    if (_callMetrixMethod('appWillOpenUrl', [uri])) {
      return;
    }
    _callMetrixMethod('openUrl', [uri]);
  }

  static void _handleAuthorizeUser(dynamic arguments) {
    final data = _asMap(arguments);
    final customUserId = data['customUserId'];
    _callMetrixMethod('authorizeUser', [customUserId]);
  }

  static void _handleDeauthorizeUser() {
    _callMetrixMethod('deauthorizeUser', const []);
  }

  static void _handleSimpleAttribute(String methodName, dynamic arguments, String key) {
    final data = _asMap(arguments);
    final value = data[key];
    _callMetrixMethod(methodName, [value]);
  }

  static void _handleCustomAttribute(dynamic arguments) {
    final data = _asMap(arguments);
    final key = data['key'];
    final value = data['value'];
    _callMetrixMethod('setCustomAttribute', [key, value]);
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

  static Future<dynamic> _handlePromiseMethod(String methodName) async {
    final metrixObject = _getMetrixObject();
    if (metrixObject != null && js_util.hasProperty(metrixObject, methodName)) {
      final result = js_util.callMethod(metrixObject, methodName, const []);
      if (result != null && js_util.hasProperty(result, 'then')) {
        return js_util.promiseToFuture(result);
      }
      return result;
    }
    if (context.hasProperty('metrix')) {
      final result = context.callMethod('metrix', <dynamic>[methodName]);
      if (result != null && js_util.hasProperty(result, 'then')) {
        return js_util.promiseToFuture(result);
      }
      return result;
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

  static String _normalizeCurrency(dynamic currency) {
    if (currency is String) {
      return currency;
    }
    if (currency is int) {
      if (currency == 1) {
        return 'USD';
      }
      if (currency == 2) {
        return 'EUR';
      }
    }
    return 'IRR';
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

  static bool _hasMetrixMethod(String method) {
    final metrixObject = _getMetrixObject();
    if (metrixObject != null && js_util.hasProperty(metrixObject, method)) {
      return true;
    }
    return context.hasProperty('metrix');
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
