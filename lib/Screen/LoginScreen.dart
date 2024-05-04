import 'package:face_recognition_with_images/fire_function.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    
    return 
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
      backgroundColor: Color.fromARGB(255, 11, 8, 44),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/back.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              // margin: const EdgeInsets.all(150),
              margin: const EdgeInsets.only(top: 200.0),
              child: Column(
                children: [
                    Image.asset(
                    'assets/logoadd.png',
                    width: 130,
                    height: 100,
                  ),
                        Text(
                    'Welcome to',
                    style: TextStyle(
                      color: Color.fromARGB(255, 230, 229, 229),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                      Text(
                    'CReal',
                    style: TextStyle(
                      color: Color.fromARGB(255, 230, 229, 229),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              )
            ),
            Container(
              margin: const EdgeInsets.only(top: 200.0),
              padding: EdgeInsets.all(20),
              child: 
              ElevatedButton(
               child: Text(
                "Login with Google",
                style: TextStyle(
                  color: Color.fromRGBO(23, 156, 82, 1),
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                  height: 2,

                ),
              ),
              onPressed: () {
                  FirebaseService.signInwithGoogle(context);
              },
            ),
            )
          ],
        ),
      ),
    )
    );
    
  }
}


// Color(0xFF6E77BA),

//  Color(0xFF2A3B7F),