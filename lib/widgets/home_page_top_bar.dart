import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skin_cancer_app_final/Pages/profile_page.dart';
import 'package:skin_cancer_app_final/Services/get_user_name.dart';

class HomePageTopBar extends StatefulWidget {
  const HomePageTopBar({super.key});

  @override
  State<HomePageTopBar> createState() => _HomePageTopBarState();
}

class _HomePageTopBarState extends State<HomePageTopBar> {
  // final user = FirebaseAuth.instance.currentUser!;
  User? user = FirebaseAuth.instance.currentUser;

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
  // .collection('profiles')

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 7,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfilePage()),
                        );
                      },
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width / 15,
                        backgroundImage: AssetImage("assets/img/avatar.jpg"),
                      ),
                    ),
                  ),
                  // SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.only(left: 2),
                    height: MediaQuery.of(context).size.height / 19,
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                        // color: Colors.amberAccent,
                        ),
                    child: FutureBuilder(
                      future: getDocId(),
                      builder: (context, snapshot) {
                        return ListView.builder(
                          itemCount: docIDs.length,
                          itemBuilder: (context, index) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hey, Hello",
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.left,
                                ),
                                GetUserName(
                                  documentId: docIDs[index],
                                  // userId: docIDs[index],
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              // Container(
              //   height: MediaQuery.of(context).size.height / 19,
              //   width: MediaQuery.of(context).size.width / 2,
              //   decoration: BoxDecoration(
              //       // color: Colors.amberAccent,
              //       ),
              //   child: FutureBuilder(
              //     future: getDocId(),
              //     builder: (context, snapshot) {
              //       return ListView.builder(
              //         itemCount: docIDs.length,
              //         itemBuilder: (context, index) {
              //           return GetUserName(
              //             documentId: docIDs[index],
              //             // userId: docIDs[index],
              //           );
              //         },
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
