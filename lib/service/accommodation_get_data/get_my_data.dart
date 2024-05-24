import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../database.dart';

class GetMyData extends StatefulWidget {
  final String documentId;
  final Function(String) onDelete;
  const GetMyData({super.key, required this.documentId, required this.onDelete});

  @override
  _GetMyDataState createState() => _GetMyDataState();
}

class _GetMyDataState extends State<GetMyData> {
  final user = FirebaseAuth.instance.currentUser!;
  final dateFormat = DateFormat("dd-MM-yyyy");
  DateTime? startDate;
  DateTime? endDate;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    placeController.dispose();
    priceController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference accommodation = FirebaseFirestore.instance.collection('accommodation');
    return StreamBuilder<DocumentSnapshot>(
      stream: accommodation.doc(widget.documentId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData && snapshot.data != null) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
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
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: "Name: ",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "${data['name']}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    nameController.text = data['name'];
                                    descriptionController.text = data['description'];
                                    placeController.text = data['place'];
                                    priceController.text = data['price'];
                                    editAnnouncementDetail(context, widget.documentId);
                                  },
                                  child: const Icon(Icons.edit, color: Colors.white),
                                ),
                                const SizedBox(width: 5.0),
                                GestureDetector(
                                  onTap: () async {
                                    widget.onDelete(widget.documentId);
                                  },
                                  child: const Icon(Icons.delete, color: Colors.white),
                                )
                              ],
                            ),
                            const SizedBox(height: 3.0),
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Description: ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${data['description']}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 3.0),
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Place: ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${data['place']}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 3.0),
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Price: ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${data['price']}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 3.0),
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Start Date: ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${data['start_date']}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 3.0),
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "End Date: ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${data['end_date']}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ],
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
                const SizedBox(
                  width: 60.0,
                ),
              ],
            ),
            _buildTextField("Name", nameController),
            _buildTextField("Description", descriptionController),
            _buildTextField("Place", placeController),
            _buildTextField("Price", priceController),
            _buildDateField("Start Date", true, startDateController),
            _buildDateField("End Date", false, endDateController),
            Center(
                child: ElevatedButton(
                    onPressed: () async {
                      if (_validateForm()) {
                        Map<String, dynamic> updateInfoMap = {
                          "name": nameController.text,
                          "description": descriptionController.text,
                          "place": placeController.text,
                          "price": priceController.text,
                          "start_date": startDateController.text,
                          "end_date": endDateController.text,
                          "id": id,
                        };
                        await DatabaseMethods()
                            .updateDetails(updateInfoMap, id, "accommodation")
                            .then((value) {
                          Fluttertoast.showToast(
                              msg: "Updated successfully.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        });
                        Navigator.pop(
                          context,
                        );
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please fill all fields",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                    child: const Text("Update"))),
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
    return nameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        placeController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        startDateController.text.isNotEmpty &&
        endDateController.text.isNotEmpty;
  }
}
