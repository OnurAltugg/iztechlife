import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iztechlife/pages/hitchhiking_pages/single_display_announcement.dart';

class GetData extends StatelessWidget {
  final String documentId;
  const GetData({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference hitchhiking = FirebaseFirestore.instance.collection('hitchhiking');
    CollectionReference users = FirebaseFirestore.instance.collection('user');

    return StreamBuilder<DocumentSnapshot>(
      stream: hitchhiking.doc(documentId).snapshots(),
      builder: (context, hitchhikingSnapshot) {
        if (hitchhikingSnapshot.connectionState == ConnectionState.active) {
          if (hitchhikingSnapshot.hasError) {
            return Text("Error: ${hitchhikingSnapshot.error}");
          }

          if (!hitchhikingSnapshot.hasData || !hitchhikingSnapshot.data!.exists) {
            return const Text("No data found");
          }

          Map<String, dynamic> hitchhikingData = hitchhikingSnapshot.data!.data() as Map<String, dynamic>;
          String userId = hitchhikingData['user_id'];

          return StreamBuilder<DocumentSnapshot>(
            stream: users.doc(userId).snapshots(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.active) {
                if (userSnapshot.hasError) {
                  return Text("Error: ${userSnapshot.error}");
                }

                if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                  return const Text("User not found");
                }

                Map<String, dynamic> userData = userSnapshot.data!.data() as Map<String, dynamic>;
                String userName = userData['name'];
                String userEmail = userData['email'];

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
                          user_name: userName,
                          user_email: userEmail,
                          name: hitchhikingData['name'],
                          description: hitchhikingData['description'],
                          car_info: hitchhikingData['car_info'],
                          date: hitchhikingData['date'],
                          time: hitchhikingData['time'],
                          departure: hitchhikingData['departure'],
                          destination: hitchhikingData['destination'],
                          quota: hitchhikingData['quota'],
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Text("${hitchhikingData['name']}", style: const TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold)),
                      Text("Created By: $userName", style: const TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              }
              return const Text("Loading user data...");
            },
          );
        }
        return const Text("Loading hitchhiking data...");
      },
    );
  }
}
