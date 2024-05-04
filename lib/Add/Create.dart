import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class create extends StatefulWidget {
  const create({super.key});

  @override
  State<create> createState() => _createState();
}

class _createState extends State<create> {
  User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController classNameController = TextEditingController();

  _createRecord() async {
    try {
      await FirebaseFirestore.instance.collection('Classes').add({
        'course_name': courseNameController.text,
        'class_name': classNameController.text,
        'uid': user!.uid,
        'created_at': DateTime.now().toIso8601String(),
        'name': user!.displayName,
        'classcode': Generateclasscode()
      });
      courseNameController.clear();
      classNameController.clear();
      Fluttertoast.showToast(
        msg: 'Successfully Created classroom',
      );
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => homepage()));
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Connect error',
      );
    }
  }

  String Generateclasscode() {
    final characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final codelength = 6;
    final random = Random();
    String classcode = '';
    for (var i = 0; i < codelength; i++) {
      final randomindex = random.nextInt(characters.length);
      classcode += characters[randomindex];
    }
    return classcode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 11, 8, 44),
        appBar: AppBar(
          title: const Text(
            'Create Classroom',
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
          backgroundColor: Color(0xFF2A3B7F),
        ),
        body: Container(
            margin: EdgeInsets.only(top: 40, left: 30, right: 30, bottom: 0),
            child: Column(
              children: [
                SizedBox(
                  width: 350,
                  child: TextField(
                    style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.w300),
                    controller: courseNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      // icon: Icon(Icons.code_rounded, color: const Color.fromARGB(255, 255, 255, 255)),
                      labelText: 'Course Name',
                      labelStyle: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 17,
                ),
                SizedBox(
                  width: 350,
                  child: TextField(
                    style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.w300),
                    controller: classNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      // icon: Icon(Icons.code_rounded, color: const Color.fromARGB(255, 255, 255, 255)),
                      labelText: 'Course code',
                      labelStyle: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 17,
                ),
                OutlinedButton(
                    onPressed: _createRecord,
                    child: Text(
                      'Create Classroom',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    )),
              ],
            )));
  }
}
