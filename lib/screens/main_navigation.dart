import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'materi/materi_screen.dart';
import 'simulasi/simulasi_screen.dart';
import 'kuis/kuis_screen.dart';
import 'profil/profil_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  void _switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(onTabChange: _switchTab),
      const MateriScreen(),
      const SimulasiScreen(),
      const KuisScreen(),
      const ProfilScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
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
