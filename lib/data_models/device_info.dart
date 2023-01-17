class DeviceInfo{
  /// private constructor
  DeviceInfo._();
  /// the one and only instance of this singleton
  static final instance = DeviceInfo._();

  String _make = "UNKNOWN";
  String _model = "UNKNOWN";
  double _osVersion = 0.0;
  double _appVersion = 0.0;
  String _networkCarrier = "UNKNOWN";
  int _appUsageIndex = 0;
  DevicePlatform _devicePlatform = DevicePlatform.UNKNOWN;
  DeviceType _type = DeviceType.UNKNOWN;

  String get make => _make;

  set make(String value) {
    _make = value;
  }

  String get model => _model;

  DeviceType get type => _type;

  set type(DeviceType value) {
    _type = value;
  }

  DevicePlatform get devicePlatform => _devicePlatform;

  set devicePlatform(DevicePlatform value) {
    _devicePlatform = value;
  }

  int get appUsageIndex => _appUsageIndex;

  set appUsageIndex(int value) {
    _appUsageIndex = value;
  }

  String get networkCarrier => _networkCarrier;

  set networkCarrier(String value) {
    _networkCarrier = value;
  }

  double get appVersion => _appVersion;

  set appVersion(double value) {
    _appVersion = value;
  }

  double get osVersion => _osVersion;

  set osVersion(double value) {
    _osVersion = value;
  }

  set model(String value) {
    _model = value;
  }
}

enum DevicePlatform{
  ANDROID, IOS, WINDOWS, UNKNOWN
}

enum DeviceType{
  MOBILE, DESKTOP, TAB, UNKNOWN
}