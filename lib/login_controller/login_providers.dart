
enum LoginProvider{
  email, gmail, phone
}

class RwAuthConstant{
  static const invalid_email="invalid-email";
  static const invalid_phone="invalid-phone-number";
  static const weak_password = "weak-password";
  static const email_already_in_use = "email-already-in-use";
  static const unknown = "unknown-error";

  // const for Hashmap keys/values
  static const user_exist = "user_exist";
  static const can_signin_with_link = "can_signin_with_link";
  static const can_signin_with_password = "can_signin_with_password";
  static const error = "error";
  static const user_not_found = "user-not-found";
  static const wrong_password = "wrong-password";

  static const result = "result";
  static const result_code = "result_code";
  static const verification_complete = 1;
  static const verification_failed = 2;
  static const code_sent = 3;
  static const code_auto_retrieval_timeout = 4;

  static const result_data = "result_data";

  static const phone_auth_cred = "phone_auth_cred";
  static const firebase_exception = "firebase_exception";

}

class PhoneAuthResult {
  dynamic result;

  Map<String, dynamic?>? resultData;
  PhoneAuthResult({required dynamic result_code, required Map<String, dynamic>? result_data});

}