

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

//Phương thức đăng nhập bằng tài khoản Google
Future<UserCredential> signWithGoogle()async{
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken
  );
  return FirebaseAuth.instance.signInWithCredential(credential);
}

//Phương thức đăng ký tài khoản Email, password
Future<UserCredential> registerEmailPassword({
  required String email,
  required String password
}){
  try{
    return FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password);
  }on FirebaseAuthException catch(e){
    return Future.error(e.code);
  }
}

//Phương thức hỗ đăng nhập bằng Email, password
Future<UserCredential> signWithEmailPassword({
  required String email,
  required String password
}) async{
  try{
    var userCredential = await FirebaseAuth.instance.
          signInWithEmailAndPassword(email: email, password: password);
    return userCredential;
  }on FirebaseAuthException catch(e){
    return Future.error(e.code);
  }
}

