import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_cancer_app_final/utils/colors_used.dart';

// ignore: must_be_immutable
class Square_Tile extends StatelessWidget {
  Square_Tile({
    super.key,
    required this.width,
    required this.disease_name,
    required this.disease_image,
    required this.route,
  });

  final double width;
  String disease_name;
  String disease_image;
  final Widget route;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      height: width / 2,
      width: width / 2,
      decoration: BoxDecoration(
        color: AppColors.chambrayBlue,
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(
            image: AssetImage(disease_image), fit: BoxFit.cover),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => route),
              );
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 8, left: 20, right: 20),
              padding: EdgeInsets.only(top: 8, bottom: 8),
              decoration: BoxDecoration(
                color: Color.fromARGB(206, 249, 249, 249),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(width: 1.5, color: Colors.white),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    disease_name,
                    style: GoogleFonts.poppins(),
                    textAlign: TextAlign.end,
                  ),
                  Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.arrow_outward_rounded,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
