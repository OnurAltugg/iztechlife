import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main_page.dart';

class SingleDisplayAnnouncement extends StatelessWidget {
  final String userName, userEmail, userPhone, description, location, date, time, quota, documentId;

  const SingleDisplayAnnouncement({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.description,
    required this.location,
    required this.date,
    required this.time,
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
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
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
              _buildText("Location", location),
              const SizedBox(height: 15.0),
              _buildText("Date", date),
              const SizedBox(height: 15.0),
              _buildText("Time", time),
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
                      stream: FirebaseFirestore.instance.collection('socialisation').doc(documentId).snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data!['participants'] == null) {
                          return const SizedBox.shrink();
                        }
                        final List<dynamic> participants = snapshot.data!['participants'];
                        final participant = participants.firstWhere(
                              (participant) => participant['id'] == user.uid,
                          orElse: () => null,
                        );

                        if (participant != null && participant['status'] == 'rejected') {
                          return const Text(
                            "You have been rejected from the event.",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          );
                        }

                        bool isUserParticipating = participant != null;
                        if (isUserParticipating) {
                          return ElevatedButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Leave the Event'),
                                    content: const Text('Are you sure you want to leave the event?'),
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
                                          updatedParticipants.removeWhere((participant) => participant['id'] == user.uid);
                                          await FirebaseFirestore.instance.collection('socialisation').doc(documentId).update({'participants': updatedParticipants});
                                          Fluttertoast.showToast(
                                              msg: "You've left the Event!",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                          );
                                        },
                                        child: const Text('Yes'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text(
                              "LEAVE",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB71C1C),
                              ),
                            ),
                          );
                        } else {
                          return ElevatedButton(
                            onPressed: () async {
                              if (_countParticipantsWithStatus(participants) >= int.parse(quota)) {
                                Fluttertoast.showToast(
                                    msg: "No spot available! Please try again later.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 2,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              } else {
                                final user = FirebaseAuth.instance.currentUser!;
                                final socialisation = FirebaseFirestore.instance.collection('socialisation').doc(documentId);
                                final DocumentSnapshot socialisationSnapshot = await socialisation.get();
                                if (socialisationSnapshot.exists) {
                                  final List<dynamic> participants = socialisationSnapshot['participants'];
                                  participants.add({"status": "waiting", "id": user.uid});
                                  await socialisation.update({'participants': participants});
                                  Fluttertoast.showToast(
                                      msg: "You've joined the Event!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                }
                              }
                            },
                            child: const Text(
                              "JOIN",
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

  int _countParticipantsWithStatus(List<dynamic> participants) {
    return participants
        .where((participant) => participant is Map<String, dynamic> && participant['status'] == "confirmed")
        .length;
  }
}
