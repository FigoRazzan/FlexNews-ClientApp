import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flex News App',
      debugShowCheckedModeBanner: false, // Hilangkan banner debug
      home: SplashScreen(), // SplashScreen sebagai layar awal
    );
  }
}
