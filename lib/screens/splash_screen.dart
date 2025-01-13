import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import halaman utama

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  // Fungsi untuk navigasi ke HomeScreen setelah delay
  void _navigateToHome() async {
    await Future.delayed(Duration(seconds: 9), () {}); // Durasi splash screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA), // Warna latar belakang #FAFAFA
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gambar di tengah
            Image.asset(
              'assets/splash_screens_2.png', // Path gambar
              height: 200, // Tinggi gambar
              width: 200, // Lebar gambar
              fit: BoxFit.contain, // Menyesuaikan gambar
            ),
            SizedBox(height: 20), // Spasi antara gambar dan teks
            // Teks aesthetic
            Column(
              children: [
                Text(
                  'Welcome To FLEX',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia', // Font bergaya
                    color: Colors.black87, // Warna teks
                  ),
                ),
                SizedBox(height: 5), // Spasi kecil
                Text(
                  'Your Daily Dose of Fresh & Exclusive News',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic, // Teks miring
                    color: Colors.grey[700], // Warna teks abu-abu
                  ),
                  textAlign: TextAlign.center, // Teks rata tengah
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
