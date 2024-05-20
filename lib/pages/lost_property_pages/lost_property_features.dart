import 'package:flutter/material.dart';
import 'package:iztechlife/pages/lost_property_pages/create_announcement.dart';
import 'package:iztechlife/pages/lost_property_pages/display_announcements.dart';
import 'package:iztechlife/pages/lost_property_pages/my_announcements.dart';
import '../main_page.dart';

class LostPropertyFeatures extends StatefulWidget {
  const LostPropertyFeatures({super.key});

  @override
  State<LostPropertyFeatures> createState() => _LostPropertyFeaturesState();
}

class _LostPropertyFeaturesState extends State<LostPropertyFeatures> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB6ABAB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB6ABAB),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainPage()),
                  (Route<dynamic> route) => false,
            );
          },
        ),
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
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
            const SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateAnnouncement()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB71C1C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 10),
                    Text(
                      'Create Announcement',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DisplayAnnouncements(),
                    ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB71C1C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 10),
                    Text(
                      'Display Announcements',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyAnnouncements(),
                    ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB71C1C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 10),
                    Text(
                      'My Announcements',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
