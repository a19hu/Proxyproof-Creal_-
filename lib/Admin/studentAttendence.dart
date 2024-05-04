import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class studentattendence extends StatefulWidget {
  const studentattendence({Key? key, required this.classinfo}) : super(key: key);

   final classinfo;

  @override
  State<studentattendence> createState() => _studentattendenceState();
}
class ImageData {
  late final String imageURL;
  late final String time;
  late final String name;
  ImageData({required this.imageURL, required this.time, required this.name});
}

class _studentattendenceState extends State<studentattendence> {
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
    final storageRefs = FirebaseStorage.instance.ref().child('${widget.classinfo['classcode']}');
     ListResult results = await storageRefs.listAll();
    // List<Reference> result = results.prefixes;

    // Print the list of folders
     for (final folder in results.prefixes) {
        final subFolderRef = FirebaseStorage.instance.ref().child(folder.fullPath);
        print('Folder name: ${folder.fullPath.split('/').last}');
        ListResult subFolderResult = await subFolderRef.listAll();
    // folders.forEach((folderRef) async {
      // print('Folder name: ${folderRef.name}');
      // final storageRef = FirebaseStorage.instance.ref().child(folderRef.name);
    //  ListResult result = await storageRef.listAll();
    for (final item in subFolderResult.items) {
      String imageURL = await item.getDownloadURL();
      print(imageURL);
      String time =item.fullPath.split('/').last;
      print(time);
      listdownloadURL.add(imageURL);
      imagesList.add(ImageData(imageURL: imageURL, time: time,name:folder.fullPath.split('/').last));
     print(imagesList[0].imageURL);
    }}
    // });
    setState(() {
      listdownloadURL;
      imagesList;
    });
    print(imagesList.length);
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
              Text(imagesList[index].name,style: TextStyle(color: Colors.green),),

                ],
              )
            ]
          )
        );
      }
    ));
  }
}