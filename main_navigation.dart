import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'materi_screen.dart';
import 'simulasi_screen.dart';
import 'kuis_screen.dart';
import 'profil_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Kelima halaman utama aplikasi
  final List<Widget> _pages = [
    const HomeScreen(),
    const MateriScreen(),
    const SimulasiScreen(),
    const KuisScreen(),
    const ProfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_rounded), label: 'Materi'),
          BottomNavigationBarItem(icon: Icon(Icons.play_circle_outline_rounded), label: 'Simulasi'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Kuis'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Profil'),
        ],
      ),
    );
  }
}