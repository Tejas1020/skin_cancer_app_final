import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:skin_cancer_app_final/Pages/homePage.dart';
import 'package:skin_cancer_app_final/utils/colors_used.dart';
import 'package:skin_cancer_app_final/widgets/Bottom_Sheet_Results.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class Maligant_or_Bengin extends StatefulWidget {
  const Maligant_or_Bengin({Key? key}) : super(key: key);

  @override
  State<Maligant_or_Bengin> createState() => _Maligant_or_BenginState();
}

class _Maligant_or_BenginState extends State<Maligant_or_Bengin> {
  bool _loading = true;
  bool _showLoadingAnimation = false;
  bool _showResult = false; // New variable to track result visibility
  late File _image;
  late List _output;
  final picker = ImagePicker();

  // Get current user's email
  String userEmail = FirebaseAuth.instance.currentUser!.email!;


  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  classifyImage(File image) async {
    setState(() {
      // showing loading animation
      _showLoadingAnimation = true;
    });

    // Upload image to Firebase Storage
    String imageUrl = await uploadImageToFirebase(image, userEmail);

    // Run Model on Image
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    // delaying the results
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _output = output!;
      _loading = false;
      // now hide the loading animation
      _showLoadingAnimation = false;
      _showResult = true; // Set to true when the result is visible
      // _displayBottomSheet();

      // Store the image URL and classification result in Firestore
      storeResultInFirestore(imageUrl, _output, userEmail);
    });
  }

  // Store the Images in Firebase Storage

  Future<String> uploadImageToFirebase(File image, String userEmail) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("images")
        .child('$userEmail')
        .child("${DateTime.now()}.jpg");

    firebase_storage.UploadTask uploadTask = ref.putFile(image);
    firebase_storage.TaskSnapshot snapshot =
        await uploadTask.whenComplete(() {});

    return await snapshot.ref.getDownloadURL();
  }

  void storeResultInFirestore(String imageUrl, List output, String userEmail) {
    // Store image URL and classification result in Firestore
    FirebaseFirestore.instance.collection('results').add({
      'imageUrl': imageUrl,
      'output': output,
      'userEmail': userEmail,
      'timestamp': FieldValue.serverTimestamp(),
    }).then((value) {
      print("Result stored successfully!");
    }).catchError((error) {
      print("Failed to store result: $error");
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/model/maligant_vs_bengin.tflite",
        labels: "assets/model/labels.txt");
  }

  pickGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image);
  }

  pickCameraImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: AppColors.paleOffWhite,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: height / 3,
              decoration: BoxDecoration(
                color: AppColors.mediumBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
                image: DecorationImage(
                  image: AssetImage("assets/img/leather.jpg"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4),
                    BlendMode.dstATop,
                  ),
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent,
                      leading: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 214, 213, 213),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewHomePage(),
                              ),
                            );
                          },
                          icon: Icon(Icons.home),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15, bottom: 40),
                      child: Text(
                        "Skin Cancer Detection",
                        style: GoogleFonts.raleway(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 30,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                    backgroundColor: Colors.white,
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: 400,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Divider(
                                color: Colors.grey,
                                thickness: 2.2,
                                indent: 130,
                                endIndent: 130,
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.close_outlined),
                                  ),
                                ],
                              ),
                              SafeArea(
                                minimum: EdgeInsets.all(10),
                                child: Text(
                                  "This is the Final Stage for Detecting Skin Cancer and after reaching here means your image is a perfect skin image and now our AI Will detect wether it is Maligant(Cancerous) or Bengin(Non Cancerous) Spot and a Meter will Indicate how Confident our Artifical Intelligence is About. But Still after this Consult to a Doctor",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
              icon: Icon(Icons.info_outline_rounded),
            ),
            SizedBox(
              height: width / 8,
            ),
            Center(
              child: _showLoadingAnimation
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    )
                  : _loading
                      ? Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //
                              Material(
                                elevation: 1.8,
                                borderRadius: BorderRadius.circular(25),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                  width:
                                      MediaQuery.of(context).size.width / 1.3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    image: DecorationImage(
                                      image:
                                          AssetImage("assets/img/sample.jpg"),
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                        Colors.black.withOpacity(0.3),
                                        BlendMode.dstATop,
                                      ),
                                    ),
                                    gradient: const LinearGradient(
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                      colors: [
                                        Color.fromARGB(255, 2, 3, 68),
                                        Color.fromARGB(255, 25, 176, 236),
                                      ],
                                    ),
                                  ),
                                  child: Lottie.asset("assets/anim/scan.json"),
                                ),
                              ),
                              const SizedBox(height: 50),
                            ],
                          ),
                        )
                      : Container(
                          child: Column(
                            children: [
                              Container(
                                height: 250,
                                width: 250,
                                child: Image.file(_image),
                              ),
                              const SizedBox(height: 20),
                              // ignore: unnecessary_null_comparison
                              _output != null
                                  // Bottom Sheet Result
                                  ? BottomSheetResult(output: _output)
                                  : Container(),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!_showResult) // Only show the button if the result is not visible
                  GestureDetector(
                    onTap: pickGalleryImage,
                    child: Material(
                      elevation: 1.8,
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: AppColors.powderBlue,
                        ),
                        child: Text(
                          "Pick the Same Image",
                          style: GoogleFonts.roboto(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
