
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

  static const Color _navy = Color(0xFF172554);
  static const Color _blue = Color(0xFF2563EB);
  static const Color _background = Color(0xFFF5F7FC);

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final list = await StorageService.getCompletedModules();

    if (!mounted) return;

    setState(() {
      _completedIds = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    final allModules = DummyData.daftarModul;

    final filteredModules = allModules.where((modul) {
      final query = _searchQuery.trim().toLowerCase();

      return modul.judul.toLowerCase().contains(query) ||
          modul.kategori.toLowerCase().contains(query) ||
          modul.ringkasan.toLowerCase().contains(query);
    }).toList();

    final completedCount = allModules
        .where((modul) => _completedIds.contains(modul.id))
        .length;

    final totalModules = allModules.length;

    final progress = totalModules == 0
        ? 0.0
        : completedCount / totalModules;

    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadProgress,
          color: _blue,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // HEADER
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'BELAJAR & BERSIAP',
                              style: TextStyle(
                                color: _blue,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.6,
                              ),
                            ),
                            const SizedBox(height: 7),
                            const Text(
                              'Materi Bencana',
                              style: TextStyle(
                                color: _navy,
                                fontSize: 27,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.7,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Kenali risikonya, pelajari cara menghadapinya.',
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.5,
                                color: Colors.blueGrey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0EAFF),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.menu_book_rounded,
                          color: _blue,
                          size: 29,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // LEARNING PROGRESS CARD
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF172554),
                          Color(0xFF284A91),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: _navy.withValues(alpha: 0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 9),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 43,
                              height: 43,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.13),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.auto_stories_rounded,
                                color: Colors.white,
                                size: 23,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Progres Belajarmu',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    'Sedikit demi sedikit, jadi lebih siap!',
                                    style: TextStyle(
                                      color: Color(0xFFD5E2FF),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 23),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$completedCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                                height: 1,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 5,
                                bottom: 3,
                              ),
                              child: Text(
                                '/ $totalModules modul selesai',
                                style: const TextStyle(
                                  color: Color(0xFFD5E2FF),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${(progress * 100).round()}%',
                              style: const TextStyle(
                                color: Color(0xFF93C5FD),
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 9,
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.17),
                            valueColor:
                                const AlwaysStoppedAnimation<Color>(
                              Color(0xFF60D9C3),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          completedCount == totalModules &&
                                  totalModules > 0
                              ? 'Hebat! Semua modul sudah kamu selesaikan.'
                              : 'Lanjutkan belajar untuk meningkatkan kesiapsiagaanmu.',
                          style: const TextStyle(
                            color: Color(0xFFE2E8F0),
                            fontSize: 11,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // LEARNING OBJECTIVE
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFFED7AA),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEDD5),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: const Icon(
                            Icons.school_rounded,
                            color: Color(0xFFEA580C),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Capaian Pembelajaran',
                                style: TextStyle(
                                  color: Color(0xFF9A3412),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Memahami langkah mitigasi prabencana, '
                                'saat darurat, dan pascabencana secara '
                                'mandiri dan adaptif.',
                                style: TextStyle(
                                  color: Color(0xFF7C4930),
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
                ),
              ),

              // SEARCH FIELD
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Cari materi bencana...',
                      hintStyle: TextStyle(
                        color: Colors.blueGrey.shade300,
                        fontSize: 13,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: _blue,
                        size: 23,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                              icon: const Icon(Icons.close_rounded),
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 15,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(17),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(17),
                        borderSide: BorderSide(
                          color: const Color(0xFFE5EAF3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(17),
                        borderSide: const BorderSide(
                          color: _blue,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // MODULE LIST HEADER
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 14),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jelajahi Materi',
                              style: TextStyle(
                                color: _navy,
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Pilih topik yang ingin kamu pelajari.',
                              style: TextStyle(
                                color: Color(0xFF778399),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0EAFF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${filteredModules.length} Materi',
                          style: const TextStyle(
                            color: _blue,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // MODULE CARDS
              if (filteredModules.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: Colors.blueGrey.shade200,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Materi tidak ditemukan',
                            style: TextStyle(
                              color: _navy,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Coba gunakan kata kunci yang berbeda.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF778399),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final modul = filteredModules[index];
                        final isDone =
                            _completedIds.contains(modul.id);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: _buildModulCard(
                            modul: modul,
                            color: Color(modul.warnaHex),
                            isDone: isDone,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MateriDetailScreen(
                                    modul: modul,
                                    isCompleted: isDone,
                                  ),
                                ),
                              );

                              if (mounted) {
                                await _loadProgress();
                              }
                            },
                          ),
                        );
                      },
                      childCount: filteredModules.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModulCard({
    required BencanaModul modul,
    required Color color,
    required bool isDone,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(23),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(23),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(23),
            border: Border.all(
              color: const Color(0xFFE8ECF4),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF172554).withValues(alpha: 0.035),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // COLORED CARD HEADER
              Container(
                height: 116,
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(22),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 67,
                      height: 67,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(21),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.10),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        getDisasterIcon(modul.ikon),
                        color: color,
                        size: 35,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              modul.kategori.toUpperCase(),
                              style: TextStyle(
                                color: color,
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            modul.judul,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _navy,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      isDone
                          ? Icons.check_circle_rounded
                          : Icons.arrow_forward_ios_rounded,
                      color: isDone ? const Color(0xFF16A34A) : color,
                      size: isDone ? 23 : 16,
                    ),
                  ],
                ),
              ),

              // CARD DESCRIPTION AND ACTION
              Padding(
                padding: const EdgeInsets.fromLTRB(17, 15, 17, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      modul.ringkasan,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF68758B),
                        fontSize: 12,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Icon(
                          isDone
                              ? Icons.check_circle_rounded
                              : Icons.menu_book_rounded,
                          color: isDone
                              ? const Color(0xFF16A34A)
                              : const Color(0xFF7C8BA5),
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            isDone ? 'Materi telah selesai' : 'Modul pembelajaran',
                            style: TextStyle(
                              color: isDone
                                  ? const Color(0xFF15803D)
                                  : const Color(0xFF7C8BA5),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: isDone
                                ? const Color(0xFFDCFCE7)
                                : color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                isDone ? 'Pelajari Lagi' : 'Pelajari',
                                style: TextStyle(
                                  color: isDone
                                      ? const Color(0xFF15803D)
                                      : Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Icon(
                                isDone
                                    ? Icons.replay_rounded
                                    : Icons.arrow_forward_rounded,
                                color: isDone
                                    ? const Color(0xFF15803D)
                                    : Colors.white,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}