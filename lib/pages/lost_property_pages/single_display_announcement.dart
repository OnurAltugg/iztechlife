import 'package:flutter/material.dart';

import 'full_screen_image.dart';

class SingleDisplayAnnouncement extends StatelessWidget {
  final String user_name, user_email, name, description, location, date, time, image_url;

  const SingleDisplayAnnouncement({
    super.key,
    required this.user_name,
    required this.user_email,
    required this.name,
    required this.description,
    required this.location,
    required this.date,
    required this.time,
    required this.image_url,
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
              _buildText("Location", location),
              const SizedBox(height: 15.0),
              _buildText("Date", date),
              const SizedBox(height: 15.0),
              _buildText("Time", time),
              const SizedBox(height: 15.0),
              _buildPhoto(context, "Photo", image_url),
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
