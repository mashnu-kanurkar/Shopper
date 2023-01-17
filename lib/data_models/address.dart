class Address{


  Address(this._line1, this._line2, this._landMark, this._city, this._state, this._country, this._postalCode);

  String? _line1;
  String? _line2;
  String? _landMark;
  String? _city;
  String? _state;
  String? _country;
  String? _postalCode;

  String? get line1 => _line1;

  set line1(String? value) {
    _line1 = value;
  }

  String? get line2 => _line2;

  set line2(String? value) {
    _line2 = value;
  }

  String? get postalCode => _postalCode;

  set postalCode(String? value) {
    _postalCode = value;
  }

  String? get country => _country;

  set country(String? value) {
    _country = value;
  }

  String? get state => _state;

  set state(String? value) {
    _state = value;
  }

  String? get city => _city;

  set city(String? value) {
    _city = value;
  }

  String? get landMark => _landMark;

  set landMark(String? value) {
    _landMark = value;
  }
}