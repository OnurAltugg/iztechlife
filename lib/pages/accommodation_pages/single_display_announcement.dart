import 'package:flutter/material.dart';

class SingleDisplayAnnouncement extends StatelessWidget {
  final String user_name, user_email, name, description, place, price, start_date, end_date;

  const SingleDisplayAnnouncement({
    super.key,
    required this.user_name,
    required this.user_email,
    required this.name,
    required this.description,
    required this.place,
    required this.price,
    required this.start_date,
    required this.end_date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB6ABAB), // Scaffold background color
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildText("Name", name),
              const SizedBox(height: 15.0),
              _buildText("Description", description),
              const SizedBox(height: 15.0),
              _buildText("Place", place),
              const SizedBox(height: 15.0),
              _buildText("Price", price),
              const SizedBox(height: 15.0),
              _buildText("Start Date", start_date),
              const SizedBox(height: 15.0),
              _buildText("End Date", end_date),
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
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
