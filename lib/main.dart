import 'package:face_recognition_with_images/Screen/LoginScreen.dart';
import 'package:face_recognition_with_images/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


void main() async{

   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);


  runApp(
   MaterialApp(
    debugShowCheckedModeBanner: false,
    home: 
      LoginScreen()
   )
    
    ); 
}
