import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:skin_cancer_app_final/Pages/maligant_not_scanner.dart';
import 'package:skin_cancer_app_final/utils/colors_used.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  bool _loading = true;
  bool _showLoadingAnimation = false;
  late File _image;
  late List _output;
  final picker = ImagePicker();

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
    });

    if (_output.isNotEmpty) {
      if (_output[0]['label'] == 'No Skin') {
        // Show a dialog when 'no skin' is detected
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Not a Proper Skin Image'),
              content: const Text(
                  'The image does not appear to be a skin. So please upload an image without blur or any noise.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Maligant_or_Bengin(),
          ),
        );
      }
    }
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/model/skin_noskin.tflite",
        labels: "assets/model/skin_noskin.txt");
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
                    Colors.black.withOpacity(0.2),
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
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.arrow_back_rounded),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15, bottom: 40),
                      child: Text(
                        "Skin Cancer Detection Stage 1",
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
                                  "In This Stage we are Detecting wether the Given Image is Skin Image or Not as the Bad Images can Predict the False Results but images Passed from this stage will help our AI Model to Predict the Results Accurately and help the Patients to get the Best results. ",
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
                              const SizedBox(height: 30),
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
                                  ? Text(
                                      '${_output[0]['label']}',
                                      style: GoogleFonts.poppins(
                                          color: Colors.black, fontSize: 20),
                                    )
                                  : Container(),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                        "Pick the Image",
                        style: GoogleFonts.roboto(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                // GestureDetector(
                //   onTap: pickCameraImage,
                //   child: Material(
                //     elevation: 1.8,
                //     borderRadius: BorderRadius.circular(18),
                //     child: Container(
                //       padding: EdgeInsets.all(20),
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(18),
                //         color: const Color.fromARGB(255, 64, 115, 255),
                //       ),
                //       child: Text(
                //         "Click a Photo",
                //         style: GoogleFonts.roboto(color: Colors.white),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
