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

  static const Color _navy = Color(0xFF172B4D);
  static const Color _blue = Color(0xFF3478F6);
  static const Color _muted = Color(0xFF929DB0);

  void _switchTab(int index) {
    if (_currentIndex == index) return;

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
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFE9EDF4),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _navy.withValues(alpha: 0.09),
                blurRadius: 24,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              _buildNavItem(
                index: 0,
                label: 'Beranda',
                icon: Icons.home_rounded,
                activeIcon: Icons.home_rounded,
              ),
              _buildNavItem(
                index: 1,
                label: 'Materi',
                icon: Icons.menu_book_outlined,
                activeIcon: Icons.menu_book_rounded,
              ),
              _buildNavItem(
                index: 2,
                label: 'Simulasi',
                icon: Icons.play_circle_outline_rounded,
                activeIcon: Icons.play_circle_fill_rounded,
              ),
              _buildNavItem(
                index: 3,
                label: 'Kuis',
                icon: Icons.assignment_outlined,
                activeIcon: Icons.assignment_rounded,
              ),
              _buildNavItem(
                index: 4,
                label: 'Profil',
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData icon,
    required IconData activeIcon,
  }) {
    final bool isSelected = _currentIndex == index;

    return Expanded(
      child: Semantics(
        button: true,
        selected: isSelected,
        label: label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(17),
            onTap: () => _switchTab(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(
                vertical: 9,
                horizontal: 2,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFEAF1FF)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(17),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: Icon(
                      isSelected ? activeIcon : icon,
                      key: ValueKey('$index-$isSelected'),
                      size: 23,
                      color: isSelected ? _blue : _muted,
                    ),
                  ),
                  const SizedBox(height: 5),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 180),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w500,
                      color: isSelected ? _navy : _muted,
                    ),
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 3),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: isSelected ? 15 : 4,
                    height: 3,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _blue
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}