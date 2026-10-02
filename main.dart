import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const DisasterXApp());
}

class DisasterXApp extends StatelessWidget {
  const DisasterXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DISASTER-X',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}