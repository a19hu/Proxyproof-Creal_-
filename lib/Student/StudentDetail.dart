import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentDetails extends StatefulWidget {
  const StudentDetails({Key? key, required this.classinfo}) : super(key: key);
  final classinfo;
  @override
  State<StudentDetails> createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  Map<String, dynamic> timerData = {};
  int remainingTime = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
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
        // int remainingTime = calculateRemainingTime();

    return Container(
        child: Container(
            width: double.infinity,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              image: DecorationImage(
                image: AssetImage('assets/back.png'),
                fit: BoxFit.fill,
              ),
              color: Color(0xFF6E77BA),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.classinfo['course_name'],
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.classinfo['class_name'],
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.classinfo['name'],
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Created on : ${(widget.classinfo['created_at']).split('T')[0]}',
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                ),
                Text(
          'Time Remaining: ${Duration(milliseconds: remainingTime).toString().split('.')[0]}',
          style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 115, 40, 40)),
        ),
              ],
            )));
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
