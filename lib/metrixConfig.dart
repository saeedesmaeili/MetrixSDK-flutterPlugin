class MetrixConfig {
  String appId;
  int _secretId = 0;
  int _info1;
  int _info2;
  int _info3;
  int _info4;
  bool locationListening;
  bool lunchDeferredDeeplink;
  String store;
  String apiKey;
  String _firebaseAppId;
  String _firebaseProjectId;
  String _firebaseApiKey;
  int eventUploadThreshold;

  int eventUploadMaxBatchSize;

  int eventMaxCount;

  int eventUploadPeriodMillis;

  int sessionTimeoutMillis;

  int logLevel;

  String trackerToken;
  bool loggingEnabled;

  bool flushEventsOnClose;
  Map<String, dynamic> sessionTracking;
  Map<String, dynamic> onSiteMessaging;

  Function sessionIdCallback;
  Function userIdCallback;
  Function attributionCallback;
  Function deferredDeeplinkCallback;

  void setAppSecret(int secretId, int info1, int info2, int info3, int info4) {
    this._secretId = secretId;
    this._info1 = info1;
    this._info2 = info2;
    this._info3 = info3;
    this._info4 = info4;
  }

  void setFirebaseId(String firebaseAppId, String firebaseProjectId, String firebaseApiKey) {
    this._firebaseAppId = firebaseAppId;
    this._firebaseProjectId = firebaseProjectId;
    this._firebaseAppId = firebaseApiKey;
  }

  MetrixConfig(this.appId);

  Map<String, dynamic> toJson() => {
        'appId': appId,
        'appSecret': {
          'secretId ': _secretId,
          'info1': _info1,
          'info2': _info2,
          'info3': _info3,
          'info4': _info4,
        },
        'locationListening': locationListening,
        'store': store,
        'apiKey': apiKey,
        'eventUploadThreshold': eventUploadThreshold,
        'eventUploadMaxBatchSize': eventUploadMaxBatchSize,
        'eventMaxCount': eventMaxCount,
        'eventUploadPeriodMillis': eventUploadPeriodMillis,
        'sessionTimeoutMillis': sessionTimeoutMillis,
        'logLevel': logLevel,
        'trackerToken': trackerToken,
        'loggingEnabled': loggingEnabled,
        'firebaseAppId': _firebaseAppId != null ? "${_firebaseAppId.replaceAll(":","_")}" : null,
        'firebaseProjectId': _firebaseProjectId,
        'firebaseApiKey': _firebaseApiKey,
        'lunchDeferredDeeplink': lunchDeferredDeeplink,
        'flushEventsOnClose': flushEventsOnClose,
        'sessionTracking': sessionTracking,
        'onSiteMessaging': onSiteMessaging,
      };
}
