import 'dart:convert';
import 'package:bab_babbab_front/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:provider/provider.dart';
import 'package:bab_babbab_front/models/user_model.dart';
import 'package:bab_babbab_front/service/api_service.dart';
import 'package:bab_babbab_front/models/school_info_dto.dart';

class InformationStuPage extends StatefulWidget {
  final String id;
  final String name; // 이름 추가

  const InformationStuPage({Key? key, required this.id, required this.name})
    : super(key: key);

  @override
  State<InformationStuPage> createState() => _InformationStuPage();
}

class _InformationStuPage extends State<InformationStuPage> {
  final TextEditingController _schoolController = TextEditingController();
  String? selectedGrade;
  String? selectedClass;
  List<String> availableClasses = [];
  List<String> classList = [];
  List<String> gradeList = ['1', '2', '3'];
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
            classSet.toList()
              ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> submitSchoolInfo() async {
    final dto = SchoolInfoDto(
      id: widget.id,
      schoolName: _schoolController.text.trim(),
      grade: int.parse(selectedGrade!),
      classNumber: int.parse(selectedClass!),
    );

    try {
      final res = await ApiService.submitSchoolInfo(dto);

      if (res.statusCode == 200 || res.statusCode == 201) {
        final userProvider = Provider.of<UserModel>(context, listen: false);

        userProvider.setUser(
          id: widget.id,
          name: widget.name,
          message:
              userProvider.message.isNotEmpty ? userProvider.message : "안녕하세요!",
          school: _schoolController.text.trim(),
          grade: selectedGrade!,
          class_: selectedClass!,
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('학교 정보를 저장하는 데 실패했어요.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('오류가 발생했어요. 다시 시도해주세요.')));
    }
  }

  bool get isFormValid =>
      _schoolController.text.isNotEmpty &&
      selectedGrade != null &&
      selectedClass != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              Text(
                "${widget.name}님의 학교\n정보를 작성해주세요.",
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _schoolController,
                onChanged: (_) {
                  setState(() {
                    selectedGrade = null;
                    selectedClass = null;
                    availableClasses = [];
                    classList = [];
                  });
                },
                decoration: const InputDecoration(
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
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton2<String>(
                    value: selectedGrade,
                    hint: const Text(
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
                        final fetchedClasses = await fetchClasses();
                        setState(() {
                          classList = availableClasses;
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
                    hint: const Text(
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
                  if (isFormValid) {
                    submitSchoolInfo();
                  } else {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('모든 항목을 선택해주세요.')));
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
      ),
    );
  }
}
