import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GetUserData extends StatelessWidget {
  final String documentId;
  const GetUserData({Key? key, required this.documentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection("registered_users");
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data['full_name'],
                  style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.width / 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  data['email'],
                  style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.width / 24,
                  ),
                ),
                Text(
                  'Age :- ' + data['age'].toString(),
                  style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.width / 22,
                  ),
                ),
                Text(
                  'Mobile :- ' + data['mobile'].toString(),
                  style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.width / 22,
                  ),
                ),
                // Text(
                //   "Address :-" + data['address'],
                //   style: GoogleFonts.poppins(
                //     fontSize: MediaQuery.of(context).size.width / 22,
                //   ),
                // ),
                Text(
                  "Country :- " + data['country'],
                  style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.width / 22,
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
        }
        return Text("Loading...");
      },
    );
  }
}
