import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iztechlife/pages/accommodation_pages/single_display_announcement.dart';

class GetData extends StatelessWidget {
  final String documentId;
  const GetData({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    final accommodation = FirebaseFirestore.instance.collection('accommodation');
    final users = FirebaseFirestore.instance.collection('user');

    return StreamBuilder<DocumentSnapshot>(
      stream: accommodation.doc(documentId).snapshots(),
      builder: (context, accommodationSnapshot) {
        if (accommodationSnapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading accommodation data...");
        }
        if (accommodationSnapshot.hasError) {
          return Text("Error: ${accommodationSnapshot.error}");
        }
        if (!accommodationSnapshot.hasData || !accommodationSnapshot.data!.exists) {
          return const Text("No data found");
        }

        final accommodationData = accommodationSnapshot.data!.data() as Map<String, dynamic>;
        final userId = accommodationData['user_id'];

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
                        userName: userName,
                        userEmail: userEmail,
                        userPhone: userPhone,
                        description: accommodationData['description'],
                        place: accommodationData['place'],
                        price: accommodationData['price'],
                        startDate: accommodationData['start_date'],
                        endDate: accommodationData['end_date'],
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Created By: $userName",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        accommodationData['description'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
