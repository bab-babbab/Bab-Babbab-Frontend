import 'package:bab_babbab_front/screens/home/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:dropdown_button2/dropdown_button2.dart';

class InformationStuPage extends StatefulWidget {
  const InformationStuPage({Key? key}) : super(key: key);

  @override
  _InformationStuPageState createState() => _InformationStuPageState();
}

class _InformationStuPageState extends State<InformationStuPage> {
  List<String> gradeList = ['1학년', '2학년', '3학년'];
  List<String> classList = ['1반', '2반', '3반', '4반', '5반', '6반'];
  String? dropdownValue = '1학년';
  String? classdropdown = '1반';

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
              decoration: InputDecoration(
                hintText: '학교를 입력해주세요.',
                fillColor: Color(0xffF8F8F8),
                filled: true,
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
              children: [
                DropdownButton2(
                  value: dropdownValue,
                  underline: const SizedBox(),
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
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
                    width: 134,
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
                SizedBox(width: 15),
                DropdownButton2(
                  value: classdropdown,
                  underline: const SizedBox(),
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      classdropdown = newValue!;
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
                    width: 134,
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
            SizedBox(height: 340),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(336, 60),
                backgroundColor: Color(0xffFFAD0A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                '시작하기',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 20,
                  color: Color(0xffFFFFFF),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
