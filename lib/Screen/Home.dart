import 'package:face_recognition_with_images/Add/Create.dart';
import 'package:face_recognition_with_images/Add/joinclass.dart';
import 'package:face_recognition_with_images/Admin/Face_reco.dart';
import 'package:face_recognition_with_images/Screen/LoginScreen.dart';
import 'package:face_recognition_with_images/Screen/home_page.dart';
import 'package:face_recognition_with_images/Screen/home_student.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
   final String rollnumber = user!.displayName!.split('(')[1].split(')')[0];
  // print(user!.displayName?.split('(')[1].split(')')[0]);
  print(rollnumber);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          
          backgroundColor: Color.fromARGB(255, 11, 8, 44),
          appBar: AppBar(
            title: Image.asset('assets/logoadd.png', width: 50, height: 50),
            actions: <Widget>[
              PopupMenuButton(
                color: Color.fromARGB(255, 255, 255, 255),
                iconColor: Color.fromARGB(255, 255, 255, 255),
                iconSize: 30,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text("Create classroom"),
                    value: 1,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => create()));
                    },
                  ),
                  PopupMenuItem(
                    child: Text("Join class"),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => joinclass()));
                    },
                    value: 1,
                  ),
                  PopupMenuItem(
                    child: Text("Register Face recognition"),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FcaeReco(rollnumber:rollnumber)));
                    },
                    value: 1,
                  ),
                ],
              ),
            ],
            leading: PopupMenuButton(
              color: Color.fromARGB(255, 255, 255, 255),
              iconColor: Color.fromARGB(255, 255, 255, 255),
              icon: Icon(Icons.person),
              iconSize: 30,
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Column(
                    children: [
                      // user!.photoURL! == true ?
                      CircleAvatar(
                       backgroundImage: NetworkImage(user!.photoURL!),
                        radius: 50,
                      ),
                      // :
                      // IconButton(onPressed: (){}, icon: Icon(Icons.person_2_rounded),iconSize: 70,),
                      Text('Email : ${user?.email}',
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                      Text(
                        'Name : ${(user?.displayName)?.split('(')[0]}',
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      Text(
                        'Roll Number : ${(user?.displayName)?.split('(')[1].split(')')[0]}',
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ],
                  ),
                  value: 1,
                ),
                PopupMenuItem(
                  child: Text("Logout"),
                  onTap: () async{
                  await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
        Fluttertoast.showToast(
        msg: 'Sucessful logout',
      );
                  },
                  value: 1,
                ),
              ],
            ),
            centerTitle: true,
            backgroundColor: Color(0xFF2A3B7F),
            bottom: const TabBar(
              tabs: [
                Tab(
                  // icon: Icon(Icons.home),
                  child: Text('Teacher',style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),
                ),
                Tab(
                  // icon: Icon(Icons.home),
                  child: Text('Student',style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),),),
                ),
                // Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
          ),
          body: 
           const TabBarView(
            children: [
             homepage() ,
              homeStudent()
            ],
          ),
          
          
          ),
        )
    );
  }
}
