import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_cancer_app_final/Pages/Archive_data.dart';
import 'package:skin_cancer_app_final/Pages/guide.dart';
import 'package:skin_cancer_app_final/Pages/skin_or_not.dart';
import 'package:skin_cancer_app_final/utils/colors_used.dart';
import 'package:skin_cancer_app_final/widgets/Diseases_tile.dart';
import 'package:skin_cancer_app_final/widgets/home_page_top_bar.dart';

class NewHomePage extends StatefulWidget {
  const NewHomePage({super.key});

  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height / 2.8,
              decoration: BoxDecoration(
                // color: Colors.grey.shade300,
                color: AppColors.navy,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
                border: const Border(
                  bottom: BorderSide(
                    color: AppColors.brownShade,
                    width: 8,
                  ),
                ),
                image: DecorationImage(
                  image: const AssetImage("assets/img/leather.jpg"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.1),
                    BlendMode.dstATop,
                  ),
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    const HomePageTopBar(),
                    Text(
                      "How are You Feeling Today?",
                      style: GoogleFonts.raleway(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "Your Condition",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 229, 236, 248),
                      borderRadius: BorderRadius.circular(25)),
                  child: Text(
                    "Health",
                    style: GoogleFonts.poppins(
                        color: Colors.blue, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Square_Tile(
                    width: width,
                    disease_name: "Skin Cancer",
                    disease_image: "assets/img/skin_tile.png",
                    route: Scanner(),
                  ),
                  Square_Tile(
                    width: width,
                    disease_name: "Guide",
                    disease_image: "assets/img/guide.png",
                    route: GuidePage(),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Square_Tile(
                  width: width,
                  disease_name: "Archive",
                  disease_image: "assets/img/folder.jpg",
                  route: Archive_data(),
                ),
              ],
            ),
            Text('${FirebaseAuth.instance.currentUser!.email!}'),
          ],
        ),
      ),
    );
  }
}
