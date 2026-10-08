class BencanaModul {
  final String id;
  final String judul;
  final String kategori;
  final String ringkasan;
  final int warnaHex;
  final String ikon;
  final String capaian;
  final List<String> prabencana;
  final List<String> saatBencana;
  final List<String> pascabencana;
  final List<String> dos;
  final List<String> donts;

  const BencanaModul({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.ringkasan,
    required this.warnaHex,
    required this.ikon,
    required this.capaian,
    required this.prabencana,
    required this.saatBencana,
    required this.pascabencana,
    required this.dos,
    required this.donts,
  });
}

class BeritaTips {
  final String id;
  final String judul;
  final String ringkasan;
  final String konten;
  final String tanggal;
  final String kategori;
  final String ikon;

  const BeritaTips({
    required this.id,
    required this.judul,
    required this.ringkasan,
    required this.konten,
    required this.tanggal,
    required this.kategori,
    required this.ikon,
  });
}
