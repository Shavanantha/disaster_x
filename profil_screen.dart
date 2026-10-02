import 'package:flutter/material.dart';
import 'login_screen.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('Profil Siswa', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Header Profil
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: Color(0xFFFFEBEE),
                  child: Icon(Icons.person_rounded, size: 44, color: Colors.redAccent),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Siswa Tamu (Guest)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Kelas XI - Simulasi Mitigasi',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem('3', 'Modul Dibaca'),
                    Container(height: 24, width: 1, color: Colors.grey.shade300),
                    _buildStatItem('2', 'Simulasi Selesai'),
                    Container(height: 24, width: 1, color: Colors.grey.shade300),
                    _buildStatItem('85', 'Rata-rata Nilai'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Menu Opsi Profil
          const Text('Pengaturan & Akun', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          _buildProfileTile(icon: Icons.badge_outlined, title: 'Data Identitas Siswa'),
          _buildProfileTile(icon: Icons.history_rounded, title: 'Riwayat Percobaan Simulasi'),
          _buildProfileTile(icon: Icons.download_rounded, title: 'Unduh Sertifikat Tanggap Bencana'),
          _buildProfileTile(icon: Icons.info_outline_rounded, title: 'Tentang Aplikasi DISASTER-X'),

          const SizedBox(height: 20),

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
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ),
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

  Widget _buildProfileTile({required IconData icon, required String title}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.redAccent, size: 22),
        title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}