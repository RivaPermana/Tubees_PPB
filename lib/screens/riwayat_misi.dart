import 'package:flutter/material.dart';

class RiwayatMisiScreen extends StatelessWidget {
  const RiwayatMisiScreen({Key? key}) : super(key: key);

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
        return const Color(0xFF4CAF50); 
      case 'pending':
        return const Color(0xFFFFA726); 
      default:
        return const Color(0xFF757575); // Abu-abu untuk status lain
    }
  }

  Widget buildCard({
    required String tanggal,
    required String jam,
    required String judul,
    required String status,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(Icons.calendar_today_outlined, size: 18),
              const SizedBox(width: 8),
              Text(tanggal),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: getStatusColor(status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.access_time, size: 18),
              const SizedBox(width: 8),
              Text(jam),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.menu_book_outlined, size: 18),
              const SizedBox(width: 8),
              Text(judul),
            ]),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF557D7A),
      appBar: AppBar(
        title: const Text('Riwayat Misi'),
        centerTitle: true,
        backgroundColor: const Color(0xFF557D7A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            buildCard(
              tanggal: 'Senin, 26 Mei 2025',
              jam: '12.30',
              judul: 'Membersihkan Kamar',
              status: 'Pending',
            ),
            buildCard(
              tanggal: 'Selasa, 26 Mei 2025',
              jam: '10.00',
              judul: 'Membersihkan Halaman Rumah',
              status: 'Selesai',
            ),
            buildCard(
              tanggal: 'Rabu, 25 Mei 2025',
              jam: '15.45',
              judul: 'Membersihkan Selokan',
              status: 'Selesai',
            ),
          ],
        ),
      ),
    );
  }
}
