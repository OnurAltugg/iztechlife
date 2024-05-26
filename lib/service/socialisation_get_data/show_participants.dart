import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../pages/main_page.dart';

class ShowParticipantsPage extends StatefulWidget {
  final List<Map<String, dynamic>> participants;
  final String documentId;

  const ShowParticipantsPage({
    super.key,
    required this.participants,
    required this.documentId,
  });

  @override
  _ShowParticipantsPageState createState() => _ShowParticipantsPageState();
}

class _ShowParticipantsPageState extends State<ShowParticipantsPage> {
  late List<Map<String, dynamic>> participants;

  @override
  void initState() {
    super.initState();
    participants = List.from(widget.participants);
  }

  Future<void> _removeParticipant(Map<String, dynamic> participant) async {
    final updatedParticipants = List.from(participants);
    updatedParticipants.remove(participant);

    final updatedParticipant = {...participant, 'status': 'rejected'};
    updatedParticipants.add(updatedParticipant);

    await FirebaseFirestore.instance.collection('socialisation').doc(widget.documentId)
        .update({
      'participants': updatedParticipants,
    });

    Fluttertoast.showToast(
        msg: "User successfully removed from event.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );

    setState(() {
      participants = updatedParticipants.cast<Map<String, dynamic>>();
    });
  }

  Future<void> _confirmParticipant(Map<String, dynamic> participant) async {
    final socialisationDoc = await FirebaseFirestore.instance.collection('socialisation').doc(widget.documentId).get();
    final quota = int.parse(socialisationDoc['quota']);
    final confirmedParticipantsCount = participants.where((p) => p['status'] == 'confirmed').length;

    if (confirmedParticipantsCount >= quota) {
      Fluttertoast.showToast(
          msg: "Quota exceeded! Please update the quota.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return;
    }

    final updatedParticipants = List.from(participants);
    updatedParticipants.remove(participant);

    final updatedParticipant = {...participant, 'status': 'confirmed'};
    updatedParticipants.add(updatedParticipant);

    await FirebaseFirestore.instance.collection('socialisation').doc(widget.documentId)
        .update({
      'participants': updatedParticipants,
    });

    Fluttertoast.showToast(
        msg: "User accepted to event.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );

    setState(() {
      participants = updatedParticipants.cast<Map<String, dynamic>>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB6ABAB),
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
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Participants',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 1,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: participants.length,
              itemBuilder: (context, index) {
                final participant = participants[index];
                final userId = participant['id'];
                return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection('user').doc(userId).snapshots(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
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
                    final userPhone = userData['phone'];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Card(
                        color: const Color(0xFFB71C1C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                          title: Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5.0),
                              Text(
                                'Email: $userEmail',
                                style: const TextStyle(fontSize: 16.0, color: Colors.white),
                              ),
                              const SizedBox(height: 5.0),
                              if (userPhone != null)
                                Text(
                                  'Phone: $userPhone',
                                  style: const TextStyle(fontSize: 16.0, color: Colors.white),
                                ),
                              if (participant['status'] == 'waiting')
                                const Text(
                                  'Waiting your response...',
                                  style: TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.bold,),
                                ),
                              if (participant['status'] == 'confirmed')
                                const Text(
                                  'Participant',
                                  style: TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.bold,),
                                ),
                              if (participant['status'] == 'rejected')
                                const Text(
                                  'Rejected!',
                                  style: TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.bold,),
                                ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (participant['status'] == 'waiting')
                                IconButton(
                                  icon: const Icon(Icons.check_circle, color: Colors.white),
                                  onPressed: () async {
                                    await _confirmParticipant(participant);
                                  },
                                ),
                              if (participant['status'] == 'waiting')
                                IconButton(
                                  icon: const Icon(Icons.highlight_remove, color: Colors.white),
                                  onPressed: () async {
                                    await _removeParticipant(participant);
                                  },
                                ),
                              if (participant['status'] == 'rejected')
                                IconButton(
                                  icon: const Icon(Icons.check_circle, color: Colors.white),
                                  onPressed: () async {
                                    await _confirmParticipant(participant);
                                  },
                                ),
                              if (participant['status'] == 'confirmed')
                                IconButton(
                                  icon: const Icon(Icons.highlight_remove, color: Colors.white),
                                  onPressed: () async {
                                    await _removeParticipant(participant);
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
