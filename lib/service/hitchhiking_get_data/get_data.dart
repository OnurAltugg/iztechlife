import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iztechlife/pages/hitchhiking_pages/single_display_announcement.dart';

class GetData extends StatelessWidget {
  final String documentId;
  const GetData({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    final hitchhiking = FirebaseFirestore.instance.collection('hitchhiking');
    final users = FirebaseFirestore.instance.collection('user');

    return StreamBuilder<DocumentSnapshot>(
      stream: hitchhiking.doc(documentId).snapshots(),
      builder: (context, hitchhikingSnapshot) {
        if (hitchhikingSnapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading hitchhiking data...");
        }
        if (hitchhikingSnapshot.hasError) {
          return Text("Error: ${hitchhikingSnapshot.error}");
        }
        if (!hitchhikingSnapshot.hasData || !hitchhikingSnapshot.data!.exists) {
          return const Text("No data found");
        }

        final hitchhikingData = hitchhikingSnapshot.data!.data() as Map<String, dynamic>;
        final userId = hitchhikingData['user_id'];

        return StreamBuilder<DocumentSnapshot>(
          stream: users.doc(userId).snapshots(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading user data...");
            }
            if (userSnapshot.hasError) {
              return Text("Error: ${userSnapshot.error}");
            }
            if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
              return const Text("User not found");
            }

            final userData = userSnapshot.data!.data() as Map<String, dynamic>;
            final userName = userData['name'];
            final userEmail = userData['email'];
            final userPhone = userData['phone'] ?? "";

            final currentUserId = FirebaseAuth.instance.currentUser!.uid;
            return Card(
                color: const Color(0xFFB71C1C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SingleDisplayAnnouncement(
                        user_name: userName,
                        user_email: userEmail,
                        userPhone: userPhone,
                        description: hitchhikingData['description'],
                        car_info: hitchhikingData['car_info'],
                        date: hitchhikingData['date'],
                        time: hitchhikingData['time'],
                        departure: hitchhikingData['departure'],
                        destination: hitchhikingData['destination'],
                        quota: hitchhikingData['quota'],
                        documentId: documentId,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Created By: $userName",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                          const Spacer(),
                          if ((List.from(hitchhikingData['participants'])).contains(currentUserId))
                            const Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 24.0,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        hitchhikingData['description'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${(List.from(hitchhikingData['participants'])).length}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),

                        ],
                      ),

                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
