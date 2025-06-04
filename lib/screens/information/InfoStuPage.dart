import 'dart:convert';
import 'package:bab_babbab_front/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';

class InformationStuPage extends StatefulWidget {
  const InformationStuPage({super.key});
  @override
  State<InformationStuPage> createState() => _InformationStuPage();
}

class _InformationStuPage extends State<InformationStuPage> {
  final TextEditingController _schoolController = TextEditingController();
  String? selectedGrade;
  String? selectedClass;
  List<String> availableClasses = [];
  List<String> classList = []; // 반 리스트 정의
  List<String> gradeList = ['1', '2', '3']; // 학년 리스트 정의
  bool isLoading = false;

  Future<void> fetchClasses() async {
    final schoolName = _schoolController.text.trim();
    if (!schoolName.endsWith("중학교") && !schoolName.endsWith("고등학교")) return;

    setState(() {
      isLoading = true;
      availableClasses = [];
      selectedClass = null;
    });

    final apiKey = dotenv.env['NEIS_API_KEY'];
    final encoded = Uri.encodeComponent(schoolName);
    final schoolUrl =
        'https://open.neis.go.kr/hub/schoolInfo?KEY=$apiKey&Type=json&SCHUL_NM=$encoded';

    final res = await http.get(Uri.parse(schoolUrl));
    final schoolData = jsonDecode(res.body);
    final rows = schoolData['schoolInfo']?[1]?['row'];

    if (rows == null || rows.isEmpty) return;

    final school = rows[0];
    final schoolCode = school['SD_SCHUL_CODE'];
    final officeCode = school['ATPT_OFCDC_SC_CODE'];

    final isMiddle = schoolName.endsWith("중학교");
    final endpoint =
        isMiddle
            ? 'https://open.neis.go.kr/hub/misTimetable'
            : 'https://open.neis.go.kr/hub/hisTimetable';

    final grade = selectedGrade ?? "1";
    final timetableUrl =
        '$endpoint?KEY=$apiKey&Type=json&ATPT_OFCDC_SC_CODE=$officeCode&SD_SCHUL_CODE=$schoolCode&GRADE=$grade';

    final timetableRes = await http.get(Uri.parse(timetableUrl));
    final timetableData = jsonDecode(timetableRes.body);
    final timetableRows =
        timetableData[isMiddle ? 'misTimetable' : 'hisTimetable']?[1]?['row'];

    if (timetableRows != null) {
      final classSet = <String>{};
      for (final row in timetableRows) {
        if (row['CLASS_NM'] != null) classSet.add(row['CLASS_NM']);
      }
      setState(() {
        availableClasses =
            classSet.toList()..sort(
              (a, b) => int.parse(a).compareTo(int.parse(b)),
            ); // 숫자 기준 정렬
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<List<String>> fetchClassListForGrade(String grade) async {
    await fetchClasses(); // 기존 함수 사용해서 class 리스트 업데이트
    return availableClasses;
  }

  bool get isFormValid =>
      _schoolController.text.isNotEmpty &&
      selectedGrade != null &&
      selectedClass != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            const Text(
              "이름님의 학교\n정보를 작성해주세요.",
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: _schoolController,
              onChanged: (_) {
                // 초기화
                setState(() {
                  selectedGrade = null;
                  selectedClass = null;
                  availableClasses = [];
                  classList = [];
                });
              },
              decoration: InputDecoration(
                fillColor: Color(0xffF8F8F8),
                filled: true,
                hintText: '학교를 입력해주세요. 예) 서울고등학교',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(width: 1, color: Color(0xffF8F8F8)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Color(0xffF8F8F8)),
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton2<String>(
                  value: selectedGrade,
                  hint: Text(
                    '학년 선택',
                    style: TextStyle(fontSize: 18, fontFamily: 'Pretendard'),
                  ),
                  underline: const SizedBox(),
                  isExpanded: true,
                  onChanged: (value) async {
                    setState(() {
                      selectedGrade = value;
                      selectedClass = null;
                      classList = [];
                    });

                    if (value != null) {
                      final fetchedClasses = await fetchClassListForGrade(
                        value,
                      );
                      setState(() {
                        classList = fetchedClasses;
                      });
                    }
                  },
                  items:
                      gradeList.map((item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Center(
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 18,
                                fontFamily: 'Pretendard',
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                  buttonStyleData: ButtonStyleData(
                    height: 60,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xffF8F8F8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
                    elevation: 2,
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(Icons.arrow_drop_down),
                  ),
                ),
                const SizedBox(width: 30),
                DropdownButton2<String>(
                  value: selectedClass,
                  hint: Text(
                    '반 선택',
                    style: TextStyle(fontSize: 18, fontFamily: 'Pretendard'),
                  ),
                  underline: const SizedBox(),
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      selectedClass = value;
                    });
                  },
                  items:
                      classList.map((item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Center(
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 18,
                                fontFamily: 'Pretendard',
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                  buttonStyleData: ButtonStyleData(
                    height: 60,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xffF8F8F8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
                    elevation: 2,
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(Icons.arrow_drop_down),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 340),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(336, 60),
                backgroundColor: const Color(0xffFFAD0A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (selectedGrade != null && selectedClass != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(), // 실제 페이지로 교체
                    ),
                  );
                }
              },
              child: const Text(
                '시작하기',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
