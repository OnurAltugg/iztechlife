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

  Future<void> _showInfoDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Icon Information"),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.people,
                    color: Colors.black,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Shows how many users have been accepted and how much space is available.",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.question_mark,
                    color: Colors.black,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Indicates that your opt-in request has been sent to the user and is awaiting confirmation.",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.event_available,
                    color: Colors.black,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Indicates that you have been accepted for the event.",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.cancel_presentation_outlined,
                    color: Colors.black,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Indicates that you are not accepted for event.",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
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
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: _showInfoDialog,
                  child: const Icon(
                    Icons.info,
                    color: Colors.black,
                  ),
                ),
              ],
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
