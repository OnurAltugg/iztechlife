import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iztechlife/pages/lost_property_pages/single_display_announcement.dart';

class GetData extends StatelessWidget {
  final String documentId;
  const GetData({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    final lostProperty = FirebaseFirestore.instance.collection('lostProperty');
    final users = FirebaseFirestore.instance.collection('user');

    return StreamBuilder<DocumentSnapshot>(
      stream: lostProperty.doc(documentId).snapshots(),
      builder: (context, lostPropertySnapshot) {
        if (lostPropertySnapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading lost property data...");
        }
        if (lostPropertySnapshot.hasError) {
          return Text("Error: ${lostPropertySnapshot.error}");
        }
        if (!lostPropertySnapshot.hasData || !lostPropertySnapshot.data!.exists) {
          return const Text("No data found");
        }

        final lostPropertyData = lostPropertySnapshot.data!.data() as Map<String, dynamic>;
        final userId = lostPropertyData['user_id'];

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
                        name: lostPropertyData['name'],
                        description: lostPropertyData['description'],
                        location: lostPropertyData['location'],
                        date: lostPropertyData['date'],
                        time: lostPropertyData['time'],
                        image_url: lostPropertyData['image_url'],
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
                        lostPropertyData['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Created By: $userName",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lostPropertyData['description'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
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
