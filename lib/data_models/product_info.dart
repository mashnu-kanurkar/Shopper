class ProductInfo{
  String _p_id;

  ProductInfo(this._p_id);

  String? _name;
  String? _category;
  List<String>? _imageUrls;
  double? _price;
  double? _discount;
  String? _description;
  String? _store_id;
  Review? _review;
  Map<String, String>? _productSpecification;
  Map<String, String>? _productVariation;
  ReturnPolicy? _returnPolicy;

  String get p_id => _p_id;

  set p_id(String value) {
    _p_id = value;
  }

  String? get name => _name;

  ReturnPolicy? get returnPolicy => _returnPolicy;

  set returnPolicy(ReturnPolicy? value) {
    _returnPolicy = value;
  }

  Map<String, String>? get productVariation => _productVariation;

  set productVariation(Map<String, String>? value) {
    _productVariation = value;
  }

  Map<String, String>? get productSpecification => _productSpecification;

  set productSpecification(Map<String, String>? value) {
    _productSpecification = value;
  }

  Review? get review => _review;

  set review(Review? value) {
    _review = value;
  }

  String? get store_id => _store_id;

  set store_id(String? value) {
    _store_id = value;
  }

  String? get description => _description;

  set description(String? value) {
    _description = value;
  }

  double? get discount => _discount;

  set discount(double? value) {
    _discount = value;
  }

  double? get price => _price;

  set price(double? value) {
    _price = value;
  }

  List<String>? get imageUrls => _imageUrls;

  set imageUrls(List<String>? value) {
    _imageUrls = value;
  }

  String? get category => _category;

  set category(String? value) {
    _category = value;
  }

  set name(String? value) {
    _name = value;
  }
}

class Review{
  int? _rating;
  String? _comment;

  Review(this._rating, this._comment);

  String? get comment => _comment;

  set comment(String? value) {
    _comment = value;
  }

  int? get rating => _rating;

  set rating(int? value) {
    _rating = value;
  }
}

class ProductSpecification{
  String? _brandName;


}

class ProductVariation{

}

class ReturnPolicy{
  ReturnType _returnType = ReturnType.NONE;
  int? _returnWindow;

  ReturnPolicy(this._returnType, this._returnWindow);

  int? get returnWindow => _returnWindow;

  set returnWindow(int? value) {
    _returnWindow = value;
  }

  ReturnType get returnType => _returnType;

  set returnType(ReturnType value) {
    _returnType = value;
  }
}

enum ReturnType{
  REFUND, REPLACE, NONE
}