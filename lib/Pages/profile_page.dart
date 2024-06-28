import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:skin_cancer_app_final/Pages/homePage.dart';
import 'package:skin_cancer_app_final/Services/get_user_data.dart';
import 'package:skin_cancer_app_final/utils/colors_used.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // final user = FirebaseAuth.instance.currentUser!;
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> signout() async {
    try {
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Check if user is now null
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Navigate to the sign-in screen
        Navigator.pushReplacementNamed(
            context, '/auth_login_or_not'); // Replace with your sign-in route
      }
    } catch (error) {
      // Handle any errors during sign-out
      print("Error during sign-out: $error");
      // Provide appropriate feedback to the user, e.g., a snackbar or alert
    }
  }

  // document ids
  List<String> docIDs = [];
  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('registered_users')
        .where('email', isEqualTo: user?.email)
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              print(document.reference);
              docIDs.add(document.reference.id);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 229, 228, 226),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewHomePage()),
            );
          },
        ),
        actions: [
          IconButton(
            // onPressed: () async {
            //   try {
            //     if (user != null) {
            //       // await ref.read(firebaseAuthProvider).signOut();
            //       await FirebaseAuth.instance.signOut();
            //       Navigator.pushReplacement(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => AuthWidget(
            //             signedInBuilder: (context) => NewHomePage(),
            //             nonSignedInBuilder: (context) =>
            //                 AuthPageForLoginOrSignup(),
            //           ),
            //         ),
            //       );
            //     } else {
            //       print("User is Already Signed Out");
            //     }
            //   } catch (e) {
            //     print('Error on Sign Out:, $e');
            //   }
            // },
            onPressed: signout,
            icon: Icon(Icons.exit_to_app_outlined),
            color: Colors.red,
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(bottom: 38, left: 28, right: 28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: AppColors.brownShade,
          boxShadow: [
            BoxShadow(
              color: AppColors.chambrayBlue,
              spreadRadius: 1,
              blurRadius: 15,
              offset: const Offset(5, 5),
            ),
            const BoxShadow(
              color: Colors.white,
              offset: Offset(-5, -5),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            children: [
              Lottie.asset(
                "assets/anim/profile.json",
                height: MediaQuery.of(context).size.height / 5,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(28),
                  child: FutureBuilder(
                    future: getDocId(),
                    builder: (context, snapshot) {
                      return ListView.builder(
                        itemCount: docIDs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: GetUserData(
                                documentId: docIDs[index],
                                // userId: docIDs[index],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              // Container(
              //   margin: EdgeInsets.only(bottom: 15),
              //   child: Center(
              //     child: ElevatedButton(
              //       onPressed: () {
              //         ref.read(firebaseAuthProvider).signOut();
              //       },
              //       child: Text(
              //         "Sign Out",
              //         style: GoogleFonts.poppins(
              //             fontSize: MediaQuery.of(context).size.width / 22,
              //             color: Colors.white),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
