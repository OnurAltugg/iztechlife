import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:iztechlife/pages/find_house_pages/find_house_features.dart';
import 'package:random_string/random_string.dart';

import '../../service/database.dart';

class CreateAnnouncement extends StatefulWidget {
  const CreateAnnouncement({super.key});

  @override
  State<CreateAnnouncement> createState() => _CreateAnnouncementState();
}

class _CreateAnnouncementState extends State<CreateAnnouncement> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController placeController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController startDateController = new TextEditingController();
  TextEditingController endDateController = new TextEditingController();

  final dateFormat = DateFormat("dd-MM-yyyy");
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB6ABAB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB6ABAB),
        title: const Row(
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
      body: SingleChildScrollView(
        child: Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField("Name", nameController),
              _buildTextField("Description", descriptionController),
              _buildTextField("Place", placeController),
              _buildTextField("Price", priceController),
              _buildDateField("Start Date", true, startDateController),
              _buildDateField("End Date", false, endDateController),
              const SizedBox(height: 15.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    String Id = randomAlphaNumeric(10);
                    Map<String ,dynamic> findHouseInfoMap = {
                      "Name": nameController.text,
                      "Description": descriptionController.text,
                      "Place": placeController.text,
                      "Price": priceController.text,
                      "Start Date": startDateController.text,
                      "End Date": endDateController.text,
                      "Id": Id,
                    };
                    await DatabaseMethods().addFindHouseDetails(findHouseInfoMap, Id).then((value){
                      Fluttertoast.showToast(
                          msg: "Find a House details added successfully.",
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
                      MaterialPageRoute(builder: (context) => const FindHouseFeatures()),
                    );
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
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(border: InputBorder.none),
            cursorColor: Color(0xFFB71C1C),
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
}
