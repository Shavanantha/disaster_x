class SoalKuis {
  final String pertanyaan;
  final List<String> pilihan;
  final int indexJawabanBenar;
  final String penjelasan;

  const SoalKuis({
    required this.pertanyaan,
    required this.pilihan,
    required this.indexJawabanBenar,
    required this.penjelasan,
  });
}

class PaketKuis {
  final String id;
  final String judul;
  final String kategori;
  final int jumlahSoal;
  final int batasWaktuMenit;
  final int warnaHex;
  final List<SoalKuis> daftarSoal;

  const PaketKuis({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.jumlahSoal,
    required this.batasWaktuMenit,
    required this.warnaHex,
    required this.daftarSoal,
  });
}
