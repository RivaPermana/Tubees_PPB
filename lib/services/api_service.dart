import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/mission.dart';
import '../models/voucher.dart';
import 'dart:io';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // Fetch user data
  Future<User> getUserData(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$userId'));
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<List<Mission>> getMissions() async {
    final response = await http.get(Uri.parse('$baseUrl/missions'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((e) => Mission.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load missions');
    }
  }

  Future<void> updateMissionStatus(int userMissionId, bool isCompleted) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/user-missions/$userMissionId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'is_completed': isCompleted}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update mission status');
    }
  }
  Future<void> submitMissionProof({
    required int userId,
    required int missionId,
    required File videoFile,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/submissions'),
    );

    request.fields['user_id'] = userId.toString();
    request.fields['mission_id'] = missionId.toString();
    request.files.add(await http.MultipartFile.fromPath('proof', videoFile.path));

    var response = await request.send();

    if (response.statusCode == 201) {
      print('Submission successful!');
    } else {
      print('Submission failed: ${response.statusCode}');
    }
  }
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'message': 'Failed to register'};
    }
  }

  // Fungsi Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'message': 'Invalid credentials'};
    }
  }

  // Fungsi untuk mengambil voucher
  Future<List<Voucher>> fetchVouchers() async {
    final response = await http.get(Uri.parse("$baseUrl/vouchers"));

    if (response.statusCode == 200) {
      final List<dynamic> voucherJson = json.decode(response.body);
      return voucherJson.map((json) => Voucher.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load vouchers");
    }
  }

  // Fungsi untuk melakukan penukaran poin (exchange)
  Future<bool> submitReward({
    required String phone,
    required String email,
    required int balance,
  }) async {
    final Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    final Map<String, dynamic> body = {
      "phone": phone,
      "email": 'test@gmail.com',
      "balance": balance,
    };

    final response = await http.post(
      Uri.parse("$baseUrl/reward/submit"),  // Pastikan URL ini sesuai dengan route di Laravel
      headers: headers,
      body: json.encode(body),  // Pastikan body request dalam format JSON
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody['status'] == 'success';  // Mengubah pengecekan sesuai status
    } else { 
      print('Error: ${response.body}');
      throw Exception("Failed to submit reward  ");// Menangani error jika request gagal
    }
  }

}

