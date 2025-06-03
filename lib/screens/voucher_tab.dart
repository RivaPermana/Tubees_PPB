import 'package:flutter/material.dart';

class VoucherTab extends StatelessWidget {
  // Dummy data dengan kategori
  final Map<String, List<Map<String, dynamic>>> categorizedVouchers = {
    'Spesial Buat Kamu': [
      {
        'name': 'Gift Voucher Ice Cream',
        'image': 'assets/images/icecream.png',
        'points': 100,
      },
    ],
    'Voucher Belanja': [
      {
        'name': 'Voucher Fashion A',
        'image': 'assets/images/fashion1.png',
        'points': 100,
      },
      {
        'name': 'Voucher Fashion B',
        'image': 'assets/images/fashion1.png',
        'points': 100,
      },
    ],
    'Voucher Makanan': [
      {
        'name': 'Gift Voucher Ice Cream',
        'image': 'assets/images/icecream.png',
        'points': 100,
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: categorizedVouchers.entries.map((entry) {
          final category = entry.key;
          final vouchers = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: vouchers.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 4,
                ),
                itemBuilder: (context, index) {
                  final voucher = vouchers[index];
                  return GestureDetector(
                    onTap: () {
                      _showConfirmationDialog(context, voucher['name'], voucher['points']);
                    },
                    child: _buildVoucherItem(
                      title: voucher['name'],
                      imagePath: voucher['image'],
                      points: voucher['points'],
                    ),
                  );
                },
              ),
              const SizedBox(height: 0),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildVoucherItem({
    required String title,
    required String imagePath,
    required int points,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 110,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 5),
                    Text('$points Poin'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, String voucherName, int points) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Konfirmasi Penukaran Poin',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text('Kamu akan menukarkan $points poin\nuntuk $voucherName'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(85, 132, 122, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Berhasil menukar $voucherName')),
                );
              },
              child: const Text('Tukar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
