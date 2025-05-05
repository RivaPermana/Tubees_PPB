import 'package:flutter/material.dart';
import 'package:cleanquest/screens/profile.dart';

class EditProfileScreen extends StatelessWidget {
  final int userId; // Tambah ini

  const EditProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: 'Bambang Pamungkas');
    final TextEditingController emailController =
        TextEditingController(text: 'Bambang_p@gmail.com');
    final TextEditingController phoneController =
        TextEditingController(text: '081234123412');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen(userId: 12345,)),
              );
            },
            child: const Text('Save', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background + Tombol
          Container(
            height: 250,
            color: Colors.white,
            child: Stack(
              children: [
                // Lingkaran dekorasi
                Positioned(
                  top: 0,
                  left: -50,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Avatar di tengah
                Align(
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Bulatan hitam sebagai placeholder foto profile
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.black, // Bulatan hitam
                      ),
                      // Bulatan putih untuk membuat efek frame
                      const CircleAvatar(
                        radius: 46,
                        backgroundColor: Colors.white,
                      ),
                      // Tombol kamera
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
                          child: const Icon(Icons.camera_alt, size: 15, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Form di bawah
          Container(
            margin: const EdgeInsets.only(top: 200),
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF5D8773), // Warna hijau dari contoh
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: ListView(
              children: [
                _buildTextField(label: 'Nama', controller: nameController),
                const SizedBox(height: 10),
                _buildTextField(label: 'Email', controller: emailController),
                const SizedBox(height: 10),
                _buildTextField(
                    label: 'No. Handphone', controller: phoneController),
                const SizedBox(height: 10),
                _buildTextField(
                  label: 'Tanggal Lahir',
                  hintText: 'Tidak bisa diubah',
                  enabled: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    TextEditingController? controller,
    String? hintText,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          enabled: enabled,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
