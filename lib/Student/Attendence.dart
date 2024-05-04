import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class attendence extends StatefulWidget {
  const attendence({Key? key,required this.classinfo,required this.name}) : super(key:key);
  final classinfo;
  final String name;

  @override
  State<attendence> createState() => _attendenceState();
}
class ImageData {
  late final String imageURL;
  late final String time;
  ImageData({required this.imageURL, required this.time});
}
class _attendenceState extends State<attendence> {
   List<dynamic>  downloadURL = [];
     List<dynamic> listdownloadURL = [];
     List<ImageData> imagesList = [];
    final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
  
    super.initState();
fetchImage ();
  }

  fetchImage ()async{
    final storageRef = FirebaseStorage.instance.ref().child('${widget.classinfo['classcode']}/${widget.name}');
     ListResult result = await storageRef.listAll();
    for (final item in result.items) {
      String imageURL = await item.getDownloadURL();
      String time =item.fullPath.split('/').last;
      listdownloadURL.add(imageURL);
      imagesList.add(ImageData(imageURL: imageURL, time: time));

    }
    setState(() {
      listdownloadURL;
      imagesList;
    });
    
  }
  @override
  Widget build(BuildContext context) {
    return 
    imagesList.length == 0?
     Container(
      child:Center(child:CircularProgressIndicator()) ,
    ):
    Container(
    //   child: Image.network(imagesList[0].imageURL),
    child: ListView.builder(
      itemCount: imagesList.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Color(0xFF6E77BA),
            ),
          child: Row(
            children: [
              Image.network(imagesList[index].imageURL,width: 100,height: 100,),
              Column(
                children: [

              Text(imagesList[index].time),
              Text('present',style: TextStyle(color: Colors.green),),
              Text(user!.displayName.toString(),style: TextStyle(color: Colors.green),),

                ],
              )
            ]
          )
        );
      }
    ));
  }
}