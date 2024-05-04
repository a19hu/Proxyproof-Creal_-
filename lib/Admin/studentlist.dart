import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class studentlist extends StatefulWidget {
  const studentlist({Key? key, required this.classinfo}) : super(key: key);

   final classinfo;

  @override
  State<studentlist> createState() => _studentlistState();
}

class _studentlistState extends State<studentlist> {
   List<String> attachments = [];
  List<Map<String, dynamic>> StudentData = [];

  
   @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Classes').where('classcode',isEqualTo: widget.classinfo['classcode']).get();
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
List<Map<String, dynamic>> data=[];
      for (QueryDocumentSnapshot classdoc in documents) {
    QuerySnapshot studentSnapshot = await FirebaseFirestore.instance
        .collection(classdoc.reference.path + '/students')
        .get();
    
    List<DocumentSnapshot> studentDocuments = studentSnapshot.docs;
    data.addAll(studentDocuments.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}));
  }
  print(data);
  setState(() {
    StudentData = data;
  });

    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(
        msg: 'Something wrong',
        
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      'No Student Found',
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ],
                ))
              : Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                            itemCount: StudentData.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  child: Container(
                                      margin: EdgeInsets.all(10),
                                      padding: EdgeInsets.only(left: 25,top: 10),
                                      height: 40,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        color: Color(0xFF6E77BA),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon( Icons.person,color: Color.fromARGB(
                                                    255, 255, 255, 255),size: 25,),
                                          SizedBox(
                                            width: 10,
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