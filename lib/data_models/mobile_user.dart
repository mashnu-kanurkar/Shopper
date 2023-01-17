import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_local_market/data_models/device_info.dart';

class MobileUser{
  /// private constructor
  MobileUser._();
  /// the one and only instance of this singleton
  static final instance = MobileUser._();

  User? _firebaseUser;
  Map<String, int?> _location = <String, int?>{"lat": null, "long": null};
  String? _gender;
  int _marketRadius = 10;
  DeviceInfo? _deviceInfo;
  Duration? _timezoneOffset;

  User? get firebaseUser => _firebaseUser;

  set firebaseUser(User? value) {
    _firebaseUser = value;
  }

  Map<String, int?> get location => _location;

  set location(Map<String, int?> value) {
    _location = value;
  }

  String? get gender => _gender;

  set gender(String? value) {
    _gender = value;
  }

  int get marketRadius => _marketRadius;

  set marketRadius(int value) {
    _marketRadius = value;
  }

  DeviceInfo? get deviceInfo => _deviceInfo;

  set deviceInfo(DeviceInfo? value) {
    _deviceInfo = value;
  }

  Duration? get timezoneOffset => _timezoneOffset;

  set timezoneOffset(Duration? value) {
    _timezoneOffset = value;
  }
}
