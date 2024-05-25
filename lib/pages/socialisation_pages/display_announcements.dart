import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iztechlife/service/socialisation_get_data/get_data.dart';

import '../main_page.dart';

class DisplayAnnouncements extends StatefulWidget {
  const DisplayAnnouncements({super.key});

  @override
  State<DisplayAnnouncements> createState() => _DisplayAnnouncementsState();
}

class _DisplayAnnouncementsState extends State<DisplayAnnouncements> {
  List<String> userParticipatedDocIds = [];
  List<String> otherDocIds = [];
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> getDocID() async {
    final documents = await FirebaseFirestore.instance.collection('socialisation').get();
    List<String> participated = [];
    List<String> notParticipated = [];

    for (var doc in documents.docs) {
      if ((doc.data()['participants'] as List).contains(currentUserId)) {
        participated.add(doc.id);
      } else {
        notParticipated.add(doc.id);
      }
    }

    setState(() {
      userParticipatedDocIds = participated;
      otherDocIds = notParticipated;
    });
  }

  @override
  void initState() {
    super.initState();
    getDocID();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB6ABAB),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: const Color(0xFFB6ABAB),
        title: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainPage()),
            );
          },
          child: const Padding(
            padding: EdgeInsets.only(right: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "IZTECH",
                  style: TextStyle(
                      color: Color(0xFFB71C1C),
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Life",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Socialisation Service",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                shadows: [
                  Shadow(
                    blurRadius: 2,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: userParticipatedDocIds.length + otherDocIds.length,
              itemBuilder: (context, index) {
                if (index < userParticipatedDocIds.length) {
                  return ListTile(
                    title: GetData(documentId: userParticipatedDocIds[index]),
                  );
                } else {
                  final otherIndex = index - userParticipatedDocIds.length;
                  return ListTile(
                    title: GetData(documentId: otherDocIds[otherIndex]),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
