import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GetMyData extends StatelessWidget {
  final String documentId;
  final Function(String) onDelete;
  final user = FirebaseAuth.instance.currentUser!;
  GetMyData({super.key, required this.documentId, required this.onDelete});

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
            if (user.email == data['user_email']) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: const Color(0xFFB71C1C),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Name: ${data['name']}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const Icon(Icons.edit, color: Colors.white),
                                const SizedBox(width: 5.0),
                                GestureDetector(
                                  onTap: () async {
                                    onDelete(documentId);
                                  },
                                  child:
                                  const Icon(Icons.delete, color: Colors.white),
                                )
                              ],
                            ),
                            Text("Description: ${data['description']}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold)),
                            Text("Car Info: ${data['car_info']}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold)),
                            Text("Date: ${data['date']}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold)),
                            Text("Time: ${data['time']}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold)),
                            Text("Departure Location: ${data['departure']}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold)),
                            Text("Destination Location: ${data['destination']}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold)),
                            Text("Quota: ${data['quota']}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          return const Text("");
        }));
  }
}
