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

  static const Color _navy = Color(0xFF172B4D);
  static const Color _blue = Color(0xFF367BF5);
  static const Color _background = Color(0xFFF4F7FB);
  static const Color _muted = Color(0xFF8290A3);

  @override
  void initState() {
    super.initState();
    _loadChecklist();
  }

  Future<void> _loadChecklist() async {
    try {
      final list = await StorageService.getTasSiagaChecked();

      if (!mounted) return;

      setState(() {
        _checkedIds = list;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Checklist tas siaga gagal dimuat.'),
        ),
      );
    }
  }

  Future<void> _toggleItem(String id) async {
    final updated = List<String>.from(_checkedIds);

    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }

    setState(() {
      _checkedIds = updated;
    });

    try {
      await StorageService.saveTasSiagaChecked(updated);
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perubahan checklist gagal disimpan.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = DummyData.checklistTasSiaga;
    final totalItems = items.length;

    // Menghitung berdasarkan ID barang yang benar-benar ada di checklist.
    final validIds = items.map((item) => item['id'] as String).toSet();
    final checkedCount =
        _checkedIds.where((id) => validIds.contains(id)).length;

    final percent =
        totalItems > 0 ? checkedCount / totalItems : 0.0;

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _background,
        foregroundColor: _navy,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Tas Siaga Bencana',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: _navy,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: _blue),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
              children: [
                _buildHeroCard(
                  totalItems: totalItems,
                  checkedCount: checkedCount,
                  percent: percent,
                ),
                const SizedBox(height: 23),

                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Perlengkapan Darurat',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: _navy,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFE4EAF2),
                        ),
                      ),
                      child: Text(
                        '$checkedCount/$totalItems',
                        style: const TextStyle(
                          fontSize: 11,
                          color: _blue,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Centang barang yang sudah kamu siapkan di rumah.',
                  style: TextStyle(
                    fontSize: 12,
                    color: _muted,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 15),

                if (items.isEmpty)
                  _buildEmptyState()
                else
                  ...items.map((item) {
                    final id = item['id'] as String;
                    final nama = item['nama'] as String;
                    final kategori = item['kategori'] as String;
                    final isChecked = _checkedIds.contains(id);

                    return _buildChecklistItem(
                      id: id,
                      nama: nama,
                      kategori: kategori,
                      isChecked: isChecked,
                    );
                  }),

                const SizedBox(height: 12),
                _buildSafetyTip(),
              ],
            ),
    );
  }

  Widget _buildHeroCard({
    required int totalItems,
    required int checkedCount,
    required double percent,
  }) {
    final isComplete = totalItems > 0 && checkedCount == totalItems;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF172B4D),
            Color(0xFF254D82),
            Color(0xFF367BF5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: _navy.withValues(alpha: 0.17),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -26,
            right: -20,
            child: Container(
              width: 135,
              height: 135,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 22,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 51,
                    height: 51,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.13),
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.14),
                      ),
                    ),
                    child: const Icon(
                      Icons.backpack_rounded,
                      color: Color(0xFFFFD166),
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 13),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EMERGENCY KIT',
                          style: TextStyle(
                            color: Color(0xFFBBD5FF),
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Tas Siaga 72 Jam',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.shield_rounded,
                    color: Color(0xFFFFD166),
                    size: 27,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TINGKAT KESIAPAN',
                          style: TextStyle(
                            color: Color(0xFFD7E5FF),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${(percent * 100).round()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 39,
                            fontWeight: FontWeight.w900,
                            height: 1.15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          isComplete
                              ? Icons.verified_rounded
                              : Icons.inventory_2_rounded,
                          color: const Color(0xFFFFD166),
                          size: 23,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$checkedCount dari $totalItems',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Text(
                          'barang siap',
                          style: TextStyle(
                            color: Color(0xFFD7E5FF),
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: percent.clamp(0.0, 1.0),
                  minHeight: 8,
                  backgroundColor: Colors.white.withValues(alpha: 0.18),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isComplete
                        ? const Color(0xFF76E0B0)
                        : const Color(0xFFFFD166),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Text(
                totalItems == 0
                    ? 'Belum ada perlengkapan dalam daftar.'
                    : isComplete
                        ? 'Semua barang dalam checklist sudah ditandai!'
                        : 'Lengkapi perlengkapanmu secara bertahap.',
                style: const TextStyle(
                  color: Color(0xFFE5EEFF),
                  fontSize: 11,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem({
    required String id,
    required String nama,
    required String kategori,
    required bool isChecked,
  }) {
    final categoryColor = _categoryColor(kategori);
    final categoryIcon = _categoryIcon(kategori);

    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        color: isChecked ? const Color(0xFFF3FBF7) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isChecked
              ? const Color(0xFFB8E6D0)
              : const Color(0xFFE7ECF3),
        ),
        boxShadow: [
          BoxShadow(
            color: _navy.withValues(alpha: 0.025),
            blurRadius: 9,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _toggleItem(id),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 14,
            ),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: isChecked
                        ? const Color(0xFFDCF5E8)
                        : categoryColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    isChecked ? Icons.check_rounded : categoryIcon,
                    color: isChecked
                        ? const Color(0xFF168566)
                        : categoryColor,
                    size: 23,
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nama,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          height: 1.4,
                          color: isChecked
                              ? const Color(0xFF77868A)
                              : _navy,
                          decoration: isChecked
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: categoryColor.withValues(alpha: 0.09),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          kategori,
                          style: TextStyle(
                            color: categoryColor,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                Checkbox(
                  value: isChecked,
                  onChanged: (_) => _toggleItem(id),
                  activeColor: const Color(0xFF168566),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _categoryColor(String kategori) {
    final value = kategori.toLowerCase();

    if (value.contains('dokumen')) {
      return const Color(0xFF7A58C1);
    }
    if (value.contains('makanan') || value.contains('minuman')) {
      return const Color(0xFFE28A28);
    }
    if (value.contains('obat') || value.contains('kesehatan')) {
      return const Color(0xFFD94242);
    }
    if (value.contains('komunikasi') || value.contains('elektronik')) {
      return const Color(0xFF367BF5);
    }
    if (value.contains('pakaian')) {
      return const Color(0xFF168D9D);
    }

    return const Color(0xFF168566);
  }

  IconData _categoryIcon(String kategori) {
    final value = kategori.toLowerCase();

    if (value.contains('dokumen')) {
      return Icons.folder_special_rounded;
    }
    if (value.contains('makanan') || value.contains('minuman')) {
      return Icons.restaurant_rounded;
    }
    if (value.contains('obat') || value.contains('kesehatan')) {
      return Icons.medical_services_rounded;
    }
    if (value.contains('komunikasi') || value.contains('elektronik')) {
      return Icons.battery_charging_full_rounded;
    }
    if (value.contains('pakaian')) {
      return Icons.checkroom_rounded;
    }
    if (value.contains('penerangan')) {
      return Icons.flashlight_on_rounded;
    }

    return Icons.inventory_2_rounded;
  }

  Widget _buildSafetyTip() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5E6),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFF5DDB1)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_rounded,
            color: Color(0xFFCB8A25),
            size: 23,
          ),
          SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips Kesiapsiagaan',
                  style: TextStyle(
                    color: Color(0xFF8B5D18),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Simpan tas di tempat yang mudah dijangkau. '
                  'Periksa tanggal kedaluwarsa makanan, air, '
                  'dan obat secara berkala.',
                  style: TextStyle(
                    color: Color(0xFF896C43),
                    fontSize: 11,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7ECF3)),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.backpack_outlined,
            color: _blue,
            size: 44,
          ),
          SizedBox(height: 12),
          Text(
            'Belum Ada Daftar Barang',
            style: TextStyle(
              color: _navy,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Daftar perlengkapan tas siaga belum tersedia.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _muted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
