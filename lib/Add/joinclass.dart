// import 'package:app/Screen/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class joinclass extends StatefulWidget {
  const joinclass({super.key});

  @override
  State<joinclass> createState() => _joinclassState();
}

class _joinclassState extends State<joinclass> {
  final TextEditingController classCodeController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  Future<void> _joinclass() async {
    String classCode = classCodeController.text;
    if (classCode.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Enter Class Code',
      );
    }
    try {
      final QuerySnapshot q =
          await FirebaseFirestore.instance.collection("Classes").get();

      final classroomDocs =
          q.docs.where((doc) => doc['classcode'] == classCode).toList();
      final classDoc = classroomDocs[0];

      await classDoc.reference.collection("students").add({
        'uid': user!.uid,
        'created_at': DateTime.now().toIso8601String(),
        'name': user!.displayName,
        'classcode': classCode
      });

      classCodeController.clear();
      Fluttertoast.showToast(
        msg: 'Successfully joined',
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'somthing wrong',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 11, 8, 44),
        appBar: AppBar(
          title: const Text(
            'Join Class',
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
          backgroundColor: Color(0xFF2A3B7F),
        ),
        body: Container(
            margin: EdgeInsets.only(top: 40, left: 30, right: 30, bottom: 0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 350,
                  child: TextField(
                    maxLength: 6,
                    style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.w300),
                    controller: classCodeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      // icon: Icon(Icons.code_rounded, color: const Color.fromARGB(255, 255, 255, 255)),
                      labelText: 'Class Code',
                      labelStyle: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ),
                OutlinedButton(
                    onPressed: _joinclass,
                    child: Text(
                      'Join',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ))
              ],
            )));
  }
}
