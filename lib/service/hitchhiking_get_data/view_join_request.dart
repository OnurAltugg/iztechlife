import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewJoinRequestsPage extends StatelessWidget {
  final List<String> participants;

  ViewJoinRequestsPage({Key? key, required this.participants}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Requests'),
      ),
      body: ListView.builder(
        itemCount: participants.length,
        itemBuilder: (context, index) {
          final String userId = participants[index];
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('user').doc(userId).get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const ListTile(
                  title: Text('Loading...'),
                );
              }
              if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                return const ListTile(
                  title: Text('User not found'),
                );
              }
              final userData = userSnapshot.data!.data() as Map<String, dynamic>;
              final userName = userData['name'];
              final userEmail = userData['email'];
              return ListTile(
                title: Text(userName),
                subtitle: Text(userEmail),
              );
            },
          );
        },
      ),
    );
  }
}
