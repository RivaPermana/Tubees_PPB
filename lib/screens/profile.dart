import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'edit_profile.dart';
import 'home_page.dart';
import 'reward.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;

  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen(userId: widget.userId)),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => RewardScreen(userId: widget.userId)),
      );
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  void showCustomDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(content),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(85, 132, 122, 0.97),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  minimumSize: const Size(0, 0),
                ),
                child: const Text(
                  "Tutup",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(235, 255, 255, 255),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditProfileScreen(userId: widget.userId),
                ),
              );
            },
            child: const Text('Edit', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFFE0DDFB),
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Welcome Bambang Pamungkas',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _infoCard(
                        title: ' Total Poin', value: '10.000 Poin', showStar: true),
                    const SizedBox(width: 16),
                    _infoCard(
                        title: 'Misi', value: '1/2 Misi', showStar: false),
                  ],
                ),
                const SizedBox(height: 20),
                Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      const ListTile(
                        leading: Icon(Icons.assignment),
                        title: Text('Riwayat Misi'),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.help_center),
                        title: const Text('Pusat Bantuan'),
                        onTap: () {
                          showCustomDialog(
                            "Pusat Bantuan",
                            '''Q: Bagaimana cara menyelesaikan misi?
A: Ikuti instruksi yang tersedia di halaman utama aplikasi.

Q: Mengapa poin saya tidak bertambah?
A: Pastikan misi diselesaikan dengan benar dan koneksi internet stabil.

Q: Bagaimana cara menukarkan poin?
A: Buka halaman Reward dan pilih hadiah yang tersedia.

Q: Bagaimana cara edit profil?
A: Tekan tombol “Edit” di kanan atas halaman profil, lalu ubah data yang diinginkan. Setelah selesai, tekan save di kanan atas.

Untuk bantuan lebih lanjut, hubungi support@cleanquest.id
                            ''',
                          );
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.description),
                        title: const Text('Syarat dan Ketentuan'),
                        onTap: () {
                          showCustomDialog(
                            "Syarat dan Ketentuan",
                            '''1. Poin hanya dapat ditukarkan dengan hadiah dalam aplikasi.
2. Manipulasi sistem misi akan dikenai sanksi.
3. Data pengguna dilindungi dan tidak dibagikan tanpa izin.
4. Penggunaan aplikasi tunduk pada perubahan kebijakan sewaktu-waktu.
5. Pengembang tidak bertanggung jawab atas kehilangan data atau kerugian akibat penyalahgunaan akun oleh pihak ketiga (misalnya, teman, keluarga, atau orang lain yang mengakses akun Anda tanpa izin).
                            ''',
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 16),
                    backgroundColor: const Color.fromRGBO(85, 132, 122, 0.97),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Log Out',
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Reward',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _infoCard(
      {required String title, required String value, required bool showStar}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 14)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showStar) ...[
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 8),
              ],
              Text(value,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
