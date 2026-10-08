import 'package:flutter/material.dart';

class TentangAplikasiScreen extends StatelessWidget {
  const TentangAplikasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('Tentang DISASTER-X', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Logo & Versi
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFEBEE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.warning_amber_rounded, size: 48, color: Colors.redAccent),
                ),
                const SizedBox(height: 14),
                const Text(
                  'DISASTER-X v1.0.0',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Digital Interactive Simulation for Adaptive Emergency Response',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Card Informasi Akademik
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Informasi Pengembang & Tugas Kuliah', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                SizedBox(height: 10),
                Text('• Pengembang: Shava Phiyan Anantha', style: TextStyle(fontSize: 12, color: Colors.black87)),
                SizedBox(height: 4),
                Text('• NIM: 2413025047', style: TextStyle(fontSize: 12, color: Colors.black87)),
                SizedBox(height: 4),
                Text('• Mata Kuliah: Mobile Programming', style: TextStyle(fontSize: 12, color: Colors.black87)),
                SizedBox(height: 4),
                Text('• Framework: Flutter 3.47 (Dart 3)', style: TextStyle(fontSize: 12, color: Colors.black87)),
                SizedBox(height: 4),
                Text('• Arsitektur: Component-Driven + SharedPreferences Persistence', style: TextStyle(fontSize: 12, color: Colors.black87)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Deskripsi Aplikasi
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Tujuan Aplikasi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                SizedBox(height: 8),
                Text(
                  'DISASTER-X dirancang sebagai media pembelajaran interaktif bagi siswa dan mahasiswa '
                  'untuk meningkatkan kesiapsiagaan menghadapi situasi darurat bencana alam dan kebakaran. '
                  'Aplikasi ini memadukan materi komprehensif berstandar BNPB, simulasi pengambilan keputusan '
                  'real-time (interactive branching simulation), kuis evaluasi berwaktu, checklist ransel darurat 72 jam, '
                  'serta hotline panggilan darurat.',
                  style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.45),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Center(
            child: Text(
              'Hak Cipta © 2026 DISASTER-X. All rights reserved.',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
