import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SingleDisplayAnnouncement extends StatelessWidget {
  final String user_name, user_email, name, description, car_info, date, time, departure, destination, quota;

  const SingleDisplayAnnouncement({
    super.key,
    required this.user_name,
    required this.user_email,
    required this.name,
    required this.description,
    required this.car_info,
    required this.date,
    required this.time,
    required this.departure,
    required this.destination,
    required this.quota
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB6ABAB), // Scaffold background color
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildText("Name", name),
              const SizedBox(height: 15.0),
              _buildText("Description", description),
              const SizedBox(height: 15.0),
              _buildText("Car Info", car_info),
              const SizedBox(height: 15.0),
              _buildText("Date", date),
              const SizedBox(height: 15.0),
              _buildText("Time", time),
              const SizedBox(height: 15.0),
              _buildText("Departure Location", departure),
              const SizedBox(height: 15.0),
              _buildText("Destination Location", destination),
              const SizedBox(height: 15.0),
              _buildText("Quota", quota),
              const SizedBox(height: 15.0),
              _buildText("Created By", user_name),
              const SizedBox(height: 15.0),
              _buildText("Email", user_email),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildText(String label, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
