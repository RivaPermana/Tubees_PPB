import 'dart:io';

import 'package:cleanquest/screens/profile.dart';
import 'package:cleanquest/screens/reward.dart';
import 'package:flutter/material.dart';
import '../models/mission.dart';
import '../models/user.dart';
import '../models/user_mission.dart';
import '../services/api_service.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  final int userId; // Tambahkan userId sebagai parameter

  HomeScreen(
      {required this.userId}); // Tambahkan konstruktor untuk menerima userId

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User user;
  late ApiService apiService;
  List<Mission> missions = [];
  int completedMissionsCount = 0;
  int totalMissionsCount = 0;
  bool isLoading = true;
  //int _currentIndex = 0; // Untuk melacak tab yang aktif
  //late List<Widget> _pages; // Daftar halaman

  @override
  void initState() {
    super.initState();
    // Tambahkan halaman RewardScreen ke daftar halaman
    /*_pages = [
      HomeScreen(userId: widget.userId), // Halaman Home
      ProfileScreen(userId: widget.userId), // Halaman Profile
      RewardScreen(), // Halaman Reward
    ];*/
    apiService = ApiService();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final userId = widget.userId; // Gunakan userId dari widget
      final fetchedUser = await apiService.getUserData(userId);
      final fetchedMissions = await apiService.getMissions();

      // Hitung jumlah total misi dan misi yang sudah diselesaikan
      final completedMissions =
          fetchedUser.missions.where((mission) => mission.isCompleted).length;

      setState(() {
        user = fetchedUser;
        missions = fetchedMissions;
        totalMissionsCount = fetchedMissions.length;
        completedMissionsCount = completedMissions;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _toggleMissionStatus(String missionId) async {
    setState(() => isLoading = true);

    final userMission =
        user.missions.firstWhere((m) => m.missionId == missionId);
    final newStatus = !userMission.isCompleted;

    try {
      await apiService.updateMissionStatus(
          int.parse(userMission.missionId), newStatus);
      setState(() {
        userMission.isCompleted = newStatus;

        // Update points
        final mission = missions.firstWhere((m) => m.id == missionId);
        user.points += newStatus ? mission.points : -mission.points;
      });
    } catch (e) {
      print('Error updating mission status: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showSubmitDialog(BuildContext context, String missionId) {
    final BuildContext parentContext =
        context; // Simpan context sebelum dialog dibuka
    var userId = widget.userId;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Submit Misi'),
        content: Text(
            'Rekam bukti hingga terlihat jelas kondisi before dan after-nya.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel button
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close the dialog

              // Rekam video
              XFile? video = await recordVideo();
              if (video != null) {
                // Kirim video ke API
                try {
                  // Kirim video ke API
                  await apiService.submitMissionProof(
                    userId: userId,
                    missionId: int.parse(missionId),
                    videoFile: File(video.path),
                  );

                  // Tampilkan Snackbar setelah submit berhasil
                  ScaffoldMessenger.of(parentContext).showSnackBar(
                    SnackBar(
                      content: Text('Bukti misi berhasil disubmit!'),
                      duration: Duration(seconds: 3),
                      backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
                    ),
                  );

                  // Refresh state setelah submit
                  setState(() {});
                } catch (e) {
                  // Tampilkan Snackbar jika terjadi kesalahan
                  ScaffoldMessenger.of(parentContext).showSnackBar(
                    SnackBar(
                      content: Text('Gagal mengirim bukti misi. Coba lagi!'),
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<XFile?> recordVideo() async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickVideo(source: ImageSource.camera);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 66),
                        Text(
                          'Halo ${user.username}!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 24),
                        _buildUserStats(),
                        SizedBox(height: 32),
                        Text(
                          'Misi Hari Ini',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildMissionList(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildUserStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildProgressIndicator(),
        SizedBox(width: 16),
        _buildPointsIndicator(),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.assignment, color: Colors.teal),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$completedMissionsCount/$totalMissionsCount Misi',
                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Telah Dikerjakan',
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPointsIndicator() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.star, color: Colors.amber),
          SizedBox(width: 8),
          Text(
            '${user.points} Poin',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: missions.length,
      itemBuilder: (context, index) {
        final mission = missions[index];
        final userMission =
            user.missions.firstWhere((m) => m.missionId == mission.id);
        return _buildMissionCard(mission, userMission);
      },
    );
  }

  Widget _buildMissionCard(Mission mission, UserMission userMission) {
    return GestureDetector(
      //onTap: () => _toggleMissionStatus(mission.id),
      onTap: () => _showSubmitDialog(context, mission.id),
      child: Card(
        margin: EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: AspectRatio(
                    aspectRatio: 2,
                    child: Image.asset(
                      mission.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (userMission.isCompleted)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Selesai',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      mission.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      SizedBox(width: 4),
                      Text(
                        '${mission.points}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      onTap: (index) {
        if (index == 0) {
          // Pindah ke halaman Home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(userId: user.id)),
          );
        } else if (index == 1) {
          // Pindah ke halaman Reward
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RewardScreen(userId: user.id,)),
          );
        } else if (index == 2) {
          // Pindah ke halaman Profile
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen(userId: user.id,)),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.card_giftcard),
          label: 'Reward',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
