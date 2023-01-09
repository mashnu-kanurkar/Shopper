import 'dart:collection';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_local_market/login_controller/login_data_listener.dart';
import 'package:my_local_market/login_controller/login_providers.dart';

class FirebaseLoginProvider {
  FirebaseAuth firebaseAuthInstance = FirebaseAuth.instance;
  Future<PhoneAuthResult?> rwVerifyPhoneNumber(
      PhoneLoginStateListener phoneLoginStateListener,
      String phoneNUmber,
      Duration timeout) async {
    print("Initiated login with phone $phoneNUmber");
    PhoneAuthResult? phoneAuthResult;
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNUmber,
      verificationCompleted:  (PhoneAuthCredential credential) {
        // ANDROID ONLY!
        // Sign the user in (or link) with the auto-generated credential
        phoneLoginStateListener.verificationCompleted(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
        // Handle other errors
        phoneLoginStateListener.verificationFailed(e);
      },
      timeout: timeout,
      codeSent: (String verificationId, int? resendToken) async {
        // // Update the UI - wait for the user to enter the SMS code
        // String smsCode = 'xxxx';
        // // Create a PhoneAuthCredential with the code
        // PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
        // // Sign the user in (or link) with the credential
        await phoneLoginStateListener.codeSent(verificationId, resendToken);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-resolution timed out...
        phoneLoginStateListener.codeAutoRetrievalTimeout(verificationId);
      },
    );
    return phoneAuthResult;
  }

  Future<HashMap<String, bool>?> checkExistingUserEmail({
    required EmailLoginStateListener emailLoginStateListener,
    required String email,
  }) async {
    HashMap<String, bool>? existingUserState;
    try {
      final signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      final userExists = signInMethods.isNotEmpty;
      final canSignInWithLink =
          signInMethods.contains(EmailAuthProvider.EMAIL_LINK_SIGN_IN_METHOD);
      final canSignInWithPassword = signInMethods
          .contains(EmailAuthProvider.EMAIL_PASSWORD_SIGN_IN_METHOD);
      existingUserState?.addAll({
        RwAuthConstant.user_exist: userExists,
        RwAuthConstant.can_signin_with_link: canSignInWithLink,
        RwAuthConstant.can_signin_with_password: canSignInWithPassword
      });
      if(userExists){
        emailLoginStateListener.onUserEmailAlreadyExist(email, canSignInWithPassword, canSignInWithLink);
      }else{
        emailLoginStateListener.onUserEmailNotExist(email);
      }
      return existingUserState;
    } on FirebaseAuthException catch (exception) {
      switch (exception.code) {
        case RwAuthConstant.invalid_email:
          print("Not a valid email address.");
          existingUserState
              ?.addAll({RwAuthConstant.invalid_email: false});
          emailLoginStateListener.onEmailAuthException(RwAuthConstant.invalid_email);
          break;
        default:
          print("Unknown error.");
          existingUserState?.addAll({RwAuthConstant.unknown: false});
          emailLoginStateListener.onEmailAuthException(RwAuthConstant.unknown);
      }
    }
  }

  Future<void> signInWithCredential({required PhoneLoginStateListener phoneLoginStateListener, required String verificationId, required String smsCode}) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
    // Sign the user in (or link) with the credential
    final UserCredential userCredential =  await FirebaseAuth.instance.signInWithCredential(credential);
    phoneLoginStateListener.verificationCompleted(credential);
  }

  Future<void> rwCreateUserWithEmailAndPassword(
      {required EmailLoginStateListener emailLoginStateListener, required String email, required String password}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emailLoginStateListener.onUserCreated(credential.user);
    } on FirebaseAuthException catch (e) {
      if (e.code == RwAuthConstant.weak_password) {
        print('The password provided is too weak.');
        emailLoginStateListener.onEmailAuthException(RwAuthConstant.weak_password);
      } else if (e.code == RwAuthConstant.email_already_in_use) {
        print('The account already exists for that email.');
        emailLoginStateListener.onUserEmailAlreadyExist(email, false, false);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> rwSigninWithEMailAndPassword({required EmailLoginStateListener emailLoginStateListener, required String email, required String password}) async{
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      emailLoginStateListener.onSignInWithEmailCompleted(credential.user);

    } on FirebaseAuthException catch (e) {
      if (e.code == RwAuthConstant.user_not_found) {
        print('No user found for that email.');
        emailLoginStateListener.onUserEmailNotExist(email);
      } else if (e.code == RwAuthConstant.wrong_password) {
        print('Wrong password provided for that user.');
        emailLoginStateListener.onEmailAuthException(RwAuthConstant.wrong_password);
      }
    }
  }

  Future<void> updateDisplayName({required String name, }) async{
    await FirebaseAuth.instance.currentUser?.updateDisplayName(name);
  }
  Future<void> updateEmail({required String email, }) async{
    await FirebaseAuth.instance.currentUser?.updateEmail(email);
  }
  // Future<void> updatePhoneNumber({required String number, }) async{
  //   await FirebaseAuth.instance.currentUser?.updatePhoneNumber(number);
  // }
  Future<void> updatePassword({required String password, }) async{
    await FirebaseAuth.instance.currentUser?.updatePassword(password);
  }

  Future<void> signOutFirebaseUser()async {
    await FirebaseAuth.instance.signOut();
  }


}
