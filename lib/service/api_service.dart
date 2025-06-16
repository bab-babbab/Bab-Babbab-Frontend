import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:bab_babbab_front/models/school_info_dto.dart';
import 'package:image_picker/image_picker.dart';

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

  static Future<int> fetchStreakCount(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stats/sequence/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return int.parse(response.body);
      } else {
        throw Exception('Failed to fetch streak count: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching streak count: $e');
    }
  }

  static Future<http.StreamedResponse> submitUserInfo({
    required String id,
    required String name,
    required String message,
    File? imageFile,
  }) async {
    final uri = Uri.parse('$baseUrl/user/user-info');
    final request = http.MultipartRequest('POST', uri)
      ..fields['id'] = id
      ..fields['name'] = name
      ..fields['message'] = message;

    if (imageFile != null) {
      final image = await http.MultipartFile.fromPath(
        'profile',
        imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(image);
    }

    return await request.send();
  }

  static Future<http.Response> submitSchoolInfo(SchoolInfoDto dto) async {
    final uri = Uri.parse('$baseUrl/user/school-info');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(dto.toJson());

    return await http.post(uri, headers: headers, body: body);
  }

  static Future<http.Response> uploadPost({
    required String userId,
    required String comment,
    XFile? image1,
    XFile? image2,
    XFile? image3,
  }) async {
    try {
      print('uploadPost 시작 - userId: $userId, comment: $comment');
      
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/posts'));

      request.fields['user_id'] = userId;
      request.fields['comment'] = comment;

      if (image1 != null) {
        print('이미지 1 추가: ${image1.path}');
        var file = await http.MultipartFile.fromPath('photo_b', image1.path);
        request.files.add(file);
      }
      if (image2 != null) {
        print('이미지 2 추가: ${image2.path}');
        var file = await http.MultipartFile.fromPath('photo_l', image2.path);
        request.files.add(file);
      }
      if (image3 != null) {
        print('이미지 3 추가: ${image3.path}');
        var file = await http.MultipartFile.fromPath('photo_d', image3.path);
        request.files.add(file);
      }
      print('요청 전송 시작');
      
      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      print('서버 응답 상태: ${streamedResponse.statusCode}');
      print('서버 응답 내용: $responseBody');

      return http.Response(
        responseBody, 
        streamedResponse.statusCode,
        headers: streamedResponse.headers,
      );
    } catch (e) {
      print('uploadPost 오류: $e');
      rethrow;
    }
  }

  static Future<Map<String, int>> fetchActivityData(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stats/daily/$userId'),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return {for (var item in data) item['date']: item['count']};
      } else {
        throw Exception('데이터를 불러오지 못했습니다');
      }
    } catch (e) {
      throw Exception('Error fetching activity data: $e');
    }
  }

  static Future<Map<String, String>> getUserDetails(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/home/user/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final userInfo = responseData['userInfo'];
        final schoolInfo = responseData['schoolInfo'];

        return {
          'name': userInfo['name'] ?? '사용자',
          'grade': schoolInfo['grade']?.toString() ?? '0',
          'class': schoolInfo['class']?.toString() ?? '0',
        };
      } else {
        throw Exception('Failed to load user details: ${response.statusCode}');
      }
    } catch (e) {
      return {'name': '사용자', 'grade': '0', 'class': '0'};
    }
  }
}