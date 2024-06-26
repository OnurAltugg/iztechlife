import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:iztechlife/service/hitchhiking_get_data/view_join_request.dart';

import '../database.dart';

class GetMyData extends StatelessWidget {
  final String documentId;
  final Function(String) onDelete;
  final user = FirebaseAuth.instance.currentUser!;
  GetMyData({super.key, required this.documentId, required this.onDelete});
  final hourFormat = DateFormat("HH:mm");
  final dateFormat = DateFormat("dd-MM-yyyy");
  TextEditingController descriptionController = TextEditingController();
  TextEditingController carInfoController = TextEditingController();
  TextEditingController departureLocationController = TextEditingController();
  TextEditingController destinationLocationController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController quotaController = TextEditingController();

  int _countParticipantsWithWaitingResponse(List<dynamic> participants) {
    return participants
        .where((participant) => participant is Map<String, dynamic> && participant['status'] == "waiting")
        .length;
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference hitchhiking =
    FirebaseFirestore.instance.collection('hitchhiking');
    return StreamBuilder<DocumentSnapshot>(
      stream: hitchhiking.doc(documentId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData && snapshot.data != null) {
            Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
            if (user.uid == data['user_id']) {
              List<Map<String, dynamic>> participants = [];
              if (data['participants'] != null) {
                participants = List<Map<String, dynamic>>.from(data['participants']);
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
                                    carInfoController.text = data['car_info'];
                                    departureLocationController.text = data['departure'];
                                    destinationLocationController.text = data['destination'];
                                    dateController.text = data['date'];
                                    timeController.text = data['time'];
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
                                    text: "Car Info: ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${data['car_info']}",
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
                                    text: "Departure Location: ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${data['departure']}",
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
                                    text: "Destination Location: ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${data['destination']}",
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
                                    builder: (context) => ViewJoinRequestsPage(participants: participants, documentId: documentId),
                                  ),
                                );
                              },
                              child: const Text(
                                "View Join Request",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB71C1C),
                                ),
                              ),
                            ),
                            if(_countParticipantsWithWaitingResponse(data['participants']) != 0)
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "${_countParticipantsWithWaitingResponse(data['participants'])} users are waiting for your answer.",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.0,
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
            _buildTextField("Description", descriptionController),
            _buildTextField("Car Info", carInfoController),
            _buildTextField("Departure Location", departureLocationController),
            _buildTextField("Destination Location", destinationLocationController),
            _buildDateField("Date", dateController),
            _buildTimeField("Time", timeController),
            Center(
                child: ElevatedButton(
                    onPressed: () async {
                      if (_validateForm()) {
                        Map<String, dynamic> updateInfoMap = {
                          "description": descriptionController.text,
                          "car_info": carInfoController.text,
                          "departure": departureLocationController.text,
                          "destination": destinationLocationController.text,
                          "date": dateController.text,
                          "time": timeController.text,
                          "id": id,
                        };
                        await DatabaseMethods()
                            .updateDetails(updateInfoMap, id, "hitchhiking")
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
            keyboardType: TextInputType.multiline,
            maxLines: null,
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

  bool _validateForm() {
    return descriptionController.text.isNotEmpty &&
        carInfoController.text.isNotEmpty &&
        departureLocationController.text.isNotEmpty &&
        destinationLocationController.text.isNotEmpty &&
        dateController.text.isNotEmpty &&
        timeController.text.isNotEmpty;
  }
}