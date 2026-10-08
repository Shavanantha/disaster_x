import 'package:flutter/material.dart';
import '../../services/dummy_data.dart';
import '../../services/storage_service.dart';
import '../../widgets/icon_helper.dart';
import 'interactive_simulation_screen.dart';

class SimulasiScreen extends StatefulWidget {
  const SimulasiScreen({super.key});

  @override
  State<SimulasiScreen> createState() => _SimulasiScreenState();
}

class _SimulasiScreenState extends State<SimulasiScreen> {
  Map<String, int> _scores = {};

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    final scores = await StorageService.getSimulationScores();
    if (mounted) {
      setState(() {
        _scores = scores;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final skenarioUtama = DummyData.daftarSkenario.first;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('Simulasi Tanggap Bencana', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Banner Simulasi Unggulan
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE53935), Color(0xFFFF7043)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.redAccent.withValues(alpha: 0.3),
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
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Skor Terbaik: ${_scores[skenarioUtama.id] ?? 0}',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  skenarioUtama.judul,
                  style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  skenarioUtama.deskripsi,
                  style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.35),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.redAccent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InteractiveSimulationScreen(skenario: skenarioUtama),
                      ),
                    );
                    _loadScores();
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Mulai Simulasi Sekarang', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Judul Koleksi Skenario
          const Text('Koleksi Skenario Bencana Interaktif', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          // Daftar Semua Skenario Bencana
          ...DummyData.daftarSkenario.map((skenario) {
            final bestScore = _scores[skenario.id];
            final color = Color(skenario.warnaHex);

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InteractiveSimulationScreen(skenario: skenario),
                      ),
                    );
                    _loadScores();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(getDisasterIcon(skenario.iconCode), color: color, size: 26),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                skenario.judul,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    skenario.kategori,
                                    style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text('•', style: TextStyle(color: Colors.grey, fontSize: 11)),
                                  const SizedBox(width: 6),
                                  Icon(Icons.schedule_rounded, size: 12, color: Colors.grey.shade500),
                                  const SizedBox(width: 4),
                                  Text(skenario.durasi, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                  if (bestScore != null) ...[
                                    const SizedBox(width: 6),
                                    const Text('•', style: TextStyle(color: Colors.grey, fontSize: 11)),
                                    const SizedBox(width: 6),
                                    Text('Skor: $bestScore', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green)),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.play_circle_fill_rounded, color: color, size: 32),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
