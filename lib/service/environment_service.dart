import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvironmentService {
  static Future<List<Map<String, String>>> fetchEnvironmentNews() async {
    final query = '환경오염';
    final encodedQuery = Uri.encodeQueryComponent(query);
    final url =
        'https://openapi.naver.com/v1/search/news.json?query=$encodedQuery&display=5&sort=date';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'X-Naver-Client-Id': dotenv.env['NAVER_CLIENT_ID']!,
        'X-Naver-Client-Secret': dotenv.env['NAVER_CLIENT_SECRET']!,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Map<String, String>> articles = [];
      for (var item in data['items']) {
        articles.add({
          'title': _removeHtmlTags(item['title']),
          'link': item['link'],
        });
      }
      return articles;
    } else {
      throw Exception('뉴스 불러오기 실패');
    }
  }

  static String _removeHtmlTags(String htmlString) {
    return htmlString.replaceAll(RegExp(r'<[^>]*>'), '');
  }
}