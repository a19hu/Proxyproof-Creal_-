import 'package:face_recognition_with_images/Face_Recog/RecognitionScreen.dart';
import 'package:face_recognition_with_images/Face_Recog/RegistrationScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FcaeReco extends StatefulWidget {
  const FcaeReco({Key? key, required this.rollnumber}) : super(key: key);
   final String rollnumber;
  @override
  State<FcaeReco> createState() => _FcaeRecoState();
}

class _FcaeRecoState extends State<FcaeReco> {
  @override
  Widget build(BuildContext context) {
  final String rollnumbers= widget.rollnumber;

    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
              title: Image.asset('assets/logoadd.png', width: 50, height: 50),
              centerTitle: true,
              backgroundColor: Color(0xFF2A3B7F),
            ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Color.fromARGB(255, 11, 8, 44),
        child: 
        Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
          Container(margin: const EdgeInsets.only(top: 80),child: Image.asset("images/logo.png",width: screenWidth-40,height: screenWidth-40,)),
          Container(
            margin: const EdgeInsets.only(bottom: 50),

            child: Column(
              children: [
                ElevatedButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> RegistrationScreen(rollnumber:rollnumbers)));
                },
                  style: ElevatedButton.styleFrom(minimumSize: Size(screenWidth-30, 50)), child: const Text("Register"),),
                Container(height: 20,),
                ElevatedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const RecognitionScreen()));
                },
                  style: ElevatedButton.styleFrom(minimumSize: Size(screenWidth-30, 50)), child: const Text("Recognize"),),
              ],
            ),

          )
          ]
        )
        )
    );
  }
}