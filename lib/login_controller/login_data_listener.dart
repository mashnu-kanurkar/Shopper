import 'package:firebase_auth/firebase_auth.dart';

class LoginListener{

}

class AnonymousLoginListener extends LoginListener{
  onAnonymousSignInCompleted(UserCredential userCredential){
  }
  onAnonymousSignInFailed(FirebaseAuthException firebaseAuthException){
  }
}

class PhoneLoginStateListener extends LoginListener {
  verificationCompleted (PhoneAuthCredential phoneAuthCredential) {
    // TODO: implement verificationCompleted
    throw UnimplementedError();
  }
  verificationFailed(FirebaseAuthException e) {
    // TODO: implement verificationFailed
    throw UnimplementedError();
  }
  codeSent(String verificationId, int? resendToken) {
    // TODO: implement codeSent
    throw UnimplementedError();
  }
  codeAutoRetrievalTimeout(String verificationId) {
    // TODO: implement codeAutoRetrievalTimeout
    throw UnimplementedError();
  }
}


class EmailLoginStateListener extends LoginListener {
  onUserEmailExist(String email, bool canSignInWithPassword, bool canSignInWithLink) {
    // TODO: implement onUserEmailAlreadyExist
    throw UnimplementedError();
  }
  onUserEmailNotExist(String email){
    // TODO: implement onEmailAuthException
    throw UnimplementedError();
  }
  onSignInWithEmailCompleted(User? user){
    // TODO: implement onEmailAuthException
    throw UnimplementedError();
  }

  onUserCreated(User? user) {
    // TODO: implement onUserCreated
    throw UnimplementedError();
  }
  onEmailAuthException(String rwFirebaseAuthException) {
    // TODO: implement onEmailAuthException
    throw UnimplementedError();
  }
}