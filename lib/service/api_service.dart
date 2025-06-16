import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:3000';
  
  static Future<List<Map<String, dynamic>>> getRanking() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/ranking'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load ranking: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching ranking: $e');
    }
  }

  static Future<Map<String, dynamic>> getUserInfo(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/home/user/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load user info: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user info: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getPosts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }

  static Future<Map<String, String>> getUserInfoSimple(String userId) async {
    try {
      final response = await getUserInfo(userId);
      final userInfo = response['userInfo'];
      final schoolInfo = response['schoolInfo'];

      String name = userInfo['name'] ?? '사용자';
      String grade = schoolInfo['grade']?.toString() ?? '0';
      String classNum = schoolInfo['class']?.toString() ?? '0';

      return {'name': name, 'grade': grade, 'class': classNum};
    } catch (e) {
      print('사용자 정보 가져오기 오류: $e');
      return {'name': '사용자', 'grade': '0', 'class': '0'};
    }
  }
}