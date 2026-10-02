import 'package:flutter/material.dart';
import 'interactive_simulation_screen.dart';

class SimulasiScreen extends StatelessWidget {
  const SimulasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text(
          'Simulasi Interaktif',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Banner Simulasi Berjalan / Unggulan
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE53935), Color(0xFFFF7043)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.redAccent.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.videocam_rounded, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Skenario Utama',
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Tingkat: Menengah',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Evakuasi Gempa di Lantai 3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Uji reflek dan pengambilan keputusanmu saat gempa 6.5 SR mengguncang gedung sekolah.',
                  style: TextStyle(color: Colors.white, fontSize: 12, height: 1.3),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.redAccent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const InteractiveSimulationScreen()),
                    );
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Mulai Simulasi Sekarang', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Judul Daftar Skenario
          const Text(
            'Koleksi Skenario Bencana',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Daftar Card Skenario
          _buildScenarioItem(
            context,
            title: 'Skenario 1: Korsleting Listrik Lab Komputer',
            category: 'Kebakaran',
            duration: '4 Menit',
            icon: Icons.local_fire_department_rounded,
            color: Colors.redAccent,
            badge: 'Tersedia',
          ),
          const SizedBox(height: 12),
          _buildScenarioItem(
            context,
            title: 'Skenario 2: Evakuasi Cepat Gempa Kelas',
            category: 'Gempa Bumi',
            duration: '5 Menit',
            icon: Icons.landscape_rounded,
            color: Colors.orange,
            badge: 'Tersedia',
          ),
          const SizedBox(height: 12),
          _buildScenarioItem(
            context,
            title: 'Skenario 3: Bertahan saat Tanggul Jebol',
            category: 'Banjir',
            duration: '6 Menit',
            icon: Icons.water_rounded,
            color: Colors.blueAccent,
            badge: 'Terkunci',
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioItem(
    BuildContext context, {
    required String title,
    required String category,
    required String duration,
    required IconData icon,
    required Color color,
    required String badge,
  }) {
    final bool isLocked = badge == 'Terkunci';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isLocked ? Colors.grey.shade200 : color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isLocked ? Icons.lock_rounded : icon,
              color: isLocked ? Colors.grey : color,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isLocked ? Colors.grey : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      category,
                      style: TextStyle(fontSize: 11, color: isLocked ? Colors.grey : color, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    const Text('•', style: TextStyle(color: Colors.grey, fontSize: 11)),
                    const SizedBox(width: 8),
                    Icon(Icons.schedule_rounded, size: 12, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(duration, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.play_circle_fill_rounded,
            color: isLocked ? Colors.grey.shade300 : color,
            size: 32,
          ),
        ],
      ),
    );
  }
}