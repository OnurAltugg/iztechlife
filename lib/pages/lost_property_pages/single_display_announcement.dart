import 'package:flutter/material.dart';

import '../main_page.dart';
import 'full_screen_image.dart';

class SingleDisplayAnnouncement extends StatelessWidget {
  final String userName, userEmail, userPhone, description, location, date, time, imageUrl;

  const SingleDisplayAnnouncement({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.description,
    required this.location,
    required this.date,
    required this.time,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB6ABAB), // Scaffold background color
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
              "Lost Property Service",
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildText("Description", description),
              const SizedBox(height: 15.0),
              _buildText("Location", location),
              const SizedBox(height: 15.0),
              _buildText("Date", date),
              const SizedBox(height: 15.0),
              _buildText("Time", time),
              const SizedBox(height: 15.0),
              _buildPhoto(context, "Photo", imageUrl),
              const SizedBox(height: 15.0),
              _buildText("Created By", userName),
              const SizedBox(height: 15.0),
              _buildText("Email", userEmail),
              const SizedBox(height: 15.0),
              if(userPhone != "")
                _buildText("Phone", userPhone),
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

  Widget _buildPhoto(BuildContext context, String label, String imageUrl) {
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
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FullScreenImage(imageUrl: imageUrl),
                ),
              );
            },
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: 400,
              height: 400,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return const Center(
                    child: Text(
                      'Loading Image...',
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
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
    );
  }
}
