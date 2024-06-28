import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_cancer_app_final/utils/colors_used.dart';

class GetUserDetails extends StatelessWidget {
  final String documentId;
  const GetUserDetails({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('profiles');

    // User? user = FirebaseAuth.instance.currentUser;

    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(documentId).get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 2.4,
                    color: AppColors.chambrayBlue,
                  ),
                  borderRadius: BorderRadius.circular(25)),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 2.4,
                      color: AppColors.chambrayBlue,
                    ),
                    borderRadius: BorderRadius.circular(25)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name : ${data['full_name']}',
                      style: GoogleFonts.poppins(),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Country : ${data['country']}',
                      style: GoogleFonts.poppins(),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Mobile : ${data['mobile']}',
                      style: GoogleFonts.poppins(),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Age : ${data['age']}',
                      style: GoogleFonts.poppins(),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Email : ${data['email']}',
                      style: GoogleFonts.poppins(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return Text('loading...');
        }));
  }
}


// Text('First Name: ${data['full_name']}' + 'Age: ${data['age']}');