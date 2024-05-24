import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main_page.dart';

class SingleDisplayAnnouncement extends StatelessWidget {
  final String userName, userEmail, userPhone, description, carInfo, date, time, departure, destination, quota, documentId;

  const SingleDisplayAnnouncement({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.description,
    required this.carInfo,
    required this.date,
    required this.time,
    required this.departure,
    required this.destination,
    required this.quota,
    required this.documentId
  });

  @override
  Widget build(BuildContext context) {
    bool isUserAnnouncement = false;
    final user = FirebaseAuth.instance.currentUser!;
    if(user.email == userEmail){
      isUserAnnouncement = true;
    }
    return Scaffold(
      backgroundColor: const Color(0xFFB6ABAB), // Scaffold background color
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildText("Description", description),
              const SizedBox(height: 15.0),
              _buildText("Car Info", carInfo),
              const SizedBox(height: 15.0),
              _buildText("Date", date),
              const SizedBox(height: 15.0),
              _buildText("Time", time),
              const SizedBox(height: 15.0),
              _buildText("Departure Location", departure),
              const SizedBox(height: 15.0),
              _buildText("Destination Location", destination),
              const SizedBox(height: 15.0),
              _buildText("Quota", quota),
              const SizedBox(height: 15.0),
              _buildText("Created By", userName),
              const SizedBox(height: 15.0),
              _buildText("Email", userEmail),
              const SizedBox(height: 15.0),
              if(userPhone != "")
                _buildText("Phone", userPhone),
              if (!isUserAnnouncement)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),

                    child: StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance.collection('hitchhiking').doc(documentId).snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data!['participants'] == null) {
                          return const SizedBox.shrink();
                        }
                        final List<dynamic> participants = snapshot.data!['participants'];
                        if (participants.contains(user.uid)) {
                          return ElevatedButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Withdraw Request?'),
                                    content: const Text('Are you sure you want to withdraw your join request for this announcement?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          final List<dynamic> updatedParticipants = List.from(participants);
                                          updatedParticipants.remove(user.uid);
                                          await FirebaseFirestore.instance.collection('hitchhiking').doc(documentId).update({'participants': updatedParticipants});
                                        },
                                        child: const Text('Yes'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text(
                              "WITHDRAW REQUEST",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB71C1C),
                              ),
                            ),
                          );
                        } else {
                          return ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Send Join Request?'),
                                    content: const Text('Are you sure you want to send a join request for this announcement?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          final user = FirebaseAuth.instance.currentUser!;
                                          final hitchhiking = FirebaseFirestore.instance.collection('hitchhiking').doc(documentId);
                                          final DocumentSnapshot hitchhikingSnapshot = await hitchhiking.get();
                                          if (hitchhikingSnapshot.exists) {
                                            final List<dynamic> participants = hitchhikingSnapshot['participants'];
                                            participants.add(user.uid);
                                            await hitchhiking.update({'participants': participants});
                                          }
                                        },
                                        child: const Text('Yes'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text(
                              "SEND JOIN REQUEST",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB71C1C),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                )

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildText(String label, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
