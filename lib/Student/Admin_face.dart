import 'dart:io';
import 'package:face_recognition_with_images/Face_Recog/ML/Recognition.dart';
import 'package:face_recognition_with_images/Face_Recog/ML/Recognizer.dart';
// import 'package:face_recognition_with_images/Navbar/StudentNav.dart';
// import 'package:face_recognition_with_images/Screen/Home.dart';
import 'package:face_recognition_with_images/Student/Face_Student.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;


class faceAdmin extends StatefulWidget {
  const faceAdmin({Key? key,required this.name,required this.classcode,required this.Admin,required this.isTimerRunning}) : super(key: key);
  final String name;
  final String classcode;
  final String Admin;
  final bool isTimerRunning;
  @override
  State<faceAdmin> createState() => _HomePageState();
}

class _HomePageState extends State<faceAdmin> {
  late ImagePicker imagePicker;
  File? _image;
  User? user = FirebaseAuth.instance.currentUser;

  late FaceDetector faceDetector;

  late Recognizer recognizer;
  bool button = false;
  String facename = "";
  // ImageSource _currentCameraSource = ImageSource.camera;

  @override
  void initState() {
    super.initState();
    // if(widget.isTimerRunning){
    // }
    // else{
    //   Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
      
    // }
    imagePicker = ImagePicker();

    final options = FaceDetectorOptions();
    faceDetector = FaceDetector(options: options);

    recognizer = Recognizer();
  }


  _imgFromCamera() async {
    // if (_currentCameraSource == ImageSource.camera) {
      
    // }
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState((){
        _image = File(pickedFile.path);
        doFaceDetection();

      });
    }
  }

  List<Face> faces = [];
  doFaceDetection() async {
    recognitions.clear();
    _image = await removeRotation(_image!);

    image = await _image?.readAsBytes();
    image = await decodeImageFromList(image);

    InputImage inputImage = InputImage.fromFile(_image!);
    faces = await faceDetector.processImage(inputImage);
    for (Face face in faces) {
      Rect faceRect = face.boundingBox;
      num left = faceRect.left<0?0:faceRect.left;
      num top = faceRect.top<0?0:faceRect.top;
      num right = faceRect.right>image.width?image.width-1:faceRect.right;
      num bottom = faceRect.bottom>image.height?image.height-1:faceRect.bottom;
      num width = right - left;
      num height = bottom - top;

      final bytes = _image!.readAsBytesSync();//await File(cropedFace!.path).readAsBytes();
      img.Image? faceImg = img.decodeImage(bytes!);
      img.Image faceImg2 = img.copyCrop(faceImg!,x:left.toInt(),y:top.toInt(),width:width.toInt(),height:height.toInt());

      Recognition recognition = recognizer.recognize(faceImg2, faceRect);
      recognitions.add(recognition);
      //showFaceRegistrationDialogue(Uint8List.fromList(img.encodePng(faceImg2)), recognition);
    }
    drawRectangleAroundFaces();
    print(recognitions[0].name);
    setState(() {
      button = true;
      facename = recognitions[0].name;
    });
  }

  removeRotation(File inputImage) async {
    final img.Image? capturedImage = img.decodeImage(await File(inputImage!.path).readAsBytes());
    final img.Image orientedImage = img.bakeOrientation(capturedImage!);
    return await File(_image!.path).writeAsBytes(img.encodeJpg(orientedImage));
  }
  var image;
  drawRectangleAroundFaces() async {
    image = await _image?.readAsBytes();
    image = await decodeImageFromList(image);
    print("${image.width}   ${image.height}");
    // print()
    setState(() {
      recognitions;
      image;
      faces;
    });
  }

  List<Recognition> recognitions = [];
  @override
  Widget build(BuildContext context) {
    print(widget.Admin);
    print(facename);
    double screenWidth = MediaQuery.of(context).size.width;
  print(recognitions);
   final String rollnumber = user!.displayName!.split('(')[1].split(')')[0];

    return Scaffold(
       appBar: AppBar(
              title: Text("Faculty's face",style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),
              // centerTitle: true,
              backgroundColor: Color(0xFF2A3B7F),
            ),
      resizeToAvoidBottomInset: false,
      body: 
       Container(
          width: double.infinity,
          height: double.infinity,
          color: Color.fromARGB(255, 11, 8, 44),
        child: 
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          image != null
              ?
          Container(
            margin: const EdgeInsets.only(
                top: 60, left: 30, right: 30, bottom: 0),
            child: FittedBox(
              child: SizedBox(
                width: image.width.toDouble(),
                height: image.width.toDouble(),
                child: CustomPaint(
                  painter: FacePainter(
                      facesList: recognitions, imageFile: image),
                ),
              ),
            ),
          )
              : 
          Container(
            margin: const EdgeInsets.only(top: 100),
            child: Image.asset(
              "images/logo.png",
              width: screenWidth - 100,
              height: screenWidth - 100,
            ),
          ),

          Container(
            height: 50,
          ),

          Container(
            margin: const EdgeInsets.only(bottom: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                !widget.isTimerRunning ? Text('hii') :
            facename == widget.Admin ? 
             ElevatedButton(onPressed: (){
// uploadImageToFirebase();
 Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FaceStudent(name: widget.name,classcode:widget.classcode,isTimerRunning:widget.isTimerRunning)),

                );
            }, child: Text('next'))
             : Text('no face correct')  ,
            !widget.isTimerRunning ? Text('hii') :    Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(200))),
                  child: InkWell(
                    onTap: () {
                      _imgFromCamera();
                    },
                    child: SizedBox(
                      width: screenWidth / 3 - 70,
                      height: screenWidth / 3 - 70,
                      child: Icon(Icons.camera,
                          color: Colors.blue, size: screenWidth / 10),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
     ) );
  }
}

class FacePainter extends CustomPainter {
  List<Recognition> facesList;
    
  dynamic imageFile;
  FacePainter({required this.facesList, @required this.imageFile});
  
  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile, Offset.zero, Paint());
    }

    Paint p = Paint();
    p.color = Colors.red;
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 3;

    for (Recognition rectangle in facesList) {
      canvas.drawRect(rectangle.location, p);
      // print('facer');
      //  print(facesList[0].name);
      TextSpan span = TextSpan(
          style: const TextStyle(color: Color.fromARGB(255, 207, 26, 26), fontSize: 60),
          text: "${rectangle.name}  ");
// ${rectangle.distance.toStringAsFixed(2)}
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(rectangle.location.left, rectangle.location.top));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
