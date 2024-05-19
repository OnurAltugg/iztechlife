import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iztechlife/service/accommodation_get_data/get_data.dart';

class DisplayAnnouncements extends StatefulWidget {
  const DisplayAnnouncements({super.key});

  @override
  State<DisplayAnnouncements> createState() => _DisplayAnnouncementsState();
}

class _DisplayAnnouncementsState extends State<DisplayAnnouncements> {
  List<String> docIds = [];

  Future<void> getDocID() async {
    final documents = await FirebaseFirestore.instance.collection('accommodation').get();
    setState(() {
      docIds = documents.docs.map((doc) => doc.id).toList();
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: docIds.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: GetData(documentId: docIds[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
