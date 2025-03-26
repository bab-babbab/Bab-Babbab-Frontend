import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({super.key});

  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  List<String> gradeList = ['1학년', '2학년', '3학년'];
  List<String> classList = ['1반', '2반'];
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
              "반가워요! \n정보를 작성해주세요.",
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 40),
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
                  items: gradeList.map((item) {
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
                  items: classList.map((item) {
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
            SizedBox(height: 30),
            TextField(
               decoration: InputDecoration(
                  hintText: '상태메세지를 입력해주세요.',
                  fillColor: Color(0xffF8F8F8),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(width: 1, color: Color(0xffF8F8F8))
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Color(0xffF8F8F8)),
                  ),
               ),
            ),
            SizedBox(height: 200),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(336, 60),
                backgroundColor: Color(0xffFFAD0A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                '넘어가기',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 20,
                  color: Color(0xffFFFFFF)
                ),
              ),
              onPressed:() => InformationPage(),
            ),
          ],
        ),
      ),
    );
  }
}
