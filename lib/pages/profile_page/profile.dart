import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iztechlife/auth/login_screen.dart';
import '../../auth/auth_service.dart';
import '../../service/database.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController nameController = TextEditingController();
  late Stream<DocumentSnapshot> _userDataStream;
  final _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _userDataStream = _loadUserData();
  }

  Stream<DocumentSnapshot> _loadUserData() {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance.collection('user').doc(currentUserId).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB6ABAB),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: const Color(0xFFB6ABAB),
        title: const Padding(
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
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Profile",
                textAlign: TextAlign.center, // Center the text
                style: TextStyle(
                  fontSize: 22.0, // Increase font size
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Change text color
                  shadows: [
                    Shadow(
                      blurRadius: .8,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40.0),
              StreamBuilder(
                stream: _userDataStream,
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    if (snapshot.hasData && snapshot.data != null) {
                      Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;
                      if (data != null) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                _buildInfo("Name", data['name']),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    nameController.text = data['name'];
                                    editName(context, data['id']);
                                  },
                                  child:
                                  const Icon(Icons.edit),
                                ),
                              ],
                            ),
                            _buildInfo("Email", data['email']),
                            const SizedBox(height: 30.0),
                            Center(
                              child: ElevatedButton(
                                onPressed: () async {
                                  _showConfirmationDialog(context);
                                },
                                child: const Text(
                                  "LOG OUT",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFB71C1C),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 350.0),
                            Center(
                              child: ElevatedButton(
                                onPressed: () async {
                                  _showDeleteDialog(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFB71C1C),
                                ),
                                child: const Text(
                                  "DELETE ACCOUNT",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                    return const Text("No data available");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("CANCEL"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _auth.signOut(context);
                goToLogin(context);
              },
              child: const Text("LOG OUT"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete Account"),
          content: const Text("Are you sure you want to delete account?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("CANCEL"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _auth.deleteUser(context);
                exit(0);
              },
              child: const Text("DELETE"),
            ),
          ],
        );
      },
    );
  }

  Future editName(BuildContext context, String id) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.cancel),
                ),
                const SizedBox(
                  width: 60.0,
                ),
              ],
            ),
            _buildTextField("Name", nameController),
            Center(
                child: ElevatedButton(
                    onPressed: () async{
                      if (nameController.text.length >= 2) {
                        Map<String ,dynamic> updateInfoMap = {
                          "name": nameController.text,
                          "id": id,
                        };
                        await DatabaseMethods().updateUserName(updateInfoMap, id).then((value){
                          Fluttertoast.showToast(
                              msg: "Updated successfully.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        });
                        Navigator.pop(
                          context,
                        );
                      }else if(nameController.text.length == 1){
                        Fluttertoast.showToast(
                            msg: "Name must be at least 2 characters long",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }
                      else {
                        Fluttertoast.showToast(
                            msg: "Please fill all fields",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }
                    },
                    child: const Text("Update")
                )
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildTextField(String labelText, TextEditingController inputController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
              color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 3.0),
        Container(
          padding: const EdgeInsets.only(left: 10.0),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: inputController,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(border: InputBorder.none),
            cursorColor: const Color(0xFFB71C1C),
          ),
        ),
        const SizedBox(height: 15.0),
      ],
    );
  }

  void goToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}