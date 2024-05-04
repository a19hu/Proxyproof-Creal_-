import 'package:face_recognition_with_images/Admin/Courcedetail.dart';
// import 'package:face_recognition_with_images/Admin/Face_reco.dart';
import 'package:face_recognition_with_images/Admin/studentAttendence.dart';
import 'package:face_recognition_with_images/Admin/studentlist.dart';
import 'package:face_recognition_with_images/Screen/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class AdminNav extends StatefulWidget {
  const AdminNav({Key? key, required this.classinfo}) : super(key: key);

  final classinfo;

  @override
  State<AdminNav> createState() => _AdminNavState();
}

class _AdminNavState extends State<AdminNav> {
  User? user = FirebaseAuth.instance.currentUser;
  late final classinfos = widget.classinfo;
  int pageIndex = 0;
    bool isHTML = false;
   final _recipientController = TextEditingController(
    text: 'example@example.com',
  );

  Future<void> send() async {
    final Email email = Email(
      body: 'Join our class! ${widget.classinfo['class_name']}- Google Classroom code-${widget.classinfo['classcode']} ',
      subject: 'Invitation to join classroom',
      recipients: [_recipientController.text],
      isHTML: isHTML,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      print(error);
      platformResponse = error.toString();
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Color.fromARGB(255, 11, 8, 44),
            appBar: AppBar(
              title: Image.asset('assets/logoadd.png', width: 50, height: 50),
              centerTitle: true,
              backgroundColor: Color(0xFF2A3B7F),
            ),
            floatingActionButton: Column(
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
    
    FloatingActionButton(
      elevation: 10.0,
      child: const Icon(Icons.person_add),
      onPressed: () {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => Dialog(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Invite a Student',style: TextStyle(fontSize: 20),),
                    SizedBox(height: 10,),
                    Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _recipientController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
                    const SizedBox(height: 15),
                    OutlinedButton(
                      onPressed: () {
                        send();
                      },
                      child: const Text('Email'),
                    ),
                  ],
                ),
              ),
        ));
      },
    ),
  ],
),

            bottomNavigationBar: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Color(0xFF2A3B7F),
                // borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Text('${widget.classinfo.email}',style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),
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
                            color: Color.fromARGB(255, 255, 255, 255),
                            size: 35,
                          )
                        : const Icon(
                            Icons.home_outlined,
                            color: Color.fromARGB(255, 255, 255, 255),
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
                            Icons.insert_invitation,
                            color: Color.fromARGB(255, 255, 255, 255),
                            size: 35,
                          )
                        : const Icon(
                            Icons.insert_invitation_outlined,
                            color: Color.fromARGB(255, 255, 255, 255),
                            size: 35,
                          ),
                  ),
                  IconButton(
                    enableFeedback: false,
                    onPressed: () {
                      setState(() {
                        pageIndex = 2;
                      });
                    },
                    icon: pageIndex == 2
                        ? const Icon(
                            Icons.group_add_rounded,
                            color: Color.fromARGB(255, 255, 255, 255),
                            size: 35,
                          )
                        : const Icon(
                            Icons.group_add_outlined,
                            color: Color.fromARGB(255, 255, 255, 255),
                            size: 35,
                          ),
                  ),
                ],
              ),
            ),
            body: (() {
              if (pageIndex == 0) {
                return coursedetails(classinfo: classinfos);
              } else if (pageIndex == 1) {
                return studentattendence(classinfo: classinfos);
              } else if (pageIndex == 2) {
                return studentlist(classinfo: classinfos);
              } else {
                // coursedetails(classinfo: classinfos);
                return studentlist(classinfo: classinfos);
              }
            })()));
  }
}
