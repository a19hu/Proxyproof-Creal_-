
// import 'package:app/Screen/Home.dart';
import 'package:face_recognition_with_images/Screen/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
 static final FirebaseAuth _auth = FirebaseAuth.instance;
 static final GoogleSignIn _googleSignIn = GoogleSignIn();

 static Future<String?> signInwithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);
      // Navigator.push(context, MaterialPageRoute(builder: (context) =>Home()));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));

    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      throw e;
    }
    // try {
    //   final GoogleSignInAccount? googleSignInAccount =
    //       await _googleSignIn.signIn();
    //   if (googleSignInAccount != null) {
    //     final GoogleSignInAuthentication googleSignInAuthentication =
    //         await googleSignInAccount.authentication;
    //     final AuthCredential credential = GoogleAuthProvider.credential(
    //       accessToken: googleSignInAuthentication.accessToken,
    //       idToken: googleSignInAuthentication.idToken,
    //     );
    //     await _auth.signInWithCredential(credential);
    //     Navigator.pushReplacement(
    //         context, MaterialPageRoute(builder: (context) => Home()));
    //   } else {
    //     print('Google sign in failed');
    //   }
    // } on FirebaseAuthException catch (e) {
    //   print('Failed with error code: ${e.code}');
    //   throw e;
    // }
    
  }

  Future<void> signOutFromGoogle() async{
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
