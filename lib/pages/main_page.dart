import 'package:flutter/material.dart';
import 'package:iztechlife/pages/find_house_pages/find_house_features.dart';
import 'package:iztechlife/pages/hitchhiking_pages/hitchhiking_features.dart';
import 'package:iztechlife/pages/lost_property_pages/lost_property_features.dart';
import 'package:iztechlife/pages/profile.dart';
import 'package:iztechlife/pages/socialisation_pages/socialisation_features.dart';

import 'feedback_pages/feedback_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFB6ABAB),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "IZTECH",
              style: TextStyle(
                color: Color(0xFFB71C1C),
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Life",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        color: const Color(0xFFB6ABAB),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Profile()),
                    );
                  },
                  icon: const Icon(Icons.face, size: 40, color: Colors.black),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FeedbackPage()),
                    );
                  },
                  icon: const Icon(Icons.feedback_outlined, size: 40, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 50),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HitchhikingFeatures()),
                );
              },
              icon: const Icon(Icons.assistant_navigation, size: 30, color: Colors.white,),
              label: const Text('Hitchhiking', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                textStyle: const TextStyle(fontSize: 20),
                backgroundColor: const Color(0xFFB71C1C),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SocialisationFeatures()),
                );
              },
              icon: const Icon(Icons.groups, size: 30, color: Colors.white,),
              label: const Text('Socialisation', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                textStyle: const TextStyle(fontSize: 20),
                backgroundColor: const Color(0xFFB71C1C),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LostPropertyFeatures()),
                );
              },
              icon: const Icon(Icons.search, size: 30, color: Colors.white,),
              label: const Text('Lost Property', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                textStyle: const TextStyle(fontSize: 20),
                backgroundColor: const Color(0xFFB71C1C),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FindHouseFeatures()),
                );
              },
              icon: const Icon(Icons.home, size: 30, color: Colors.white,),
              label: const Text('Find a House', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                textStyle: const TextStyle(fontSize: 20),
                backgroundColor: const Color(0xFFB71C1C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
