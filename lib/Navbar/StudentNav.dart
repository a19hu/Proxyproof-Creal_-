import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_recognition_with_images/Admin/Face_reco.dart';
import 'package:face_recognition_with_images/Screen/message.dart';
import 'package:face_recognition_with_images/Student/Admin_face.dart';
import 'package:face_recognition_with_images/Student/Attendence.dart';
import 'package:face_recognition_with_images/Student/StudentDetail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Studentnav extends StatefulWidget {
  const Studentnav({Key? key, required this.classinfo}) : super(key: key);

  final classinfo;

  @override
  State<Studentnav> createState() => _StudentnavState();
}

class _StudentnavState extends State<Studentnav> {
  User? user = FirebaseAuth.instance.currentUser;
  late final classinfos = widget.classinfo;
  int pageIndex = 0;
  Map<String, dynamic> timerData = {};
  int remainingTime = 0;
  late Timer _timer;
  bool isTimerRunning = false;
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
    if (Duration(milliseconds: remainingTime).toString().split('.')[0]  == '0:00:00') {
      setState(() {
        isTimerRunning =false;
      });
    }
    else {
      setState(() {
        isTimerRunning =true;
        
      });
    }
    });
    fetchData();
    _timer= Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        remainingTime = calculateRemainingTime();
      });
    });
  }
   @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  fetchData() async {
     try {
       final QuerySnapshot q = await FirebaseFirestore.instance.collection("Classes").get();

    final classroomDocs = q.docs.where((doc) => doc['classcode'] == widget.classinfo['classcode']).toList();
    if (classroomDocs.isNotEmpty) {
      final classDoc = classroomDocs[0];

      final timerDoc = await classDoc.reference.collection("timer").doc('admin_controlled_timer').get();

      if (timerDoc.exists) {
        print(timerDoc.data());
         setState(() {
            timerData = timerDoc.data() as Map<String, dynamic>;
          });
        // return timerDoc.data() as Map<String, dynamic>;
      } else {
        print('Timer document does not exist.');
        return {};
      }
    } else {
      print('Class document does not exist.');
      return {};
    }
     } catch (e) {
       print('Error: $e');
     }
  } 
  @override
  Widget build(BuildContext context) {
    String? displayName = user!.displayName;
    String name = user!.displayName!.split('(')[1].split(')')[0];
    String Adminname= widget.classinfo['name'].split('(')[1].split(')')[0];
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Color.fromARGB(255, 11, 8, 44),
            appBar: AppBar(
              title: Image.asset('assets/logoadd.png', width: 50, height: 50),
              centerTitle: true,
              backgroundColor: Color(0xFF2A3B7F),
            ),
            floatingActionButton:
            Column(
  mainAxisAlignment: MainAxisAlignment.end,
  crossAxisAlignment: CrossAxisAlignment.end,
  children: [
    FloatingActionButton(
      elevation: 10.0,
      child: const Icon(Icons.message),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => message(classcode: widget.classinfo['classcode'])),
        );
      },
    ),
    
    SizedBox(height: 16),
     Duration(milliseconds: remainingTime).toString().split('.')[0]  == '0:00:00'
            ?
            FloatingActionButton(
              elevation: 10.0,
              onPressed: () { 
                Fluttertoast.showToast(
        msg: 'Attendance is not live',
        
      );
               },
              child: const Icon(Icons.stop),
            ):
             FloatingActionButton(
              elevation: 10.0,
              backgroundColor: Color.fromARGB(255, 255, 0, 0),
              child: const Icon(Icons.circle,color: Color.fromARGB(255, 255, 255, 255),),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      // builder: (context) => FaceStudent(name: name[0],classcode:widget.classinfo['classcode'])),
                      builder: (context) => faceAdmin(name: name,classcode:widget.classinfo['classcode'],Admin:Adminname,isTimerRunning:isTimerRunning)),

                );
              },
            )
         
    ])
            ,
            bottomNavigationBar: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Color(0xFF2A3B7F),
                // borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    enableFeedback: false,
                    onPressed: () {
                      setState(() {
                        pageIndex = 0;
                      });
                    },
                    icon: pageIndex == 0
                        ? const Icon(
                            Icons.home_filled,
                            color: Color(0xFF6E77BA),
                            size: 35,
                          )
                        : const Icon(
                            Icons.home_outlined,
                            color: Color(0xFF6E77BA),
                            size: 35,
                          ),
                  ),
                  IconButton(
                    enableFeedback: false,
                    onPressed: () {
                      setState(() {
                        pageIndex = 1;
                      });
                    },
                    icon: pageIndex == 1
                        ? const Icon(
                            Icons.list_alt,
                            color: Color(0xFF6E77BA),
                            size: 35,
                          )
                        : const Icon(
                            Icons.list_outlined,
                            color: Color(0xFF6E77BA),
                            size: 35,
                          ),
                  ),
                ],
              ),
            ),
            body: (() {
              if (pageIndex == 0) {
                return StudentDetails(classinfo: classinfos);
              } else if (pageIndex == 1) {
                return attendence(classinfo: classinfos,name: name[0]);
              }
            })()));
  }
  int calculateRemainingTime() {
    if (timerData.containsKey('startTime') && timerData.containsKey('duration')) {
      Timestamp startTime = timerData['startTime'];
      int duration = timerData['duration'];
      int elapsedTime = DateTime.now().difference(startTime.toDate()).inMilliseconds;
      int remainingTime = duration - elapsedTime;
      return remainingTime > 0 ? remainingTime : 0;
    } else {
      return 0;
    }
  }
}
