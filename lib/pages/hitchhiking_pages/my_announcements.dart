import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../service/hitchhiking_get_data/get_my_data.dart';

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
          .collection('hitchhiking')
          .doc(documentId)
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('hitchhiking').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return const Text('Error');
        }
        final documents = snapshot.data!.docs;
        return Scaffold(
          backgroundColor: const Color(0xFFB6ABAB),
          appBar: AppBar(
            backgroundColor: const Color(0xFFB6ABAB),
            title: const Padding(
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
                  )
                ],
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: documents.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 20);
                    },
                    itemBuilder: (context, index) {
                      final documentId = documents[index].id;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: GetMyData(
                          documentId: documentId,
                          onDelete: (deletedDocId) => deleteDocument(deletedDocId),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
