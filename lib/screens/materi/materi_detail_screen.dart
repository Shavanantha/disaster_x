
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

class _MateriDetailScreenState extends State<MateriDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late bool _completed;

  static const Color _navy = Color(0xFF172554);
  static const Color _background = Color(0xFFF5F7FC);

  Color get _themeColor => Color(widget.modul.warnaHex);

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
    if (_completed) return;

    await StorageService.markModuleCompleted(widget.modul.id);

    if (!mounted) return;

    setState(() {
      _completed = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF15803D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Modul berhasil diselesaikan!',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: _navy,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Detail Materi',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Column(
        children: [
          // HERO MATERI
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(18, 12, 18, 0),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _themeColor,
                  Color.lerp(_themeColor, _navy, 0.35)!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: _themeColor.withValues(alpha: 0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 61,
                      height: 61,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(19),
                      ),
                      child: Icon(
                        getDisasterIcon(widget.modul.ikon),
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.17),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.modul.kategori.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 9),
                          Text(
                            widget.modul.judul,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 17),
                Text(
                  widget.modul.ringkasan,
                  style: const TextStyle(
                    color: Color(0xFFF0F5FF),
                    fontSize: 12,
                    height: 1.65,
                  ),
                ),
                const SizedBox(height: 17),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _completed
                            ? Icons.check_circle_rounded
                            : Icons.menu_book_rounded,
                        color: Colors.white,
                        size: 19,
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          _completed
                              ? 'Materi telah diselesaikan'
                              : 'Pelajari setiap langkah untuk bersiap',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // TARGET KOMPETENSI
          Container(
            margin: const EdgeInsets.fromLTRB(18, 14, 18, 14),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(19),
              border: Border.all(color: const Color(0xFFE6EAF2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: _themeColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    Icons.school_rounded,
                    color: _themeColor,
                    size: 23,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Target Kompetensi',
                        style: TextStyle(
                          color: _navy,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.modul.capaian,
                        style: const TextStyle(
                          color: Color(0xFF69768C),
                          fontSize: 12,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // NAVIGASI TAB
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 18),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: const Color(0xFFE6EAF2)),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: _themeColor,
                borderRadius: BorderRadius.circular(12),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xFF778399),
              labelStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(
                  icon: Icon(Icons.shield_outlined, size: 17),
                  text: 'Prabencana',
                ),
                Tab(
                  icon: Icon(Icons.warning_amber_rounded, size: 17),
                  text: 'Saat Bencana',
                ),
                Tab(
                  icon: Icon(Icons.health_and_safety_outlined, size: 17),
                  text: 'Pascabencana',
                ),
                Tab(
                  icon: Icon(Icons.fact_check_outlined, size: 17),
                  text: "Do's & Don'ts",
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ISI MATERI
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildListTab(
                  'Persiapan Sebelum Bencana',
                  'Kenali risiko dan siapkan diri sejak dini.',
                  widget.modul.prabencana,
                  Icons.shield_rounded,
                  _themeColor,
                ),
                _buildListTab(
                  'Tindakan Saat Keadaan Darurat',
                  'Utamakan keselamatan dan ikuti prosedur.',
                  widget.modul.saatBencana,
                  Icons.emergency_rounded,
                  const Color(0xFFDC4545),
                ),
                _buildListTab(
                  'Langkah Setelah Bencana',
                  'Pulihkan kondisi dengan tetap waspada.',
                  widget.modul.pascabencana,
                  Icons.health_and_safety_rounded,
                  const Color(0xFF0D9488),
                ),
                _buildDosDontsTab(),
              ],
            ),
          ),

          // TOMBOL SELESAIKAN
          Container(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: _navy.withValues(alpha: 0.06),
                  blurRadius: 15,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _completed ? null : _selesaikanModul,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _completed
                        ? const Color(0xFF15803D)
                        : _themeColor,
                    disabledBackgroundColor: const Color(0xFFDCFCE7),
                    foregroundColor: Colors.white,
                    disabledForegroundColor: const Color(0xFF15803D),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: Icon(
                    _completed
                        ? Icons.check_circle_rounded
                        : Icons.task_alt_rounded,
                    size: 21,
                  ),
                  label: Text(
                    _completed
                        ? 'Modul Selesai'
                        : 'Tandai Modul Selesai',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTab(
    String title,
    String subtitle,
    List<String> items,
    IconData icon,
    Color color,
  ) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.menu_book_rounded,
                color: color.withValues(alpha: 0.6),
                size: 44,
              ),
              const SizedBox(height: 12),
              const Text(
                'Belum ada materi pada bagian ini.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _navy,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 22),
      children: [
        Row(
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.11),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF778399),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        ...items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFE7EBF3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 35,
                  height: 35,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.11),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${index + 1}'.padLeft(2, '0'),
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: Color(0xFF344054),
                        fontSize: 13,
                        height: 1.65,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDosDontsTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 22),
      children: [
        _buildRuleSection(
          title: 'Lakukan',
          subtitle: 'Tindakan yang dianjurkan',
          items: widget.modul.dos,
          color: const Color(0xFF15803D),
          background: const Color(0xFFF0FDF4),
          icon: Icons.check_circle_rounded,
          itemIcon: Icons.check_rounded,
        ),
        const SizedBox(height: 18),
        _buildRuleSection(
          title: 'Hindari',
          subtitle: 'Tindakan yang perlu dihindari',
          items: widget.modul.donts,
          color: const Color(0xFFDC4545),
          background: const Color(0xFFFFF1F2),
          icon: Icons.cancel_rounded,
          itemIcon: Icons.close_rounded,
        ),
      ],
    );
  }

  Widget _buildRuleSection({
    required String title,
    required String subtitle,
    required List<String> items,
    required Color color,
    required Color background,
    required IconData icon,
    required IconData itemIcon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: color.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: color,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF778399),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          if (items.isEmpty)
            const Text(
              'Belum ada poin pada bagian ini.',
              style: TextStyle(
                color: Color(0xFF778399),
                fontSize: 12,
              ),
            )
          else
            ...items.map(
              (item) => Container(
                margin: const EdgeInsets.only(bottom: 9),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Icon(
                        itemIcon,
                        color: color,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                          color: Color(0xFF344054),
                          fontSize: 12,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}