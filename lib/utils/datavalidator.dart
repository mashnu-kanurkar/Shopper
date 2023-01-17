class Validator{
  static bool isValidPhoneNumber(String number){
    return number.length == 10;
  }

  static bool isValidEmail(String email){
    bool validEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    return validEmail;
  }

  static bool isValidPassword(String password){
    return true;
  }
}