import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class message extends StatefulWidget {
  const message({Key? key, required this.classcode}) : super(key: key);


   final String classcode;
  @override
  State<message> createState() => _messageState();
}

class _messageState extends State<message> {
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
        .collection(classdoc.reference.path + '/message')
        .where('Classcode', isEqualTo: widget.classcode)
        .get();
    
    List<DocumentSnapshot> studentDocuments = studentSnapshot.docs;
    data.addAll(studentDocuments.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}));
  }

  setState(() {
    StudentData = data;
  });
  print(StudentData);
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(
               msg: 'Something wrong check internet connection',
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
              title: Text('Announcements',style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),
              backgroundColor: Color(0xFF2A3B7F),
            ),
            body:  Container(
              width: double.infinity,
        height: double.infinity,
        color: Color.fromARGB(255, 11, 8, 44),
            // margin: EdgeInsets.only(top: 40, left: 30, right: 30, bottom: 0),
            child: 
            Container(
              margin: EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 0),
              child: 
             StudentData.isEmpty
              ? Center(
                  child: Column(
                  children: [
                    Text(
                      'No Announcements Found',
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ],
                ))
              : Column(
              children: [
                 Expanded(child: 
                 ListView.builder(
                   itemCount: StudentData.length,
                   itemBuilder: (context, index) {
                     return Container(
                       margin: EdgeInsets.all(5),
                                      padding: EdgeInsets.only(left: 25,top: 10,right: 20),
                                      height: 40,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        color: Color(0xFF6E77BA),
                                      ),
                       child: 
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                       Text(StudentData[index]['message'],style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),
                        Text(
                  ' ${(StudentData[index]['created_at']).split('T')[0]},${(StudentData[index]['created_at']).split('T')[1].split('.')[0]}',
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                ),
                        ],
                       )
                     );
                   }
                 )
                 )
              ],
            ) 
            )
             
                    )
    );
  }
}