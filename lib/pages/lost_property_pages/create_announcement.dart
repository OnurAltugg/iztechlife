import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:iztechlife/pages/lost_property_pages/lost_property_features.dart';
import 'package:iztechlife/service/storage.dart';
import 'package:random_string/random_string.dart';
import '../../service/database.dart';

class CreateAnnouncement extends StatefulWidget {
  const CreateAnnouncement({super.key});

  @override
  State<CreateAnnouncement> createState() => _CreateAnnouncementState();
}

class _CreateAnnouncementState extends State<CreateAnnouncement> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  final hourFormat = DateFormat("HH:mm");
  final dateFormat = DateFormat("dd-MM-yyyy");

  final StorageMethods _storage = StorageMethods();

  User? currentUser;
  String userName = "";
  String userEmail = "";
  String userId = "";

  Uint8List? _image;
  bool isLoading = false;

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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField("Name", nameController),
              _buildTextField("Description", descriptionController),
              _buildTextField("Location", locationController),
              _buildDateField("Date", dateController),
              _buildTimeField("Time", timeController),
              _buildPhotoField(),
              const SizedBox(height: 15.0),
              Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: () async {
                    if (_validateForm()) {
                      setState(() {
                        isLoading = true;
                      });

                      try {
                        String id = randomAlphaNumeric(10);
                        String imageUrl = await _storage.uploadImageToStorage("lostProperty/$id", _image!);
                        Map<String, dynamic> lostPropertyInfoMap = {
                          "name": nameController.text,
                          "description": descriptionController.text,
                          "location": locationController.text,
                          "date": dateController.text,
                          "time": timeController.text,
                          "id": id,
                          "user_id": userId,
                          "image_url": imageUrl
                        };

                        await DatabaseMethods().addLostPropertyDetails(lostPropertyInfoMap, id);

                        Fluttertoast.showToast(
                            msg: "Lost Property details added successfully.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LostPropertyFeatures()),
                        );
                      } catch (e) {
                        Fluttertoast.showToast(
                            msg: "An error occurred. Please try again.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      } finally {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    } else {
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
              ),
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
          ),
        ),
        const SizedBox(height: 15.0),
      ],
    );
  }

  Widget _buildTimeField(String labelText, TextEditingController inputController) {
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
            format: hourFormat,
            onShowPicker: (context, currentValue) async {
              final time = await showTimePicker(
                context: context,
                initialTime:
                TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
              );
              return DateTimeField.convert(time);
            },
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

  Widget _buildDateField(String labelText, TextEditingController inputController) {
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
            format: dateFormat,
            onShowPicker: (context, currentValue) async {
              final date = await showDatePicker(
                context: context,
                initialDate: currentValue ?? DateTime.now(),
                firstDate: DateTime(2024),
                lastDate: DateTime(2100),
              );
              return date;
            },
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

  Widget _buildPhotoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Photo",
          style: TextStyle(
              color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 3.0),
        Row(
          children: [
            FloatingActionButton(
              onPressed: selectImage,
              backgroundColor: const Color(0xFFB71C1C),
              child: const Icon(Icons.upload, color: Colors.white,),),
            const SizedBox(width: 20.0),
            if (_image != null)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.memory(
                      _image!,
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _image = null;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 15.0),
      ],
    );
  }

  void selectImage() async {
    Uint8List? img = await _storage.pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  bool _validateForm() {
    return nameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        locationController.text.isNotEmpty &&
        dateController.text.isNotEmpty &&
        timeController.text.isNotEmpty &&
        _image != null;
  }
}
