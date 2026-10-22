
import 'package:flutter/material.dart';

import '../../models/user_profile_model.dart';
import '../../services/storage_service.dart';
import '../auth/login_screen.dart';
import 'edit_profil_dialog.dart';
import 'riwayat_nilai_screen.dart';
import 'sertifikat_screen.dart';
import 'nomor_darurat_screen.dart';
import 'tas_siaga_screen.dart';
import 'tentang_aplikasi_screen.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  static const Color _navy = Color(0xFF17345C);
  static const Color _blue = Color(0xFF2878C8);
  static const Color _red = Color(0xFFE84B55);
  static const Color _background = Color(0xFFF4F7FB);
  static const Color _textDark = Color(0xFF1D2D42);
  static const Color _textMuted = Color(0xFF7B899B);

  UserProfile _profile = const UserProfile(
    nama: 'Shava Phiyan Anantha',
    nim: '2413025047',
    sekolah: 'Universitas Lampung',
    kelas: 'Mobile Programming A',
  );

  int _modulCount = 0;
  int _simulasiCount = 0;
  double _rataRata = 85.0;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prof = await StorageService.getUserProfile();
    final mods = await StorageService.getCompletedModules();
    final sims = await StorageService.getSimulationScores();
    final avg = await StorageService.getRataRataNilai();

    if (!mounted) return;

    setState(() {
      _profile = prof;
      _modulCount = mods.length;
      _simulasiCount = sims.length;
      _rataRata = avg;
    });
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => EditProfilDialog(
        currentProfile: _profile,
        onSaved: _loadProfileData,
      ),
    );
  }

  Future<void> _handleLogout() async {
    await StorageService.setLoggedIn(false);

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  void _confirmResetData() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: _red,
          size: 42,
        ),
        title: const Text(
          'Reset Data Aplikasi?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _textDark,
          ),
        ),
        content: const Text(
          'Tindakan ini akan mengosongkan kembali skor kuis, '
          'riwayat simulasi, dan checklist untuk pengujian baru.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            height: 1.6,
            color: _textMuted,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Batal',
              style: TextStyle(color: _textMuted),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _red,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              Navigator.pop(ctx);

              await StorageService.resetAllData();
              await _loadProfileData();

              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data berhasil di-reset ke kondisi awal.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Ya, Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: RefreshIndicator(
          color: _blue,
          onRefresh: _loadProfileData,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              _buildTopBar(),
              const SizedBox(height: 22),
              _buildProfileCard(),
              const SizedBox(height: 20),
              _buildStatistics(),
              const SizedBox(height: 28),
              _buildSectionHeading(
                'Akun & Pembelajaran',
                'Kelola profil dan pantau perkembanganmu',
              ),
              const SizedBox(height: 14),
              _buildMenuCard([
                _MenuData(
                  icon: Icons.badge_outlined,
                  title: 'Data Identitas Siswa',
                  subtitle: 'Nama, NIM/NISN, sekolah, dan kelas',
                  color: _blue,
                  onTap: _showEditDialog,
                ),
                _MenuData(
                  icon: Icons.history_rounded,
                  title: 'Riwayat Percobaan & Nilai',
                  subtitle: 'Lihat hasil kuis dan simulasi',
                  color: const Color(0xFF8B5CF6),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RiwayatNilaiScreen(),
                      ),
                    );
                    _loadProfileData();
                  },
                ),
                _MenuData(
                  icon: Icons.workspace_premium_rounded,
                  title: 'Sertifikat Tanggap Bencana',
                  subtitle: 'Lihat sertifikat kelulusan digital',
                  color: const Color(0xFFE5A52D),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SertifikatScreen(),
                      ),
                    );
                  },
                ),
              ]),
              const SizedBox(height: 26),
              _buildSectionHeading(
                'Kesiapsiagaan',
                'Persiapkan dirimu menghadapi keadaan darurat',
              ),
              const SizedBox(height: 14),
              _buildMenuCard([
                _MenuData(
                  icon: Icons.backpack_rounded,
                  title: 'Checklist Tas Siaga',
                  subtitle: 'Persiapan kebutuhan darurat 72 jam',
                  color: const Color(0xFF20A486),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TasSiagaScreen(),
                      ),
                    );
                  },
                ),
                _MenuData(
                  icon: Icons.contact_phone_rounded,
                  title: 'Kontak Darurat Nasional',
                  subtitle: 'Akses informasi nomor bantuan darurat',
                  color: _red,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NomorDaruratScreen(),
                      ),
                    );
                  },
                ),
                _MenuData(
                  icon: Icons.info_outline_rounded,
                  title: 'Tentang DISASTER-X',
                  subtitle: 'Informasi aplikasi dan pengembang',
                  color: _navy,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TentangAplikasiScreen(),
                      ),
                    );
                  },
                ),
              ]),
              const SizedBox(height: 26),
              _buildSectionHeading(
                'Pengaturan',
                'Kelola data aplikasi dan akunmu',
              ),
              const SizedBox(height: 14),
              _buildMenuCard([
                _MenuData(
                  icon: Icons.restart_alt_rounded,
                  title: 'Reset Data Pengerjaan',
                  subtitle: 'Kembalikan progres ke kondisi awal',
                  color: const Color(0xFFE58B35),
                  onTap: _confirmResetData,
                ),
              ]),
              const SizedBox(height: 22),
              _buildLogoutButton(),
              const SizedBox(height: 20),
              const Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.health_and_safety_rounded,
                      color: Color(0xFFB4C2D3),
                      size: 24,
                    ),
                    SizedBox(height: 6),
                    Text(
                      'DISASTER-X',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                        color: _textMuted,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Belajar Siaga, Bertindak Tepat',
                      style: TextStyle(
                        fontSize: 11,
                        color: _textMuted,
                      ),
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

  Widget _buildTopBar() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AKUN SAYA',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.8,
                  color: _blue,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Profil & Pengaturan',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  color: _textDark,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Kelola informasi dan progres belajarmu.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blueGrey.shade500,
                ),
              ),
            ],
          ),
        ),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: _showEditDialog,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFE6ECF3)),
              ),
              child: const Icon(
                Icons.edit_rounded,
                color: _blue,
                size: 21,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
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
            color: _navy.withValues(alpha: 0.18),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -28,
            top: -35,
            child: Container(
              width: 125,
              height: 125,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            right: 24,
            bottom: -48,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.35),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.13),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.shield_rounded,
                          color: Color(0xFF9FE6CF),
                          size: 15,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Peserta',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                _profile.nama.trim().isEmpty
                    ? 'Nama Peserta'
                    : _profile.nama,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 21,
                  height: 1.25,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                _profile.nim.trim().isEmpty
                    ? 'NIM / NISN belum diisi'
                    : _profile.nim,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFFD9E9FB),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 15),
              Divider(
                color: Colors.white.withValues(alpha: 0.18),
                height: 1,
              ),
              const SizedBox(height: 14),
              _buildIdentityRow(
                Icons.school_outlined,
                _profile.sekolah.trim().isEmpty
                    ? 'Sekolah / kampus belum diisi'
                    : _profile.sekolah,
              ),
              const SizedBox(height: 9),
              _buildIdentityRow(
                Icons.menu_book_rounded,
                _profile.kelas.trim().isEmpty
                    ? 'Kelas / jurusan belum diisi'
                    : _profile.kelas,
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 43,
                child: OutlinedButton.icon(
                  onPressed: _showEditDialog,
                  icon: const Icon(Icons.edit_outlined, size: 17),
                  label: const Text(
                    'Edit Identitas',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                    backgroundColor: Colors.white.withValues(alpha: 0.08),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIdentityRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: const Color(0xFFB9D9FA),
          size: 17,
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              height: 1.4,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatistics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeading(
          'Progres Belajar',
          'Ringkasan aktivitas belajarmu',
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.menu_book_rounded,
                value: '$_modulCount',
                label: 'Modul selesai',
                color: _blue,
                background: const Color(0xFFE9F3FF),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildStatCard(
                icon: Icons.play_circle_fill_rounded,
                value: '$_simulasiCount',
                label: 'Simulasi',
                color: const Color(0xFF16A085),
                background: const Color(0xFFE5F8F3),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildStatCard(
                icon: Icons.emoji_events_rounded,
                value: _rataRata.toStringAsFixed(0),
                label: 'Rata-rata',
                color: const Color(0xFFE5A52D),
                background: const Color(0xFFFFF5DF),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required Color background,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE9EEF5)),
      ),
      child: Column(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: _textDark,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 10,
              height: 1.3,
              color: _textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeading(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 11,
            color: _textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard(List<_MenuData> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8EDF4)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF203653).withValues(alpha: 0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _buildMenuTile(items[i]),
            if (i != items.length - 1)
              const Padding(
                padding: EdgeInsets.only(left: 72),
                child: Divider(
                  height: 1,
                  color: Color(0xFFF0F3F7),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuTile(_MenuData item) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  item.icon,
                  color: item.color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: const TextStyle(
                        fontSize: 10,
                        height: 1.4,
                        color: _textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 7),
              const Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: Color(0xFFAFBAC8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      height: 51,
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _handleLogout,
        icon: const Icon(Icons.logout_rounded, size: 19),
        label: const Text(
          'Keluar dari Akun',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: _red,
          side: const BorderSide(
            color: Color(0xFFF3C8CC),
          ),
          backgroundColor: const Color(0xFFFFF7F7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class _MenuData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _MenuData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}