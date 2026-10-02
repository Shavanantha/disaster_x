import 'package:flutter/material.dart';

class MateriScreen extends StatelessWidget {
  const MateriScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('E-LKPD & Materi', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Banner Capaian Pembelajaran
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.school_rounded, color: Colors.redAccent, size: 36),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Capaian Pembelajaran',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.redAccent),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Memahami langkah mitigasi prabencana, saat darurat, dan pascabencana secara mandiri.',
                        style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text('Modul Simulasi Bencana', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          // Daftar Kartu Modul
          _buildModulCard(
            title: 'Mitigasi Gempa Bumi',
            desc: 'Teknik Drop, Cover, Hold On dan jalur evakuasi aman.',
            icon: Icons.landscape_rounded,
            color: Colors.orange,
            progress: '100% Selesai',
            progressColor: Colors.green,
          ),
          const SizedBox(height: 12),
          _buildModulCard(
            title: 'Mitigasi Kebakaran Gedung',
            desc: 'Penggunaan APAR dan simulasi bahaya asap tebal.',
            icon: Icons.local_fire_department_rounded,
            color: Colors.redAccent,
            progress: 'Sedang Berjalan',
            progressColor: Colors.orange,
          ),
          const SizedBox(height: 12),
          _buildModulCard(
            title: 'Mitigasi Banjir Luapan',
            desc: 'Penyelamatan dokumen dan penanganan arus deras.',
            icon: Icons.water_rounded,
            color: Colors.blueAccent,
            progress: 'Belum Mulai',
            progressColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildModulCard({
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
    required String progress,
    required Color progressColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: progressColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    progress,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: progressColor),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}