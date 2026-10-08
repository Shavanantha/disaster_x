import 'package:flutter/material.dart';
import '../../models/bencana_model.dart';
import '../../services/dummy_data.dart';
import '../../services/storage_service.dart';
import '../../widgets/icon_helper.dart';
import 'materi_detail_screen.dart';

class MateriScreen extends StatefulWidget {
  const MateriScreen({super.key});

  @override
  State<MateriScreen> createState() => _MateriScreenState();
}

class _MateriScreenState extends State<MateriScreen> {
  List<String> _completedIds = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final list = await StorageService.getCompletedModules();
    if (mounted) {
      setState(() {
        _completedIds = list;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredModul = DummyData.daftarModul.where((modul) {
      return modul.judul.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          modul.kategori.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          modul.ringkasan.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('E-LKPD & Modul Materi', style: TextStyle(fontWeight: FontWeight.bold)),
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
              color: Colors.redAccent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
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
                        'Capaian Pembelajaran (CP)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.redAccent),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Memahami langkah mitigasi prabencana, saat darurat, dan pascabencana secara mandiri dan adaptif.',
                        style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Search Field
          TextField(
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
            decoration: InputDecoration(
              hintText: 'Cari materi atau jenis bencana...',
              hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
              prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
            ),
          ),
          const SizedBox(height: 18),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Modul Simulasi Bencana', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(
                '${_completedIds.length} dari ${DummyData.daftarModul.length} Selesai',
                style: const TextStyle(fontSize: 12, color: Colors.redAccent, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Daftar Modul Bencana
          if (filteredModul.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              alignment: Alignment.center,
              child: const Text('Tidak ada materi yang sesuai pencarian.', style: TextStyle(color: Colors.grey)),
            )
          else
            ...filteredModul.map((modul) {
              final isDone = _completedIds.contains(modul.id);
              final color = Color(modul.warnaHex);
              return _buildModulCard(
                modul: modul,
                color: color,
                isDone: isDone,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MateriDetailScreen(
                        modul: modul,
                        isCompleted: isDone,
                      ),
                    ),
                  );
                  _loadProgress();
                },
              );
            }),
        ],
      ),
    );
  }

  Widget _buildModulCard({
    required BencanaModul modul,
    required Color color,
    required bool isDone,
    required VoidCallback onTap,
  }) {
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
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: color.withValues(alpha: 0.12),
                  child: Icon(getDisasterIcon(modul.ikon), color: color, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            modul.kategori,
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isDone ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isDone ? '✓ 100% Selesai' : 'Baca Sekarang',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isDone ? Colors.green : Colors.orange.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(modul.judul, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(
                        modul.ringkasan,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
