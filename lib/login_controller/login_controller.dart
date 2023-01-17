
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_local_market/login_controller/Firebase_login_provider.dart';
import 'package:my_local_market/login_controller/login_data_listener.dart';
import 'package:my_local_market/values/constants.dart';

class LoginController {
  LoginController();
  void initAnonymousLogin(AnonymousLoginListener anonymousLoginListener) async{
    FirebaseLoginProvider firebaseLoginProvider = FirebaseLoginProvider();
    firebaseLoginProvider.signInAnonymously(anonymousLoginListener);
  }
  void initLoginWithPhone(PhoneLoginStateListener phoneLoginStateListener, String phoneNumber) async{
    FirebaseLoginProvider firebaseLoginProvider = FirebaseLoginProvider();
    firebaseLoginProvider.rwVerifyPhoneNumber(phoneLoginStateListener, phoneNumber, const Duration(seconds: Constants.otpTimeout));
  }

  void initLoginWithEmail(EmailLoginStateListener emailLoginStateListener, String email){
    FirebaseLoginProvider firebaseLoginProvider = FirebaseLoginProvider();
    firebaseLoginProvider.checkExistingUserEmail(emailLoginStateListener: emailLoginStateListener, email: email);
  }

  Future<void> signInWithCredential( phoneLoginStateListener, String verificationId, String smsCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
    // Sign the user in (or link) with the credential
    //await FirebaseAuth.instance.signInWithCredential(credential);
    FirebaseLoginProvider firebaseLoginProvider = FirebaseLoginProvider();
    await firebaseLoginProvider.signInWithPhone(phoneLoginStateListener: phoneLoginStateListener, phoneAuthCredential: credential);

  }

  Future<void> signInWithEmailAndPassword({required EmailLoginStateListener emailLoginStateListener, required String email, required String password}) async{
    FirebaseLoginProvider firebaseLoginProvider = FirebaseLoginProvider();
    firebaseLoginProvider.rwSigninWithEMailAndPassword(emailLoginStateListener: emailLoginStateListener, email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword({required EmailLoginStateListener emailLoginStateListener, required String email, required String password})async{
    FirebaseLoginProvider firebaseLoginProvider = FirebaseLoginProvider();
    firebaseLoginProvider.rwCreateUserWithEmailAndPassword(emailLoginStateListener: emailLoginStateListener, email: email, password: password);
  }

  Future<void> updateDisplayName({required String name})async {
    FirebaseLoginProvider firebaseLoginProvider = FirebaseLoginProvider();
    firebaseLoginProvider.updateDisplayName(name: name);
  }
}

