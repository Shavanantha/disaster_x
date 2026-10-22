
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
  static const Color _navy = Color(0xFF17345C);
  static const Color _blue = Color(0xFF2878C8);
  static const Color _red = Color(0xFFE84B55);
  static const Color _textDark = Color(0xFF1D2D42);
  static const Color _textMuted = Color(0xFF7B899B);

  late TextEditingController _namaController;
  late TextEditingController _nimController;
  late TextEditingController _sekolahController;
  late TextEditingController _kelasController;

  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _namaController = TextEditingController(
      text: widget.currentProfile.nama,
    );
    _nimController = TextEditingController(
      text: widget.currentProfile.nim,
    );
    _sekolahController = TextEditingController(
      text: widget.currentProfile.sekolah,
    );
    _kelasController = TextEditingController(
      text: widget.currentProfile.kelas,
    );
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
    if (_isSaving) return;

    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final updated = widget.currentProfile.copyWith(
        nama: _namaController.text.trim(),
        nim: _nimController.text.trim(),
        sekolah: _sekolahController.text.trim(),
        kelas: _kelasController.text.trim(),
        isGuest: false,
      );

      await StorageService.saveUserProfile(updated);

      if (!mounted) return;

      widget.onSaved();
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil gagal disimpan. Silakan coba lagi.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 24,
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 430),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F9FC),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: _navy.withValues(alpha: 0.15),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informasi Pribadi',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: _textDark,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Pastikan identitasmu sudah benar.',
                          style: TextStyle(
                            fontSize: 11,
                            color: _textMuted,
                          ),
                        ),
                        const SizedBox(height: 20),

                        _buildInput(
                          controller: _namaController,
                          label: 'Nama Lengkap',
                          hint: 'Masukkan nama lengkap',
                          icon: Icons.person_outline_rounded,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Nama lengkap wajib diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _buildInput(
                          controller: _nimController,
                          label: 'NIM / NISN',
                          hint: 'Masukkan nomor identitas',
                          icon: Icons.badge_outlined,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'NIM / NISN wajib diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _buildInput(
                          controller: _sekolahController,
                          label: 'Asal Sekolah / Kampus',
                          hint: 'Masukkan nama sekolah atau kampus',
                          icon: Icons.school_outlined,
                        ),
                        const SizedBox(height: 16),

                        _buildInput(
                          controller: _kelasController,
                          label: 'Kelas / Jurusan',
                          hint: 'Masukkan kelas atau jurusan',
                          icon: Icons.menu_book_rounded,
                        ),

                        const SizedBox(height: 24),

                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 47,
                                child: OutlinedButton(
                                  onPressed: _isSaving
                                      ? null
                                      : () => Navigator.pop(context),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: _textMuted,
                                    side: const BorderSide(
                                      color: Color(0xFFDCE4EF),
                                    ),
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: const Text(
                                    'Batal',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                height: 47,
                                child: ElevatedButton.icon(
                                  onPressed: _isSaving ? null : _save,
                                  icon: _isSaving
                                      ? const SizedBox(
                                          width: 17,
                                          height: 17,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.check_rounded,
                                          size: 19,
                                        ),
                                  label: Text(
                                    _isSaving
                                        ? 'Menyimpan...'
                                        : 'Simpan Perubahan',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _blue,
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor:
                                        _blue.withValues(alpha: 0.6),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 22, 18, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_navy, Color(0xFF24558B), _blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 49,
            height: 49,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            child: const Icon(
              Icons.manage_accounts_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Profil',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Perbarui identitas akun DISASTER-X',
                  style: TextStyle(
                    color: Color(0xFFD9E9FB),
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Tutup',
            onPressed: _isSaving ? null : () => Navigator.pop(context),
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          textCapitalization: TextCapitalization.words,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: _textDark,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 12,
              color: Color(0xFFA2ADBB),
              fontWeight: FontWeight.normal,
            ),
            prefixIcon: Icon(
              icon,
              color: _blue,
              size: 20,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 15,
            ),
            errorStyle: const TextStyle(fontSize: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFFE1E8F1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFFE1E8F1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: _blue,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: _red,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: _red,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}