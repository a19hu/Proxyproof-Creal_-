import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class coursedetails extends StatefulWidget {
  const coursedetails({Key? key, required this.classinfo}) : super(key: key);
   
   final classinfo;
  @override
  State<coursedetails> createState() => _coursedetailsState();
}



class _coursedetailsState extends State<coursedetails> {
   final TextEditingController messageController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> StudentData = [];
 int remainingTime = 0;
  Map<String, dynamic> timerData = {};

  late Timer _timer;

  timer() async{
    try{
        
        final QuerySnapshot q =
          await FirebaseFirestore.instance.collection("Classes").get();

      final classroomDocs =
          q.docs.where((doc) => doc['classcode'] == widget.classinfo['classcode']).toList();
      final classDoc = classroomDocs[0];
 
    await classDoc.reference.collection("timer").doc('admin_controlled_timer').set({
        'startTime': DateTime.now(),
        'duration': Duration(minutes: 2).inMilliseconds,
      });
  
    }catch(e){
      print(e);
    }
}


  @override
  void initState() {
    super.initState();
    fetchStudentData();
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
Future<void> fetchStudentData() async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Classes').get();
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
List<Map<String, dynamic>> data=[];
      for (QueryDocumentSnapshot classdoc in documents) {
    QuerySnapshot studentSnapshot = await FirebaseFirestore.instance
        .collection(classdoc.reference.path + '/students')
        .where('Classcode', isEqualTo: widget.classinfo['classcode'])
        .get();
    
    List<DocumentSnapshot> studentDocuments = studentSnapshot.docs;
    data.addAll(studentDocuments.map((doc) => {'id': classdoc.id, ...classdoc.data() as Map<String, dynamic>}));
  }

  setState(() {
    StudentData = data;
  });
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(
               msg: 'Something wrong check internet connection',
      );
    }
  }

Future<void> _messagesend() async {
    String message = messageController.text;
    if (message.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Enter Some Message',
      );
      return null;
    }
    try {
      final QuerySnapshot q =
          await FirebaseFirestore.instance.collection("Classes").get();

      final classroomDocs =
          q.docs.where((doc) => doc['classcode'] == widget.classinfo['classcode']).toList();
      final classDoc = classroomDocs[0];

      await classDoc.reference.collection("message").add({
        // 'uid': user!.uid,
        'created_at': DateTime.now().toIso8601String(),
        // 'name': user!.displayName,
        'message': message,
        'Classcode': widget.classinfo['classcode']

      });

      messageController.clear();
      Fluttertoast.showToast(
        msg: 'Successfully joined',
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'somthing wrong',
      );
    }
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
    // print(widget.classinfo);
    return 
    Column(
      children: [
Container(
        child: Container(
            width: double.infinity,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            height: 220,
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
                  'Created on : ${(widget.classinfo['created_at']).split('T')[0]}',
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
   children: [
ElevatedButton(onPressed: (){
                  timer();
                  Fluttertoast.showToast(
                msg: 'your time start'
              );
                }, child: Text('Start Attendance')),
                ElevatedButton(
            onPressed: () {
              Clipboard.setData(new ClipboardData(text: widget.classinfo['classcode']));
              
            },
            child: const Text('Copy Classcode'),
          ),
   ],
                ),
               Text(
          'Time Remaining: ${Duration(milliseconds: remainingTime).toString().split('.')[0]}',
          style: TextStyle(fontSize: 24,color: Color.fromARGB(255, 92, 43, 43)),
        ), 
                
              ],
            ))),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                  width: 300,
                  child: TextField(
                    style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.w300),
                    controller: messageController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      // icon: Icon(Icons.code_rounded, color: const Color.fromARGB(255, 255, 255, 255)),
                      labelText: 'Announcement',
                      labelStyle: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ),
                OutlinedButton(
                    onPressed: _messagesend,
                    child: Text(
                      'Send',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    )),
                    
                  
                ],
              ),
            ),
           
      ],
    );
    
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


