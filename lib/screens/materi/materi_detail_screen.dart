import 'package:flutter/material.dart';
import '../../models/bencana_model.dart';
import '../../services/storage_service.dart';
import '../../widgets/icon_helper.dart';

class MateriDetailScreen extends StatefulWidget {
  final BencanaModul modul;
  final bool isCompleted;

  const MateriDetailScreen({
    super.key,
    required this.modul,
    required this.isCompleted,
  });

  @override
  State<MateriDetailScreen> createState() => _MateriDetailScreenState();
}

class _MateriDetailScreenState extends State<MateriDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late bool _completed;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _completed = widget.isCompleted;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _selesaikanModul() async {
    await StorageService.markModuleCompleted(widget.modul.id);
    setState(() {
      _completed = true;
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text('Modul berhasil diselesaikan! Progress bertambah.'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Color(widget.modul.warnaHex);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text(widget.modul.judul, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: themeColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: themeColor,
          isScrollable: true,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          tabs: const [
            Tab(text: 'Prabencana (Siaga)'),
            Tab(text: 'Saat Kejadian (Aksi)'),
            Tab(text: 'Pascabencana (Pemulihan)'),
            Tab(text: "Do's & Don'ts"),
          ],
        ),
      ),
      body: Column(
        children: [
          // Banner Capaian Pembelajaran Modul
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: themeColor.withValues(alpha: 0.08),
              border: Border(bottom: BorderSide(color: themeColor.withValues(alpha: 0.2))),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: themeColor.withValues(alpha: 0.15),
                  child: Icon(getDisasterIcon(widget.modul.ikon), color: themeColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Target Kompetensi Siswa:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: themeColor),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.modul.capaian,
                        style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.25),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Isi Tab Konten
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildListTab('Langkah Kesiapsiagaan Prabencana', widget.modul.prabencana, Icons.shield_outlined, themeColor),
                _buildListTab('Tindakan Cepat Saat Bencana Terjadi', widget.modul.saatBencana, Icons.warning_rounded, Colors.redAccent),
                _buildListTab('Prosedur Keselamatan Pascabencana', widget.modul.pascabencana, Icons.health_and_safety_outlined, Colors.teal),
                _buildDosDontsTab(themeColor),
              ],
            ),
          ),

          // Tombol Selesaikan Modul di Bagian Bawah
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, -2)),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _completed ? Colors.green : themeColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _completed ? null : _selesaikanModul,
                icon: Icon(_completed ? Icons.check_circle_rounded : Icons.bookmark_added_rounded),
                label: Text(
                  _completed ? 'Modul Telah Diselesaikan (100%)' : 'Tandai Selesai Membaca Modul',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTab(String title, List<String> items, IconData icon, Color color) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 12),
        ...items.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final item = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: color.withValues(alpha: 0.12),
                  child: Text(
                    '$index',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDosDontsTab(Color themeColor) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Bagian DO'S (Dianjurkan)
        Row(
          children: const [
            Icon(Icons.check_circle_rounded, color: Colors.green, size: 20),
            SizedBox(width: 8),
            Text("Hal yang DIANJURKAN (Do's)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.green)),
          ],
        ),
        const SizedBox(height: 8),
        ...widget.modul.dos.map(
          (text) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                const Icon(Icons.check, color: Colors.green, size: 18),
                const SizedBox(width: 10),
                Expanded(child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.black87))),
              ],
            ),
          ),
        ),

        const SizedBox(height: 18),

        // Bagian DONT'S (Dilarang)
        Row(
          children: const [
            Icon(Icons.cancel_rounded, color: Colors.redAccent, size: 20),
            SizedBox(width: 8),
            Text("Hal yang DILARANG (Don'ts)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.redAccent)),
          ],
        ),
        const SizedBox(height: 8),
        ...widget.modul.donts.map(
          (text) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                const Icon(Icons.close, color: Colors.redAccent, size: 18),
                const SizedBox(width: 10),
                Expanded(child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.black87))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
