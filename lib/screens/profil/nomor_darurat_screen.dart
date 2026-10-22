
import 'package:flutter/material.dart';

import '../../services/dummy_data.dart';
import '../../widgets/icon_helper.dart';

class NomorDaruratScreen extends StatelessWidget {
  const NomorDaruratScreen({super.key});

  static const Color _navy = Color(0xFF17345C);
  static const Color _blue = Color(0xFF2878C8);
  static const Color _background = Color(0xFFF4F7FB);
  static const Color _textDark = Color(0xFF1D2D42);
  static const Color _textMuted = Color(0xFF7B899B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _background,
        foregroundColor: _textDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 4,
        title: const Text(
          'Nomor Darurat',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: _textDark,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          _buildHero(),
          const SizedBox(height: 25),
          _buildSectionTitle(),
          const SizedBox(height: 13),
          ...DummyData.nomorDarurat.map((item) {
            final color = Color(int.parse(item['warna']!));
            final nomor = item['nomor']!;
            final instansi = item['instansi']!;
            final deskripsi = item['deskripsi']!;
            final iconName = item['ikon']!;

            return _buildContactCard(
              context: context,
              color: color,
              nomor: nomor,
              instansi: instansi,
              deskripsi: deskripsi,
              iconName: iconName,
            );
          }),
          const SizedBox(height: 10),
          _buildSafetyNote(),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_navy, Color(0xFF24558B), _blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
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
            right: -22,
            top: -35,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.phone_in_talk_rounded,
                  size: 29,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Butuh Bantuan Darurat?',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 9),
              const Text(
                'Kenali kontak bantuan yang dapat kamu hubungi '
                'saat menghadapi situasi darurat.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.6,
                  color: Color(0xFFD9E9FB),
                ),
              ),
              const SizedBox(height: 17),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 18,
                      color: Color(0xFFFFD58B),
                    ),
                    SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        'Gunakan kontak sesuai kebutuhan dan '
                        'pastikan informasi nomor tetap terbaru.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kontak Bantuan',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: _textDark,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'Daftar nomor yang tersedia di aplikasi',
          style: TextStyle(
            fontSize: 11,
            color: _textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildContactCard({
    required BuildContext context,
    required Color color,
    required String nomor,
    required String instansi,
    required String deskripsi,
    required String iconName,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE8EDF4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 49,
                  height: 49,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    getDisasterIcon(iconName),
                    color: color,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        instansi,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          fontWeight: FontWeight.w800,
                          color: _textDark,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        deskripsi,
                        style: const TextStyle(
                          fontSize: 11,
                          height: 1.5,
                          color: _textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.call_rounded,
                    size: 17,
                    color: color,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      nomor,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 38,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text(
                                'Fitur panggilan langsung belum tersedia. '
                                'Nomor: $nomor ($instansi).',
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: _navy,
                            ),
                          );
                      },
                      icon: const Icon(
                        Icons.phone_in_talk_rounded,
                        size: 15,
                      ),
                      label: const Text(
                        'Hubungi',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyNote() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5E5),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFF5E2B8),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.health_and_safety_rounded,
            color: Color(0xFFB7791F),
            size: 23,
          ),
          SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tetap tenang dan utamakan keselamatan',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF855B17),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Cari tempat aman terlebih dahulu. Ikuti arahan '
                  'petugas dan gunakan layanan darurat hanya '
                  'untuk kebutuhan yang sesuai.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.5,
                    color: Color(0xFF856D49),
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