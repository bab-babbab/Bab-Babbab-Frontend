import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MealService {
  static String get _mealApiKey => dotenv.env['NEIS_API_KEY'] ?? '';

  static Future<Map<String, String>> getSchoolInfo(String schoolName) async {
    final encodedName = Uri.encodeComponent(schoolName);
    final url =
        'https://open.neis.go.kr/hub/schoolInfo?KEY=$_mealApiKey&Type=json&SCHUL_NM=$encodedName';

    final response = await http.get(Uri.parse(url));
    print('📦 schoolInfo response: ${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final row = data['schoolInfo'][1]['row'][0];
      if (row == null || row.isEmpty) {
        throw Exception('학교 정보를 찾을 수 없습니다');
      }

      return {
        'schoolCode': row['SD_SCHUL_CODE'],
        'eduOfficeCode': row['ATPT_OFCDC_SC_CODE'],
      };
    } else {
      throw Exception('학교 정보를 불러올 수 없습니다');
    }
  }

  static Future<List<Map<String, String>>> getMealInfo({
    required String eduOfficeCode,
    required String schoolCode,
    required String date,
  }) async {
    final url =
        'https://open.neis.go.kr/hub/mealServiceDietInfo?KEY=$_mealApiKey&Type=json&ATPT_OFCDC_SC_CODE=$eduOfficeCode&SD_SCHUL_CODE=$schoolCode&MLSV_YMD=$date';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final rows = data['mealServiceDietInfo'][1]['row'];
      if (rows == null || rows.isEmpty) {
        throw Exception('해당 날짜의 급식 정보가 없습니다.');
      }

      return rows.map<Map<String, String>>((row) => {
        'mealType': row['MMEAL_SC_NM'].toString(),
        'meal': row['DDISH_NM'].toString().replaceAll('<br/>', ', '),
        'calories': row['CAL_INFO'].toString(),
      }).toList();

    } else {
      throw Exception('급식 정보를 불러올 수 없습니다');
    }
  }
}
