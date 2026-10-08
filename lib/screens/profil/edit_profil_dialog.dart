import 'package:flutter/material.dart';
import '../../models/user_profile_model.dart';
import '../../services/storage_service.dart';

class EditProfilDialog extends StatefulWidget {
  final UserProfile currentProfile;
  final VoidCallback onSaved;

  const EditProfilDialog({
    super.key,
    required this.currentProfile,
    required this.onSaved,
  });

  @override
  State<EditProfilDialog> createState() => _EditProfilDialogState();
}

class _EditProfilDialogState extends State<EditProfilDialog> {
  late TextEditingController _namaController;
  late TextEditingController _nimController;
  late TextEditingController _sekolahController;
  late TextEditingController _kelasController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.currentProfile.nama);
    _nimController = TextEditingController(text: widget.currentProfile.nim);
    _sekolahController = TextEditingController(text: widget.currentProfile.sekolah);
    _kelasController = TextEditingController(text: widget.currentProfile.kelas);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _sekolahController.dispose();
    _kelasController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final updated = widget.currentProfile.copyWith(
        nama: _namaController.text.trim(),
        nim: _nimController.text.trim(),
        sekolah: _sekolahController.text.trim(),
        kelas: _kelasController.text.trim(),
        isGuest: false,
      );
      await StorageService.saveUserProfile(updated);
      widget.onSaved();
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Edit Identitas Siswa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nimController,
                decoration: const InputDecoration(labelText: 'NIM / NISN'),
                validator: (v) => v == null || v.trim().isEmpty ? 'NIM wajib diisi' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _sekolahController,
                decoration: const InputDecoration(labelText: 'Asal Sekolah / Kampus'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _kelasController,
                decoration: const InputDecoration(labelText: 'Kelas / Jurusan'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: _save,
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
