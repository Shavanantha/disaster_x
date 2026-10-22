
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile_model.dart';

class StorageService {
  static const String _keyProfile = 'user_profile';
  static const String _keyCompletedModules = 'completed_modules';
  static const String _keyUnlockedScenarios = 'unlocked_scenarios';
  static const String _keySimulationScores = 'simulation_scores';
  static const String _keyQuizScores = 'quiz_scores';
  static const String _keyScoreHistory = 'score_history';
  static const String _keyTasSiagaChecked = 'tas_siaga_checked';
  static const String _keyIsLoggedIn = 'is_logged_in';

  // ================= INISIALISASI =================

  static Future<SharedPreferences> _getPrefs() async {
    return SharedPreferences.getInstance();
  }

  // ================= LOGIN =================

  static Future<bool> isLoggedIn() async {
    final prefs = await _getPrefs();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_keyIsLoggedIn, value);
  }

  // ================= PROFIL PENGGUNA =================

  static Future<UserProfile> getUserProfile() async {
    final prefs = await _getPrefs();
    final jsonString = prefs.getString(_keyProfile);

    if (jsonString != null) {
      try {
        final decoded = jsonDecode(jsonString);

        if (decoded is Map<String, dynamic>) {
          return UserProfile.fromMap(decoded);
        }
      } catch (_) {
        // Gunakan profil default jika data tidak valid.
      }
    }

    // Profil default untuk pengguna baru.
    return const UserProfile(
      nama: 'Pengguna DISASTER-X',
      nim: '',
      sekolah: '',
      kelas: '',
      isGuest: true,
    );
  }

  static Future<void> saveUserProfile(UserProfile profile) async {
    final prefs = await _getPrefs();
    await prefs.setString(
      _keyProfile,
      jsonEncode(profile.toMap()),
    );
  }

  // ================= MODUL SELESAI =================

  static Future<List<String>> getCompletedModules() async {
    final prefs = await _getPrefs();

    return prefs.getStringList(_keyCompletedModules) ?? [];
  }

  static Future<void> markModuleCompleted(String moduleId) async {
    final prefs = await _getPrefs();
    final completedModules =
        prefs.getStringList(_keyCompletedModules) ?? [];

    if (!completedModules.contains(moduleId)) {
      completedModules.add(moduleId);

      await prefs.setStringList(
        _keyCompletedModules,
        completedModules,
      );
    }
  }

  // ================= SKENARIO SIMULASI =================

  static Future<List<String>> getUnlockedScenarios() async {
    final prefs = await _getPrefs();

    // Ketiga skenario tersedia secara default.
    // Ubah daftar ini jika nantinya ada sistem pembukaan level.
    return prefs.getStringList(_keyUnlockedScenarios) ??
        ['gempa_kelas', 'kebakaran_lab', 'banjir_tanggul'];
  }

  // ================= NILAI SIMULASI =================

  static Future<Map<String, int>> getSimulationScores() async {
    final prefs = await _getPrefs();
    final jsonString = prefs.getString(_keySimulationScores);

    if (jsonString == null) {
      return {};
    }

    try {
      final decoded = jsonDecode(jsonString);

      if (decoded is Map<String, dynamic>) {
        final scores = <String, int>{};

        decoded.forEach((key, value) {
          if (value is num) {
            scores[key] = value.toInt().clamp(0, 100);
          }
        });

        return scores;
      }
    } catch (_) {
      // Data tidak valid dianggap belum memiliki nilai.
    }

    return {};
  }

  static Future<void> saveSimulationScore(
    String scenarioId,
    int score, {
    String? scenarioTitle,
  }) async {
    final prefs = await _getPrefs();
    final validScore = score.clamp(0, 100);

    final currentScores = await getSimulationScores();
    final previousScore = currentScores[scenarioId];

    // Simpan skor terbaik untuk setiap skenario.
    if (previousScore == null || validScore > previousScore) {
      currentScores[scenarioId] = validScore;

      await prefs.setString(
        _keySimulationScores,
        jsonEncode(currentScores),
      );
    }

    // Setiap percobaan tetap masuk ke riwayat.
    final title = scenarioTitle?.trim().isNotEmpty == true
        ? scenarioTitle!.trim()
        : _formatScenarioTitle(scenarioId);

    await addScoreHistory(
      RiwayatSkorItem(
        id: _generateHistoryId(),
        judul: 'Simulasi: $title',
        kategori: 'Simulasi',
        skor: validScore,
        skorMaksimal: 100,
        tanggal: _formatTanggalSekarang(),
        status: validScore >= 60
            ? 'Lulus Aman'
            : 'Perlu Latihan',
      ),
    );
  }

  // ================= NILAI KUIS =================

  static Future<Map<String, int>> getQuizScores() async {
    final prefs = await _getPrefs();
    final jsonString = prefs.getString(_keyQuizScores);

    if (jsonString == null) {
      return {};
    }

    try {
      final decoded = jsonDecode(jsonString);

      if (decoded is Map<String, dynamic>) {
        final scores = <String, int>{};

        decoded.forEach((key, value) {
          if (value is num) {
            scores[key] = value.toInt().clamp(0, 100);
          }
        });

        return scores;
      }
    } catch (_) {
      // Data tidak valid dianggap belum memiliki nilai.
    }

    return {};
  }

  static Future<void> saveQuizScore(
    String kuisId,
    String judulKuis,
    int score,
  ) async {
    final prefs = await _getPrefs();
    final validScore = score.clamp(0, 100);

    final scores = await getQuizScores();

    // Nilai kuis menyimpan hasil pengerjaan terakhir.
    scores[kuisId] = validScore;

    await prefs.setString(
      _keyQuizScores,
      jsonEncode(scores),
    );

    await addScoreHistory(
      RiwayatSkorItem(
        id: _generateHistoryId(),
        judul: judulKuis,
        kategori: 'Kuis',
        skor: validScore,
        skorMaksimal: 100,
        tanggal: _formatTanggalSekarang(),
        status: validScore >= 75
            ? 'Sangat Baik'
            : validScore >= 60
                ? 'Cukup Baik'
                : 'Perlu Remedial',
      ),
    );
  }

  // ================= RIWAYAT NILAI =================

  static Future<List<RiwayatSkorItem>> getScoreHistory() async {
    final prefs = await _getPrefs();
    final jsonString = prefs.getString(_keyScoreHistory);

    if (jsonString == null) {
      return [];
    }

    try {
      final decoded = jsonDecode(jsonString);

      if (decoded is List) {
        return decoded
            .whereType<Map<String, dynamic>>()
            .map((item) => RiwayatSkorItem.fromMap(item))
            .toList();
      }
    } catch (_) {
      // Data riwayat tidak valid dianggap kosong.
    }

    return [];
  }

  static Future<void> addScoreHistory(
    RiwayatSkorItem item,
  ) async {
    final prefs = await _getPrefs();
    final currentHistory = await getScoreHistory();

    currentHistory.insert(0, item);

    // Batasi riwayat agar penyimpanan tidak terus membesar.
    const maxHistoryItems = 100;

    if (currentHistory.length > maxHistoryItems) {
      currentHistory.removeRange(
        maxHistoryItems,
        currentHistory.length,
      );
    }

    final mappedHistory =
        currentHistory.map((item) => item.toMap()).toList();

    await prefs.setString(
      _keyScoreHistory,
      jsonEncode(mappedHistory),
    );
  }

  // ================= TAS SIAGA =================

  static Future<List<String>> getTasSiagaChecked() async {
    final prefs = await _getPrefs();

    return prefs.getStringList(_keyTasSiagaChecked) ?? [];
  }

  static Future<void> saveTasSiagaChecked(
    List<String> checkedList,
  ) async {
    final prefs = await _getPrefs();

    await prefs.setStringList(
      _keyTasSiagaChecked,
      checkedList,
    );
  }

  // ================= RATA-RATA NILAI =================

  static Future<double> getRataRataNilai() async {
    final quizScores = await getQuizScores();
    final simulationScores = await getSimulationScores();

    final allScores = <int>[
      ...quizScores.values,
      ...simulationScores.values,
    ];

    if (allScores.isEmpty) {
      return 0.0;
    }

    final total = allScores.reduce((a, b) => a + b);

    return (total / allScores.length).roundToDouble();
  }

  // ================= PROGRES PEMBELAJARAN =================

  static Future<double> getOverallProgress() async {
    final completedModules = await getCompletedModules();
    final quizScores = await getQuizScores();
    final simulationScores = await getSimulationScores();

    // Target aplikasi: 4 modul, 3 kuis, dan 3 simulasi.
    const totalTarget = 10;

    final achieved =
        completedModules.length +
        quizScores.length +
        simulationScores.length;

    final progress = achieved / totalTarget;

    return progress.clamp(0.0, 1.0).toDouble();
  }

  // ================= RESET DATA =================

  static Future<void> resetAllData() async {
    final prefs = await _getPrefs();

    // PERHATIAN:
    // prefs.clear() menghapus seluruh data SharedPreferences
    // aplikasi, termasuk data lain yang mungkin disimpan di sana.
    await prefs.clear();
  }

  // ================= HELPER =================

  static String _generateHistoryId() {
    return '${DateTime.now().microsecondsSinceEpoch}';
  }

  static String _formatScenarioTitle(String scenarioId) {
    switch (scenarioId) {
      case 'gempa_kelas':
        return 'Gempa Bumi di Kelas';
      case 'kebakaran_lab':
        return 'Kebakaran di Laboratorium';
      case 'banjir_tanggul':
        return 'Banjir di Tanggul';
      default:
        return scenarioId
            .replaceAll('_', ' ')
            .split(' ')
            .map(
              (word) => word.isEmpty
                  ? word
                  : '${word[0].toUpperCase()}${word.substring(1)}',
            )
            .join(' ');
    }
  }

  static String _formatTanggalSekarang() {
    final now = DateTime.now();

    return '${now.day.toString().padLeft(2, '0')}/'
        '${now.month.toString().padLeft(2, '0')}/'
        '${now.year}';
  }
}