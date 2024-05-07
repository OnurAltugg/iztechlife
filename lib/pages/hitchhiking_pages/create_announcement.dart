import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:iztechlife/pages/hitchhiking_pages/hitchhiking_features.dart';
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
  TextEditingController carInfoController = new TextEditingController();
  TextEditingController departureLocationController = new TextEditingController();
  TextEditingController destinationLocationController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();
  TextEditingController timeController = new TextEditingController();
  TextEditingController quotaController = new TextEditingController();

  final hourFormat = DateFormat("HH:mm");
  final dateFormat = DateFormat("dd-MM-yyyy");

  @override
  void dispose() {
    quotaController.dispose();
    super.dispose();
  }

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
              _buildTextField("Car Info", carInfoController),
              _buildTextField("Departure Location", departureLocationController),
              _buildTextField("Destination Location", destinationLocationController),
              _buildDateField("Date", dateController),
              _buildTimeField("Time", timeController),
              _buildQuotaField("Quota", quotaController),
              const SizedBox(height: 15.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    String Id = randomAlphaNumeric(10);
                    Map<String ,dynamic> hitchhikingInfoMap = {
                      "Name": nameController.text,
                      "Description": descriptionController.text,
                      "Car Info": carInfoController.text,
                      "Departure Location": departureLocationController.text,
                      "Destination Location": destinationLocationController.text,
                      "Date": dateController.text,
                      "Time": timeController.text,
                      "Quota": quotaController.text,
                      "Id": Id,
                    };
                    await DatabaseMethods().addHitchhikingDetails(hitchhikingInfoMap, Id).then((value){
                      Fluttertoast.showToast(
                          msg: "Hitchhiking details added successfully.",
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
                      MaterialPageRoute(builder: (context) => const HitchhikingFeatures()),
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

  Widget _buildQuotaField(String labelText, TextEditingController inputController) {
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
}
