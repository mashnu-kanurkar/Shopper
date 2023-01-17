import 'package:my_local_market/data_models/address.dart';

class StoreInfo {
  String _s_id = "";

  StoreInfo(this._s_id);

  String? _storename;

  String? _ownerName;

  Address? _address;

  String? _phoneNumber;

  String? _email;

  StoreType _storeType = StoreType.MIXED;

  // featured list of products or services
  dynamic _featuredType;

  // featured list of categories
  dynamic _featuredCategories;

  String? get storename => _storename;

  set storename(String? value) {
    _storename = value;
  }

  String? get ownerName => _ownerName;

  set ownerName(String? value) {
    _ownerName = value;
  }

  dynamic get featuredCategories => _featuredCategories;

  set featuredCategories(dynamic value) {
    _featuredCategories = value;
  }

  dynamic get featuredType => _featuredType;

  set featuredType(dynamic value) {
    _featuredType = value;
  }

  StoreType get storeType => _storeType;

  set storeType(StoreType value) {
    _storeType = value;
  }

  String? get email => _email;

  set email(String? value) {
    _email = value;
  }

  String? get phoneNumber => _phoneNumber;

  set phoneNumber(String? value) {
    _phoneNumber = value;
  }

  Address? get address => _address;

  set address(Address? value) {
    _address = value;
  }
}

enum StoreType { PRODUCT, SERVCIE, MIXED }
