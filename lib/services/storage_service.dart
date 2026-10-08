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

  // Inisialisasi SharedPreferences
  static Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  // ================= LOGIN & USER PROFILE =================
  static Future<bool> isLoggedIn() async {
    final prefs = await _getPrefs();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_keyIsLoggedIn, value);
  }

  static Future<UserProfile> getUserProfile() async {
    final prefs = await _getPrefs();
    final jsonString = prefs.getString(_keyProfile);
    if (jsonString != null) {
      try {
        final Map<String, dynamic> map = jsonDecode(jsonString) as Map<String, dynamic>;
        return UserProfile.fromMap(map);
      } catch (_) {}
    }
    // Default Siswa
    return const UserProfile(
      nama: 'Shava Phiyan Anantha',
      nim: '2413025047',
      sekolah: 'Universitas Lampung',
      kelas: 'Mobile Programming A',
      isGuest: false,
    );
  }

  static Future<void> saveUserProfile(UserProfile profile) async {
    final prefs = await _getPrefs();
    await prefs.setString(_keyProfile, jsonEncode(profile.toMap()));
  }

  // ================= MODUL SELESAI =================
  static Future<List<String>> getCompletedModules() async {
    final prefs = await _getPrefs();
    return prefs.getStringList(_keyCompletedModules) ?? ['gempa'];
  }

  static Future<void> markModuleCompleted(String moduleId) async {
    final prefs = await _getPrefs();
    final list = prefs.getStringList(_keyCompletedModules) ?? ['gempa'];
    if (!list.contains(moduleId)) {
      list.add(moduleId);
      await prefs.setStringList(_keyCompletedModules, list);
    }
  }

  // ================= SIMULASI SKENARIO =================
  static Future<List<String>> getUnlockedScenarios() async {
    final prefs = await _getPrefs();
    return prefs.getStringList(_keyUnlockedScenarios) ?? ['gempa_kelas', 'kebakaran_lab', 'banjir_tanggul'];
  }

  static Future<Map<String, int>> getSimulationScores() async {
    final prefs = await _getPrefs();
    final jsonStr = prefs.getString(_keySimulationScores);
    if (jsonStr != null) {
      try {
        final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
        return decoded.map((k, v) => MapEntry(k, v as int));
      } catch (_) {}
    }
    return {'gempa_kelas': 85};
  }

  static Future<void> saveSimulationScore(String scenarioId, int score) async {
    final prefs = await _getPrefs();
    final currentScores = await getSimulationScores();
    final prevScore = currentScores[scenarioId] ?? 0;
    if (score > prevScore) {
      currentScores[scenarioId] = score;
      await prefs.setString(_keySimulationScores, jsonEncode(currentScores));
    }
    // Catat ke riwayat
    await addScoreHistory(RiwayatSkorItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      judul: 'Simulasi: $scenarioId',
      kategori: 'Simulasi',
      skor: score,
      skorMaksimal: 100,
      tanggal: _formatTanggalSekarang(),
      status: score >= 60 ? 'Lulus Aman' : 'Perlu Latihan',
    ));
  }

  // ================= KUIS EVALUASI =================
  static Future<Map<String, int>> getQuizScores() async {
    final prefs = await _getPrefs();
    final jsonStr = prefs.getString(_keyQuizScores);
    if (jsonStr != null) {
      try {
        final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
        return decoded.map((k, v) => MapEntry(k, v as int));
      } catch (_) {}
    }
    return {'kuis_gempa': 90, 'kuis_kebakaran': 80};
  }

  static Future<void> saveQuizScore(String kuisId, String judulKuis, int score) async {
    final prefs = await _getPrefs();
    final scores = await getQuizScores();
    scores[kuisId] = score;
    await prefs.setString(_keyQuizScores, jsonEncode(scores));

    // Catat ke riwayat
    await addScoreHistory(RiwayatSkorItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      judul: judulKuis,
      kategori: 'Kuis',
      skor: score,
      skorMaksimal: 100,
      tanggal: _formatTanggalSekarang(),
      status: score >= 75 ? 'Sangat Baik' : (score >= 60 ? 'Cukup Baik' : 'Perlu Remedial'),
    ));
  }

  // ================= RIWAYAT NILAI =================
  static Future<List<RiwayatSkorItem>> getScoreHistory() async {
    final prefs = await _getPrefs();
    final jsonStr = prefs.getString(_keyScoreHistory);
    if (jsonStr != null) {
      try {
        final List<dynamic> list = jsonDecode(jsonStr) as List<dynamic>;
        return list.map((e) => RiwayatSkorItem.fromMap(e as Map<String, dynamic>)).toList();
      } catch (_) {}
    }
    // Default initial mock history
    return [
      const RiwayatSkorItem(
        id: '1',
        judul: 'Kuis 1: Prosedur Mitigasi Gempa Bumi',
        kategori: 'Kuis',
        skor: 90,
        skorMaksimal: 100,
        tanggal: '05 Okt 2026',
        status: 'Sangat Baik',
      ),
      const RiwayatSkorItem(
        id: '2',
        judul: 'Kuis 2: Taktik Menghindari Asap APAR',
        kategori: 'Kuis',
        skor: 80,
        skorMaksimal: 100,
        tanggal: '06 Okt 2026',
        status: 'Cukup Baik',
      ),
      const RiwayatSkorItem(
        id: '3',
        judul: 'Simulasi Gempa Bumi Lantai 3',
        kategori: 'Simulasi',
        skor: 85,
        skorMaksimal: 100,
        tanggal: '07 Okt 2026',
        status: 'Lulus Aman',
      ),
    ];
  }

  static Future<void> addScoreHistory(RiwayatSkorItem item) async {
    final prefs = await _getPrefs();
    final currentList = await getScoreHistory();
    currentList.insert(0, item);
    final mapped = currentList.map((e) => e.toMap()).toList();
    await prefs.setString(_keyScoreHistory, jsonEncode(mapped));
  }

  // ================= TAS SIAGA CHECKLIST =================
  static Future<List<String>> getTasSiagaChecked() async {
    final prefs = await _getPrefs();
    return prefs.getStringList(_keyTasSiagaChecked) ?? ['air', 'senter', 'p3k', 'dokumen'];
  }

  static Future<void> saveTasSiagaChecked(List<String> checkedList) async {
    final prefs = await _getPrefs();
    await prefs.setStringList(_keyTasSiagaChecked, checkedList);
  }

  // ================= PERHITUNGAN RATA-RATA & PROGRESS =================
  static Future<double> getRataRataNilai() async {
    final quizScores = await getQuizScores();
    final simScores = await getSimulationScores();

    final allScores = <int>[...quizScores.values, ...simScores.values];
    if (allScores.isEmpty) return 85.0;
    final total = allScores.reduce((a, b) => a + b);
    return (total / allScores.length).roundToDouble();
  }

  static Future<double> getOverallProgress() async {
    final completedModules = await getCompletedModules();
    final quizScores = await getQuizScores();
    final simScores = await getSimulationScores();

    // 4 Modul + 3 Kuis + 3 Simulasi = 10 total target
    const totalTarget = 10;
    final achieved = completedModules.length + quizScores.length + simScores.length;
    final percent = (achieved / totalTarget).clamp(0.0, 1.0);
    return percent;
  }

  // Reset Data (Pembersihan untuk demo ujian)
  static Future<void> resetAllData() async {
    final prefs = await _getPrefs();
    await prefs.clear();
  }

  static String _formatTanggalSekarang() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
  }
}
