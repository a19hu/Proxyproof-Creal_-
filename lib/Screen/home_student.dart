import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_recognition_with_images/Navbar/StudentNav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class homeStudent extends StatefulWidget {
  const homeStudent({super.key});

  @override
  State<homeStudent> createState() => _homeStudentState();
}

class _homeStudentState extends State<homeStudent> {
   User? user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> classData = [];
  List<Map<String, dynamic>> StudentData = [];

  @override
  void initState() {
    super.initState();
    fetchStudentData();
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
        .where('uid', isEqualTo: user?.uid)
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

 

  @override
  Widget build(BuildContext context) {
    print(StudentData);
    return 
    Container(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          child: StudentData.isEmpty
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
                        flex: 1,
                        child: ListView.builder(
                            itemCount: StudentData.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Studentnav(
                                              classinfo: StudentData[index]),
                                          settings: RouteSettings(
                                            arguments: StudentData[index],
                                          ),
                                        ));
                                  },
                                  child: Container(
                                      margin: EdgeInsets.all(10),
                                      padding: EdgeInsets.all(10),
                                      height: 120,
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
                                            StudentData[index]['course_name'],
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
                                            StudentData[index]['class_name'],
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
                                            StudentData[index]['name'],
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
