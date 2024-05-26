import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iztechlife/service/socialisation_get_data/get_my_data.dart';

import '../main_page.dart';

class MyAnnouncements extends StatefulWidget {
  const MyAnnouncements({super.key});

  @override
  State<MyAnnouncements> createState() => _MyAnnouncementsState();
}

class _MyAnnouncementsState extends State<MyAnnouncements> {
  final user = FirebaseAuth.instance.currentUser!;

  Future<void> deleteDocument(String documentId) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Announcement"),
          content: const Text("Are you sure you want to delete this document?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
    if (confirmDelete == true) {
      await FirebaseFirestore.instance
          .collection('socialisation')
          .doc(documentId)
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('socialisation')
          .where('user_id', isEqualTo: user.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error'));
        }
        final documents = snapshot.data!.docs;
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
          body: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: documents.isEmpty
                ? const Center(child: Text("No Announcements"))
                : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              shrinkWrap: true,
              itemCount: documents.length,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 20);
              },
              itemBuilder: (context, index) {
                final documentId = documents[index].id;
                return GetMyData(
                  documentId: documentId,
                  onDelete: (deletedDocId) => deleteDocument(deletedDocId),
                );
              },
            ),
          ),
        );
      },
    );
  }
}