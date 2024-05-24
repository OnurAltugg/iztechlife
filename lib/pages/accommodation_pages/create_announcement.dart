import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:iztechlife/pages/accommodation_pages/accommodation_features.dart';
import 'package:random_string/random_string.dart';
import '../../service/database.dart';
import '../main_page.dart';

class CreateAnnouncement extends StatefulWidget {
  const CreateAnnouncement({super.key});

  @override
  State<CreateAnnouncement> createState() => _CreateAnnouncementState();
}

class _CreateAnnouncementState extends State<CreateAnnouncement> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  final dateFormat = DateFormat("dd-MM-yyyy");
  DateTime? startDate;
  DateTime? endDate;

  User? currentUser;
  String userName = "";
  String userEmail = "";
  String userId = "";

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      userId = currentUser!.uid;
      CollectionReference userDoc = FirebaseFirestore.instance.collection('user');
      DocumentSnapshot snapshot = await userDoc.doc(userId).get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          userName = data['name'];
          userEmail = data['email'];
        });
      }
    }
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
              "Accommodation Service",
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
        child: Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField("Description", descriptionController),
              _buildTextField("Place", placeController),
              _buildTextField("Price", priceController),
              _buildDateField("Start Date", true, startDateController),
              _buildDateField("End Date", false, endDateController),
              const SizedBox(height: 15.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_validateForm()) {
                      String id = randomAlphaNumeric(10);
                      Map<String ,dynamic> accommodationInfoMap = {
                        "description": descriptionController.text,
                        "place": placeController.text,
                        "price": priceController.text,
                        "start_date": startDateController.text,
                        "end_date": endDateController.text,
                        "id": id,
                        "user_id": userId,
                      };
                      await DatabaseMethods().addFindHouseDetails(accommodationInfoMap, id).then((value){
                        Fluttertoast.showToast(
                            msg: "Accommodation details added successfully.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AccommodationFeatures()),
                      );
                    }else {
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
                  child: const Text(
                    "SUBMIT",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB71C1C),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController inputController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
              color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),
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
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
        ),
        const SizedBox(height: 15.0),
      ],
    );
  }

  Widget _buildDateField(String labelText, bool isStartDate, TextEditingController inputController) {
    DateTime now = DateTime.now();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
              color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 3.0),
        Container(
          padding: const EdgeInsets.only(left: 10.0),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DateTimeField(
            controller: inputController,
            format: dateFormat,
            onShowPicker: (context, currentValue) async {
              final date = await showDatePicker(
                context: context,
                initialDate: currentValue ?? now,
                firstDate: now,
                lastDate: DateTime(2100),
              );
              if (date != null) {
                if (isStartDate) {
                  if (endDate != null && date.isAfter(endDate!)) {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Text("Start date cannot be after end date"),
                      ),
                    );
                    return currentValue;
                  }
                  if (date.isBefore(now)) {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Text("Start date cannot be in the past"),
                      ),
                    );
                    return currentValue;
                  }
                  setState(() {
                    startDate = date;
                  });
                } else {
                  if (startDate != null && date.isBefore(startDate!)) {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Text("End date cannot be before start date"),
                      ),
                    );
                    return currentValue;
                  }
                  if (date.isBefore(now)) {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Text("End date cannot be in the past"),
                      ),
                    );
                    return currentValue;
                  }
                  setState(() {
                    endDate = date;
                  });
                }
              }
              return date;
            },
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(border: InputBorder.none),
            cursorColor: const Color(0xFFB71C1C),
          ),
        ),
        const SizedBox(height: 15.0),
      ],
    );
  }

  bool _validateForm() {
    return descriptionController.text.isNotEmpty &&
        placeController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        startDateController.text.isNotEmpty &&
        endDateController.text.isNotEmpty;
  }
}
