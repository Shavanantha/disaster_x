class PilihanKeputusan {
  final String kode; // 'A', 'B', 'C'
  final String teks;
  final bool isAman;
  final int skorDelta;
  final String judulFeedback;
  final String feedback;

  const PilihanKeputusan({
    required this.kode,
    required this.teks,
    required this.isAman,
    required this.skorDelta,
    required this.judulFeedback,
    required this.feedback,
  });
}

class SimulasiCheckpoint {
  final int detik;
  final String judul;
  final String narasiSituasi;
  final List<PilihanKeputusan> pilihan;

  const SimulasiCheckpoint({
    required this.detik,
    required this.judul,
    required this.narasiSituasi,
    required this.pilihan,
  });
}

class SkenarioSimulasi {
  final String id;
  final String judul;
  final String kategori;
  final String durasi;
  final int totalDetik;
  final String tingkatKesulitan;
  final String deskripsi;
  final int warnaHex;
  final String iconCode;
  final String statusAwal; // 'Tersedia' / 'Terkunci'
  final String prolog;
  final String pesanSelesai;
  final List<SimulasiCheckpoint> checkpoints;

  const SkenarioSimulasi({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.durasi,
    required this.totalDetik,
    required this.tingkatKesulitan,
    required this.deskripsi,
    required this.warnaHex,
    required this.iconCode,
    required this.statusAwal,
    required this.prolog,
    required this.pesanSelesai,
    required this.checkpoints,
  });
}
