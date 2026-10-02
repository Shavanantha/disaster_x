import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('Beranda', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Pengguna (Halo, Shava! - Level Siaga)
            Row(
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: Color(0xFFFFEBEE),
                  child: Icon(Icons.person, size: 30, color: Colors.redAccent),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Halo, Shava!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Level: Siaga', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Card Progress Belajar (90%)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Progress Belajar', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
                      Text('90%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.redAccent)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const LinearProgressIndicator(
                      value: 0.9,
                      minHeight: 10,
                      backgroundColor: Color(0xFFEEEEEE),
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Terus tingkatkan kesiapsiagaanmu!', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4 Tombol Menu Utama (Grid 2x2)
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.35,
              children: [
                _buildQuickMenu(Icons.menu_book_rounded, 'Materi & Video', Colors.orange),
                _buildQuickMenu(Icons.play_circle_fill_rounded, 'Simulasi Bencana', Colors.redAccent),
                _buildQuickMenu(Icons.assignment_turned_in_rounded, 'Kuis Evaluasi', Colors.blue),
                _buildQuickMenu(Icons.bar_chart_rounded, 'Riwayat Nilai', Colors.green),
              ],
            ),
            const SizedBox(height: 24),

            // Bagian Berita & Tips
            const Text('Berita & Tips', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildTipsCard('5 Hal yang Harus Dilakukan Saat Gempa', 'Kenali tindakan aman saat terjadi gempa bumi', Icons.landscape_rounded),
            const SizedBox(height: 10),
            _buildTipsCard('Tips Aman Saat Terjadi Kebakaran', 'Ketahui cara memilih jalur evakuasi yang aman', Icons.local_fire_department_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickMenu(IconData icon, String label, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: color),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildTipsCard(String title, String desc, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            child: Icon(icon, color: Colors.redAccent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(desc, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        ],
      ),
    );
  }
}