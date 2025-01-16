import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'public_data_screen.dart';
import 'about_screen.dart';
import 'hot_topic.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    PublicDataScreen(),
    HotTopicScreen(), // Halaman Hot Topics
    Center(
        child: Text('Admin Page',
            style: TextStyle(fontSize: 24))), // Placeholder Admin Page
    AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.black, // Warna background navbar
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white, // Warna icon dan teks (default)
            activeColor: Colors.black, // Warna aktif (untuk icon & teks aktif)
            tabBackgroundColor:
                Colors.white.withOpacity(0.5), // Transparansi warna saat aktif
            gap: 8,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            tabs: const [
              GButton(
                icon: Icons.public,
                text: 'Public News',
              ),
              GButton(
                icon: Icons.whatshot,
                text: 'Hot Topics',
              ),
              GButton(
                icon: Icons.admin_panel_settings,
                text: 'Admin',
              ),
              GButton(
                icon: Icons.info,
                text: 'About',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
