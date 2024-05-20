import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../pages/lost_property_pages/full_screen_image.dart';
import '../database.dart';
import '../storage.dart';

class GetMyData extends StatefulWidget {
  final String documentId;
  final Function(String) onDelete;

  const GetMyData({super.key, required this.documentId, required this.onDelete});

  @override
  _GetMyDataState createState() => _GetMyDataState();
}

class _GetMyDataState extends State<GetMyData>  {
  final user = FirebaseAuth.instance.currentUser!;
  final hourFormat = DateFormat("HH:mm");
  final dateFormat = DateFormat("dd-MM-yyyy");
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  final StorageMethods _storage = StorageMethods();
  Uint8List? _image;

  @override
  Widget build(BuildContext context) {
    final String documentId = widget.documentId;
    CollectionReference lostProperty =
    FirebaseFirestore.instance.collection('lostProperty');
    return StreamBuilder<DocumentSnapshot>(
      stream: lostProperty.doc(documentId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData && snapshot.data != null) {
            Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
            if (user.uid == data['user_id']) {
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
                                GestureDetector(
                                  onTap: () {
                                    nameController.text = data['name'];
                                    descriptionController.text = data['description'];
                                    locationController.text = data['location'];
                                    dateController.text = data['date'];
                                    timeController.text = data['time'];
                                    editAnnouncementDetail(context, documentId);
                                  },
                                  child: const Icon(Icons.edit, color: Colors.white),
                                ),
                                const SizedBox(width: 5.0),
                                GestureDetector(
                                  onTap: () async {
                                    String? imageUrl = data['image_url'];
                                    if (imageUrl != null && imageUrl.isNotEmpty) {
                                      await _storage.deleteImageFromStorage(imageUrl);
                                    }
                                    await FirebaseFirestore.instance.collection('lostProperty').doc(documentId).delete();
                                    widget.onDelete(documentId);
                                  },
                                  child: const Icon(Icons.delete, color: Colors.white),
                                )
                              ],
                            ),
                            const SizedBox(height: 3.0),
                            Text("Description: ${data['description']}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 3.0),
                            Text("Location: ${data['location']}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 3.0),
                            Text("Date: ${data['date']}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 3.0),
                            Text("Time: ${data['time']}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 15.0),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenImage(imageUrl: data['image_url']),
                                  ),
                                );
                              },
                              child: Image.network(
                                data['image_url'],
                                width: 400,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return const Center(
                                      child: Text(
                                        'Loading Image...',
                                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                                      ),
                                    );
                                  }
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Text(
                                    'Image could not be loaded.',
                                    style: TextStyle(color: Colors.red),
                                  );
                                },
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }
        }
        return const Text("");
      },
    );
  }

  Future editAnnouncementDetail(BuildContext context, String id) => showDialog(
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
                const SizedBox(width: 60.0),
              ],
            ),
            _buildTextField("Name", nameController),
            _buildTextField("Description", descriptionController),
            _buildTextField("Location", locationController),
            _buildDateField("Date", dateController),
            _buildTimeField("Time", timeController),
            _buildPhotoField(),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (_validateForm()) {
                    Map<String, dynamic> updateInfoMap = {
                      "name": nameController.text,
                      "description": descriptionController.text,
                      "location": locationController.text,
                      "date": dateController.text,
                      "time": timeController.text,
                      "id": id,
                    };

                    CollectionReference lostProperty =
                    FirebaseFirestore.instance.collection('lostProperty');

                    DocumentSnapshot documentSnapshot = await lostProperty.doc(id).get();
                    String? oldImageUrl = documentSnapshot['image_url'];

                    if (_image != null) {
                      if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
                        await _storage.deleteImageFromStorage(oldImageUrl);
                      }
                      String imageUrl = await _storage.uploadImageToStorage(
                        'lostProperty/$id',
                        _image!,
                      );
                      updateInfoMap['image_url'] = imageUrl;
                    }

                    await DatabaseMethods()
                        .updateDetails(updateInfoMap, id, "lostProperty")
                        .then((value) {
                      Fluttertoast.showToast(
                        msg: "Updated successfully.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    });
                    Navigator.pop(context);
                  } else {
                    Fluttertoast.showToast(
                      msg: "Please fill all fields",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                },
                child: const Text("Update"),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildTextField(
      String labelText, TextEditingController inputController) {
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

  Widget _buildTimeField(
      String labelText, TextEditingController inputController) {
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
              color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
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
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 3.0),
        Row(
          children: [
            FloatingActionButton(
              onPressed: selectImage,
              backgroundColor: const Color(0xFFB71C1C),
              child: const Icon(Icons.upload, color: Colors.white),
            ),
            const SizedBox(width: 20.0),
            if (_image != null)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.memory(
                      _image!,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 0,
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
              )
            else
              const Text(
                "No image selected",
                style: TextStyle(color: Colors.black),
              ),
          ],
        ),
        const SizedBox(height: 15.0),
      ],
    );
  }


  void selectImage() async {
    Uint8List? img = await _storage.pickImage(ImageSource.gallery);
    if (img != null) {
      setState(() {
        _image = img;
      });
    }
  }

  bool _validateForm() {
    return nameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        locationController.text.isNotEmpty &&
        dateController.text.isNotEmpty &&
        timeController.text.isNotEmpty;
  }
}