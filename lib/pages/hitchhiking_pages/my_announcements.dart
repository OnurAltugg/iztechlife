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

  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }
  List<String> docIds = [];
  Future getDocID() async{
    await FirebaseFirestore.instance.collection('hitchhiking').get().then(
          (document) => document.docs.forEach((element) {
        docIds.add(element.reference.id);

      }),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          FutureBuilder(
            future: getDocID(),
            builder: (context, document){
              return Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: docIds.length,
                    itemBuilder: (context, index){
                      return ListTile(
                        title: GetMyData(documentId: docIds[index],),
                      );
                    }),
              );
            },),
        ],
      ),
    );
  }
}
