import 'package:flutter/material.dart';
import '../../services/dummy_data.dart';
import '../../services/storage_service.dart';

class TasSiagaScreen extends StatefulWidget {
  const TasSiagaScreen({super.key});

  @override
  State<TasSiagaScreen> createState() => _TasSiagaScreenState();
}

class _TasSiagaScreenState extends State<TasSiagaScreen> {
  List<String> _checkedIds = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChecklist();
  }

  Future<void> _loadChecklist() async {
    final list = await StorageService.getTasSiagaChecked();
    if (mounted) {
      setState(() {
        _checkedIds = list;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleItem(String id) async {
    setState(() {
      if (_checkedIds.contains(id)) {
        _checkedIds.remove(id);
      } else {
        _checkedIds.add(id);
      }
    });
    await StorageService.saveTasSiagaChecked(_checkedIds);
  }

  @override
  Widget build(BuildContext context) {
    final totalItems = DummyData.checklistTasSiaga.length;
    final checkedCount = _checkedIds.length;
    final percent = totalItems > 0 ? (checkedCount / totalItems) : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('Checklist Tas Siaga Bencana', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Banner Kesiapan Tas
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Kesiapan Ransel 72 Jam',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            '${(percent * 100).round()}% Lengkap',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.redAccent),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: percent,
                          minHeight: 8,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.redAccent),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$checkedCount dari $totalItems barang telah tersedia di rumah.',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  'Perlengkapan Wajib (Standar BNPB)',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                ...DummyData.checklistTasSiaga.map((item) {
                  final id = item['id'] as String;
                  final nama = item['nama'] as String;
                  final kategori = item['kategori'] as String;
                  final isChecked = _checkedIds.contains(id);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isChecked ? Colors.green.shade300 : Colors.grey.shade200,
                      ),
                    ),
                    child: CheckboxListTile(
                      activeColor: Colors.green,
                      title: Text(
                        nama,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          decoration: isChecked ? TextDecoration.lineThrough : null,
                          color: isChecked ? Colors.black54 : Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        kategori,
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      value: isChecked,
                      onChanged: (_) => _toggleItem(id),
                    ),
                  );
                }),
              ],
            ),
    );
  }
}
