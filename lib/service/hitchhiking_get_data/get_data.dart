import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iztechlife/pages/hitchhiking_pages/single_display_announcement.dart';

class GetData extends StatelessWidget {
  final String documentId;
  GetData({required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference hitchhiking =
    FirebaseFirestore.instance.collection('hitchhiking');
    return FutureBuilder<DocumentSnapshot>(
        future: hitchhiking.doc(documentId).get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
            return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFFB71C1C),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SingleDisplayAnnouncement(
                        user_name: data['user_name'],
                        user_email: data['user_email'],
                        name: data['name'],
                        description: data['description'],
                        car_info: data['car_info'],
                        date: data['date'],
                        time: data['time'],
                        departure: data['departure'],
                        destination: data['destination'],
                        quota: data['quota'],
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Text("Name: ${data['name']}", style: const TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold)),
                    Text("Created By: ${data['user_name']}", style: const TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold)),
                  ],
                ));
          }
          return const Text("Loading...");
        }));
  }
}
