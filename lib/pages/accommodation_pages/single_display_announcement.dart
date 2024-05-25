import 'package:flutter/material.dart';

import '../lost_property_pages/full_screen_image.dart';
import '../main_page.dart';

class SingleDisplayAnnouncement extends StatefulWidget {
  final String userName, userEmail, userPhone, description, place, price, startDate, endDate;
  final List<String> imageUrls;

  const SingleDisplayAnnouncement({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.description,
    required this.place,
    required this.price,
    required this.startDate,
    required this.endDate,
    required this.imageUrls,
  });

  @override
  _SingleDisplayAnnouncementState createState() => _SingleDisplayAnnouncementState();
}

class _SingleDisplayAnnouncementState extends State<SingleDisplayAnnouncement> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
              "Accommodation Service",
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
              _buildPhoto(context, "Photos", widget.imageUrls),
              const SizedBox(height: 15.0),
              _buildText("Description", widget.description),
              const SizedBox(height: 15.0),
              _buildText("Place", widget.place),
              const SizedBox(height: 15.0),
              _buildText("Price", widget.price),
              const SizedBox(height: 15.0),
              _buildText("Start Date", widget.startDate),
              const SizedBox(height: 15.0),
              _buildText("End Date", widget.endDate),
              const SizedBox(height: 15.0),
              _buildText("Created By", widget.userName),
              const SizedBox(height: 15.0),
              _buildText("Email", widget.userEmail),
              const SizedBox(height: 15.0),
              if (widget.userPhone != "")
                _buildText("Phone", widget.userPhone),
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

  Widget _buildPhoto(BuildContext context, String label, List<String> imageUrls) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4.0),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FullScreenImage(imageUrl: imageUrls[_currentPage]),
              ),
            );
          },
          child: SizedBox(
            height: 300,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.network(
                          imageUrls[index],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Text('Error Loading Image'),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white,),
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Colors.white,),
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }



}
