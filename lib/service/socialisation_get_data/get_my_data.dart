import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:iztechlife/service/socialisation_get_data/show_participants.dart';
import '../database.dart';

class GetMyData extends StatelessWidget {
  final String documentId;
  final Function(String) onDelete;
  final user = FirebaseAuth.instance.currentUser!;
  GetMyData({super.key, required this.documentId, required this.onDelete});
  final hourFormat = DateFormat("HH:mm");
  final dateFormat = DateFormat("dd-MM-yyyy");
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController quotaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference socialisation =
    FirebaseFirestore.instance.collection('socialisation');
    return StreamBuilder<DocumentSnapshot>(
      stream: socialisation.doc(documentId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData && snapshot.data != null) {
            Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
            if (user.uid == data['user_id']) {
              List<String> participants = [];
              if (data['participants'] != null) {
                participants = List<String>.from(data['participants']);
              }
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
                                          text: "Date: ",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "${data['date']}",
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
                                    descriptionController.text = data['description'];
                                    locationController.text = data['location'];
                                    dateController.text = data['date'];
                                    timeController.text = data['time'];
                                    quotaController.text = data['quota'];
                                    editAnnouncementDetail(context, documentId);
                                  },
                                  child: const Icon(Icons.edit, color: Colors.white),
                                ),
                                const SizedBox(width: 5.0),
                                GestureDetector(
                                  onTap: () async {
                                    onDelete(documentId);
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
                                    text: "Time: ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${data['time']}",
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
                                    text: "Location: ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${data['location']}",
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
                                    text: "Quota: ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${data['quota']}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 3.0),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShowParticipantsPage(participants: participants, documentId: documentId),
                                  ),
                                );
                              },
                              child: const Text(
                                "Show Participants",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB71C1C),
                                ),
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

  Future editAnnouncementDetail(BuildContext context, String id) async {
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('socialisation').doc(id).get();
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    List<String> participants = List<String>.from(data['participants'] ?? []);

    return showDialog(
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
              _buildTextField("Description", descriptionController),
              _buildTextField("Location", locationController),
              _buildDateField("Date", dateController),
              _buildTimeField("Time", timeController),
              _buildQuotaField("Quota", quotaController),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_validateForm(participants.length)) {
                      Map<String, dynamic> updateInfoMap = {
                        "description": descriptionController.text,
                        "location": locationController.text,
                        "date": dateController.text,
                        "time": timeController.text,
                        "quota": quotaController.text,
                        "id": id,
                      };
                      await DatabaseMethods()
                          .updateDetails(updateInfoMap, id, "socialisation")
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
                          msg: "Quota cannot be less than the number of participants.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
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
  }

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

  Widget _buildDateField(
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
            format: dateFormat,
            onShowPicker: (context, currentValue) async {
              final date = await showDatePicker(
                context: context,
                initialDate: currentValue ?? DateTime.now(),
                firstDate: DateTime.now(),
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

  Widget _buildQuotaField(
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
          child: TextFormField(
            controller: inputController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            cursorColor: const Color(0xFFB71C1C),
          ),
        ),
        const SizedBox(height: 15.0),
      ],
    );
  }

  bool _validateForm(int participantCount) {
    if (descriptionController.text.isEmpty ||
        locationController.text.isEmpty ||
        dateController.text.isEmpty ||
        timeController.text.isEmpty ||
        quotaController.text.isEmpty ||
        int.parse(quotaController.text) <= 0) {
      return false;
    }
    if (int.parse(quotaController.text) < participantCount) {
      return false;
    }
    return true;
  }
}