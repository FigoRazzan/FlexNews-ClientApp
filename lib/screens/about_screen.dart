import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About US'),
        backgroundColor: Colors.grey[200],
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container for About and Developers Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(60),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: 24),
                  // Application Logo and Description
                  Column(
                    children: [
                      Image.asset(
                        'assets/splash_screens_2.png',
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'FLEX',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          'FLEX adalah aplikasi berita yang menyajikan informasi terbaru, segar, dan eksklusif dari berbagai bidang. Dengan tampilan yang simpel dan mudah digunakan, FLEX memungkinkan pengguna untuk mendapatkan berita secara real-time dan fleksibel, kapan saja dan di mana saja. Aplikasi ini menyediakan berbagai kategori berita yang dapat disesuaikan dengan minat pengguna, memberikan wawasan yang relevan dan up-to-date. Dengan fitur personalisasi dan notifikasi, FLEX memastikan setiap informasi yang diterima adalah yang paling penting dan menarik untuk Anda.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Developers Section
                  Column(
                    children: [
                      ProfileContainer(
                        name: 'Muhammad Figo Razzan Fadillah',
                        nrp: '152022064',
                        email: 'figorazzan10@gmail.com',
                        imagePath: 'assets/foto_figo.jpg',
                        waveColor: Colors.deepOrange.shade800,
                      ),
                      SizedBox(height: 16),
                      ProfileContainer(
                        name: 'Dimas Bratakusuma',
                        nrp: '152022044',
                        email: 'dimas@gmail.com',
                        imagePath: 'assets/foto_dimas.jpg',
                        waveColor: Colors.blue.shade800,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileContainer extends StatelessWidget {
  final String name;
  final String nrp;
  final String email;
  final String imagePath;
  final Color waveColor;

  const ProfileContainer({
    Key? key,
    required this.name,
    required this.nrp,
    required this.email,
    required this.imagePath,
    required this.waveColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 350,
      child: Stack(
        children: [
          // Background Container with border radius
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
          ),
          // Wave Decoration
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CustomPaint(
              size: Size(double.infinity, 300),
              painter: WavePainter(waveColor),
            ),
          ),
          // Profile Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Profile Picture
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Name
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                // NRP
                Text(
                  'NRP: $nrp',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 4),
                // Email
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final Color waveColor;

  WavePainter(this.waveColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.fill;

    final path = Path();

    // Starting point
    path.moveTo(0, 0);

    // First wave
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.6,
      size.width * 0.5,
      size.height * 0.35,
    );

    // Second wave
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.4,
      size.width,
      size.height * 0.7,
    );

    // Complete the shape
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
