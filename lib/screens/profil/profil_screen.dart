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

    if (mounted) {
      setState(() {
        _profile = prof;
        _modulCount = mods.length;
        _simulasiCount = sims.length;
        _rataRata = avg;
      });
    }
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
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _confirmResetData() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reset Data Aplikasi?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: const Text(
          'Tindakan ini akan mengosongkan kembali skor kuis, riwayat simulasi, dan checklist untuk pengujian baru.',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await StorageService.resetAllData();
              _loadProfileData();
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data berhasil di-reset ke kondisi awal.')),
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
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('Profil Siswa & Pengaturan', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_rounded, size: 26),
            tooltip: 'Edit Identitas',
            onPressed: _showEditDialog,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Header Profil Siswa
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: const Color(0xFFFFEBEE),
                  child: const Icon(Icons.person_rounded, size: 44, color: Colors.redAccent),
                ),
                const SizedBox(height: 12),
                Text(
                  _profile.nama,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_profile.nim} • ${_profile.kelas}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  _profile.sekolah,
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),

                // Baris Statistik Belajar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem('$_modulCount', 'Modul Dibaca'),
                    Container(height: 24, width: 1, color: Colors.grey.shade300),
                    _buildStatItem('$_simulasiCount', 'Simulasi Selesai'),
                    Container(height: 24, width: 1, color: Colors.grey.shade300),
                    _buildStatItem(_rataRata.toStringAsFixed(0), 'Rata-rata Nilai'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Menu Opsi Profil
          const Text('Fitur Tambahan & Akun', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          _buildProfileTile(
            icon: Icons.badge_outlined,
            title: 'Data Identitas Siswa',
            subtitle: 'Ubah Nama, NIM, dan Asal Kampus',
            onTap: _showEditDialog,
          ),
          _buildProfileTile(
            icon: Icons.history_rounded,
            title: 'Riwayat Percobaan & Nilai',
            subtitle: 'Catatan log skor kuis dan simulasi',
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RiwayatNilaiScreen()),
              );
              _loadProfileData();
            },
          ),
          _buildProfileTile(
            icon: Icons.card_membership_rounded,
            title: 'Unduh Sertifikat Tanggap Bencana',
            subtitle: 'Sertifikat kelulusan digital atas nama peserta',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SertifikatScreen()),
              );
            },
          ),
          _buildProfileTile(
            icon: Icons.backpack_rounded,
            title: 'Checklist Tas Siaga Bencana',
            subtitle: 'Daftar perbekalan bertahan 72 jam BNPB',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TasSiagaScreen()),
              );
            },
          ),
          _buildProfileTile(
            icon: Icons.contact_phone_outlined,
            title: 'Kontak Darurat Nasional (SOS)',
            subtitle: 'Daftar panggilan cepat 112, 113, 115, 118',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NomorDaruratScreen()),
              );
            },
          ),
          _buildProfileTile(
            icon: Icons.info_outline_rounded,
            title: 'Tentang Aplikasi DISASTER-X',
            subtitle: 'Informasi pengembang dan tugas kuliah',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TentangAplikasiScreen()),
              );
            },
          ),
          _buildProfileTile(
            icon: Icons.restart_alt_rounded,
            title: 'Reset Data Pengerjaan (Demo Ujian)',
            subtitle: 'Kembalikan progres nilai ke default',
            onTap: _confirmResetData,
          ),

          const SizedBox(height: 16),

          // Tombol Keluar (Logout)
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.redAccent),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                foregroundColor: Colors.redAccent,
              ),
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Keluar Akun', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: _handleLogout,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.redAccent, size: 24),
        title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
