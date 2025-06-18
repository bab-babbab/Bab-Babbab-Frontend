import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bab_babbab_front/service/environment_service.dart';

class EnvironmentNews extends StatefulWidget {
  const EnvironmentNews({super.key});

  @override
  _EnvironmentNewsState createState() => _EnvironmentNewsState();
}

class _EnvironmentNewsState extends State<EnvironmentNews> {
  late Future<List<Map<String, String>>> environmentArticles;

  @override
  void initState() {
    super.initState();
    environmentArticles = EnvironmentService.fetchEnvironmentNews();
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, String>>>(
      future: environmentArticles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('환경 뉴스를 불러오지 못했어요.'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('환경 관련 뉴스가 없습니다.'));
        } else {
          final article = snapshot.data!.first;

          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                Image.asset('assets/icon/earth.png', width: 53, height: 53),
                const SizedBox(width: 30),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article['title']!,
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          color: Color(0xff898A8D),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => _launchURL(article['link']!),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '보러가기',
                              style: TextStyle(
                                color: Color(0xff898A8D),
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.chevron_right,
                              color: Color(0xff898A8D),
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
              ],
            ),
          );
        }
      },
    );
  }
}