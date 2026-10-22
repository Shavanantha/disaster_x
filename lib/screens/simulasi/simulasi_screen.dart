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

  static const Color _navy = Color(0xFF172B4D);
  static const Color _blue = Color(0xFF3478F6);
  static const Color _background = Color(0xFFF4F7FC);
  static const Color _textDark = Color(0xFF243247);
  static const Color _textMuted = Color(0xFF7B8798);

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    final scores = await StorageService.getSimulationScores();

    if (!mounted) return;

    setState(() {
      _scores = scores;
    });
  }

  Future<void> _openSimulation(dynamic skenario) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            InteractiveSimulationScreen(skenario: skenario),
      ),
    );

    if (mounted) {
      _loadScores();
    }
  }

  @override
  Widget build(BuildContext context) {
    final daftarSkenario = DummyData.daftarSkenario;
    final skenarioUtama =
        daftarSkenario.isNotEmpty ? daftarSkenario.first : null;

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _background,
        foregroundColor: _navy,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Simulasi Bencana',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: _navy,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
        children: [
          _buildIntro(),

          const SizedBox(height: 24),

          if (skenarioUtama != null) ...[
            _buildFeaturedSimulation(skenarioUtama),
            const SizedBox(height: 28),
          ],

          _buildSectionHeader(
            title: 'Jelajahi Skenario',
            subtitle: 'Pilih situasi dan latih respons terbaikmu.',
            trailing: '${daftarSkenario.length} skenario',
          ),

          const SizedBox(height: 14),

          if (daftarSkenario.isEmpty)
            _buildEmptyState()
          else
            ...daftarSkenario.map((skenario) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildScenarioCard(
                  skenario,
                  isFeatured: skenario.id == skenarioUtama?.id,
                ),
              );
            }),

          const SizedBox(height: 12),

          _buildSafetyNote(),
        ],
      ),
    );
  }

  Widget _buildIntro() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8EDF5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Siap Menghadapi\nSituasi Darurat?',
                  style: TextStyle(
                    fontSize: 21,
                    height: 1.25,
                    fontWeight: FontWeight.w800,
                    color: _navy,
                  ),
                ),
                const SizedBox(height: 9),
                const Text(
                  'Belajar mengambil keputusan yang tepat melalui simulasi interaktif.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.6,
                    color: _textMuted,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.touch_app_rounded,
                      size: 16,
                      color: _blue,
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        'Belajar sambil berlatih',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 88,
            height: 104,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 12,
                  right: 12,
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    size: 17,
                    color: Color(0xFF78A4FF),
                  ),
                ),
                Icon(
                  Icons.health_and_safety_rounded,
                  size: 55,
                  color: _blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedSimulation(dynamic skenario) {
    final bestScore = _scores[skenario.id] ?? 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF203D68),
            Color(0xFF315C91),
            Color(0xFF3478A8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _navy.withValues(alpha: 0.13),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.play_circle_fill_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'SIMULASI UNGGULAN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.stars_rounded,
                color: Color(0xFFFFD166),
                size: 21,
              ),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            skenario.judul,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              height: 1.3,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 9),

          Text(
            skenario.deskripsi,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.86),
              fontSize: 12,
              height: 1.65,
            ),
          ),

          const SizedBox(height: 18),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFeaturedChip(
                Icons.schedule_rounded,
                skenario.durasi,
              ),
              _buildFeaturedChip(
                Icons.emoji_events_rounded,
                'Skor terbaik: $bestScore',
              ),
            ],
          ),

          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _openSimulation(skenario),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: _navy,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow_rounded, size: 23),
                  SizedBox(width: 8),
                  Text(
                    'Mulai Simulasi',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
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

  Widget _buildFeaturedChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: const Color(0xFFFFD166),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    String? trailing,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: _navy,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: _textMuted,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE8EEFA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              trailing,
              style: const TextStyle(
                color: _navy,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildScenarioCard(
    dynamic skenario, {
    required bool isFeatured,
  }) {
    final color = Color(skenario.warnaHex);
    final bestScore = _scores[skenario.id];
    final icon = getDisasterIcon(skenario.iconCode);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(19),
      child: InkWell(
        onTap: () => _openSimulation(skenario),
        borderRadius: BorderRadius.circular(19),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            border: Border.all(
              color: isFeatured
                  ? _blue.withValues(alpha: 0.35)
                  : const Color(0xFFE8EDF5),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 29,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      skenario.judul,
                      style: const TextStyle(
                        color: _textDark,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      skenario.kategori,
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 9),

                    Wrap(
                      spacing: 10,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.schedule_rounded,
                              size: 14,
                              color: _textMuted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              skenario.durasi,
                              style: const TextStyle(
                                fontSize: 11,
                                color: _textMuted,
                              ),
                            ),
                          ],
                        ),
                        if (bestScore != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.emoji_events_rounded,
                                size: 14,
                                color: Color(0xFFE6A323),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Skor $bestScore',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: _textDark,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 34,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8EDF5)),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.video_library_outlined,
            size: 45,
            color: _textMuted,
          ),
          SizedBox(height: 12),
          Text(
            'Belum Ada Skenario',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: _navy,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Skenario simulasi akan ditampilkan di sini.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyNote() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF1FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: _blue,
            size: 22,
          ),
          SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips Belajar',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Perhatikan situasi dalam setiap skenario dan pilih tindakan berdasarkan prinsip keselamatan. Simulasi ini merupakan media latihan, bukan pengganti arahan petugas saat keadaan darurat.',
                  style: TextStyle(
                    color: Color(0xFF536783),
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
}