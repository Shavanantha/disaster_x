import 'package:flutter/material.dart';

class TentangAplikasiScreen extends StatelessWidget {
  const TentangAplikasiScreen({super.key});

  static const Color _navy = Color(0xFF172B4D);
  static const Color _blue = Color(0xFF367BF5);
  static const Color _red = Color(0xFFD94242);
  static const Color _bg = Color(0xFFF4F7FB);
  static const Color _muted = Color(0xFF8290A3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        foregroundColor: _navy,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Tentang DISASTER-X',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
        children: [
          _buildHero(),
          const SizedBox(height: 22),

          _buildSectionTitle(
            'Tentang Aplikasi',
            'Kenali DISASTER-X lebih dekat',
            Icons.info_rounded,
          ),
          const SizedBox(height: 12),
          _buildDescriptionCard(),
          const SizedBox(height: 22),

          _buildSectionTitle(
            'Fitur Unggulan',
            'Belajar kesiapsiagaan secara interaktif',
            Icons.grid_view_rounded,
          ),
          const SizedBox(height: 12),
          _buildFeatureGrid(),
          const SizedBox(height: 22),

          _buildSectionTitle(
            'Informasi Pengembang',
            'Detail proyek akademik',
            Icons.school_rounded,
          ),
          const SizedBox(height: 12),
          _buildDeveloperCard(),
          const SizedBox(height: 22),

          _buildMissionCard(),
          const SizedBox(height: 22),

          Center(
            child: Column(
              children: [
                Container(
                  width: 43,
                  height: 43,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFE5EAF2),
                    ),
                  ),
                  child: const Icon(
                    Icons.shield_rounded,
                    color: _blue,
                    size: 25,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'DISASTER-X',
                  style: TextStyle(
                    color: _navy,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Belajar Siap, Bertindak Tepat.',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Hak Cipta © 2026 DISASTER-X',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Versi 1.0.0',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF142744),
            Color(0xFF254D82),
            Color(0xFF367BF5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: _navy.withValues(alpha: 0.16),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -25,
            top: -30,
            child: Container(
              width: 145,
              height: 145,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.07),
                  width: 24,
                ),
              ),
            ),
          ),
          Positioned(
            right: 14,
            bottom: 4,
            child: Icon(
              Icons.health_and_safety_rounded,
              color: Colors.white.withValues(alpha: 0.08),
              size: 90,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.16),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.emergency_rounded,
                      color: Color(0xFFFFD166),
                      size: 15,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'DISASTER PREPAREDNESS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Logo asli aplikasi
              Container(
                width: 86,
                height: 86,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(23),
                  border: Border.all(
                    color: const Color(0xFFFFD166),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/images/disasterlogo.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 17),

              const Text(
                'DISASTER-X',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 7),

              const Text(
                'Digital Interactive Simulation for Adaptive Emergency Response',
                style: TextStyle(
                  color: Color(0xFFDCE8FF),
                  fontSize: 12,
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 17),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _heroTag(Icons.school_rounded, 'Media Pembelajaran'),
                  _heroTag(Icons.emergency_rounded, 'Mitigasi Bencana'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroTag(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFFFFD166)),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFE8EFFF),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: _blue, size: 22),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _navy,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 5,
            decoration: BoxDecoration(
              color: _red,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Belajar untuk Lebih Siap Menghadapi Bencana',
            style: TextStyle(
              color: _navy,
              fontSize: 16,
              height: 1.4,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'DISASTER-X merupakan media pembelajaran interaktif '
            'yang dirancang untuk membantu siswa memahami '
            'kesiapsiagaan menghadapi bencana alam dan kebakaran. '
            'Melalui materi, simulasi pengambilan keputusan, kuis, '
            'serta checklist tas siaga, pengguna dapat mempelajari '
            'langkah-langkah menghadapi keadaan darurat dengan '
            'cara yang lebih menarik dan aplikatif.',
            style: TextStyle(
              color: Color(0xFF5E6D82),
              fontSize: 12,
              height: 1.8,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4E8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFFFE2BD),
              ),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_rounded,
                  color: Color(0xFFD18A28),
                  size: 21,
                ),
                SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Kenali risikonya, pahami langkahnya, dan '
                    'persiapkan diri sebelum keadaan darurat terjadi.',
                    style: TextStyle(
                      color: Color(0xFF89652F),
                      fontSize: 11,
                      height: 1.6,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid() {
    final features = [
      _FeatureData(
        Icons.menu_book_rounded,
        'Materi Edukasi',
        'Pelajari langkah kesiapsiagaan.',
        const Color(0xFF367BF5),
      ),
      _FeatureData(
        Icons.play_circle_fill_rounded,
        'Simulasi Interaktif',
        'Latihan memilih tindakan aman.',
        const Color(0xFFD94242),
      ),
      _FeatureData(
        Icons.quiz_rounded,
        'Kuis Evaluasi',
        'Uji pemahaman setelah belajar.',
        const Color(0xFF8A63D2),
      ),
      _FeatureData(
        Icons.backpack_rounded,
        'Tas Siaga',
        'Periksa perlengkapan darurat.',
        const Color(0xFF168566),
      ),
    ];

    return GridView.builder(
      itemCount: features.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 11,
        mainAxisSpacing: 11,
        childAspectRatio: 1.05,
      ),
      itemBuilder: (context, index) {
        final feature = features[index];

        return Container(
          padding: const EdgeInsets.all(15),
          decoration: _cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: feature.color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  feature.icon,
                  color: feature.color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                feature.title,
                style: const TextStyle(
                  color: _navy,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                feature.description,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 10,
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDeveloperCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 53,
                height: 53,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_navy, _blue],
                  ),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 13),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tim Pengembang',
                      style: TextStyle(
                        color: _navy,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'DISASTER-X · Proyek Akademik',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(color: Color(0xFFEDF0F5), height: 1),
          _infoRow(
            Icons.school_rounded,
            'Mata Kuliah',
            'Mobile Programming',
          ),
          _infoRow(
            Icons.code_rounded,
            'Teknologi Pengembangan',
            'Flutter dan Dart',
          ),
          _infoRow(
            Icons.architecture_rounded,
            'Arsitektur Aplikasi',
            'Component-Driven Architecture & SharedPreferences',
          ),
          _infoRow(
            Icons.storage_rounded,
            'Tujuan Pengembangan',
            'Mengembangkan media pembelajaran interaktif untuk meningkatkan pengetahuan dan kesiapsiagaan peserta didik dalam menghadapi bencana.',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
    IconData icon,
    String label,
    String value, {
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        top: 10,
        bottom: isLast ? 5 : 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: _blue),
          const SizedBox(width: 10),
          SizedBox(
            width: 94,
            child: Text(
              label,
              style: const TextStyle(
                color: _muted,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 5),
          const Text(
            ':',
            style: TextStyle(color: _muted, fontSize: 11),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: _navy,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF0FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD8E4FF),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.favorite_rounded,
            color: _red,
            size: 25,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Misi DISASTER-X',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  'Mendorong pembelajaran kesiapsiagaan bencana '
                  'melalui pengalaman digital yang interaktif, '
                  'agar pengguna lebih memahami risiko dan '
                  'mengenali tindakan yang lebih aman saat darurat.',
                  style: TextStyle(
                    color: Color(0xFF5E6D82),
                    fontSize: 11,
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(19),
      border: Border.all(
        color: const Color(0xFFE7ECF3),
      ),
      boxShadow: [
        BoxShadow(
          color: _navy.withValues(alpha: 0.025),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}

class _FeatureData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _FeatureData(
    this.icon,
    this.title,
    this.description,
    this.color,
  );
}
