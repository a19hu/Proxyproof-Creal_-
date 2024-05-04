import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_recognition_with_images/Navbar/AdminNav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  User? user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> classData = [];
  List<Map<String, dynamic>> StudentData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  
  Future<void> fetchData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Classes')
            .where('uid', isEqualTo: user.uid)
            .get();
        List<Map<String, dynamic>> data = querySnapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
            .toList();
        setState(() {
          classData = data;
        });
      } else {
        print('User is null');
      }
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(
        msg: 'Something wrong check internet connection',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
  // print(classData);
    return 
    Container(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          child: classData.isEmpty && StudentData.isEmpty
              ? Center(
                  child: Column(
                  children: [
                    Text(
                      'No classes',
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ],
                ))
              : Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                            itemCount: classData.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AdminNav(
                                              classinfo: classData[index]),
                                          settings: RouteSettings(
                                            arguments: classData[index],
                                          ),
                                        ));
                                  },
                                  child: Container(
                                      margin: EdgeInsets.all(10),
                                      padding: EdgeInsets.all(10),
                                      // height: 120,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        image: DecorationImage(
                                          image: AssetImage('assets/back.png'),
                                          fit: BoxFit.fill,
                                        ),
                                        color: Color(0xFF6E77BA),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            classData[index]['course_name'],
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            classData[index]['class_name'],
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            classData[index]['name'],
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255)),
                                          ),
                                        ],
                                      )));
                            })),
                  ],
                ),
        )
        );
  }
}
