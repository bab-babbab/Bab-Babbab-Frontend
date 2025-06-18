import 'dart:io';
import 'package:bab_babbab_front/screens/information/InfoStuPage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:bab_babbab_front/models/user_model.dart';
import 'package:bab_babbab_front/service/api_service.dart';

class InformationPage extends StatefulWidget {
  final String id;

  const InformationPage({Key? key, required this.id}) : super(key: key);

  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  final picker = ImagePicker();
  XFile? _pickedFile; // 카메라로 촬영한 이미지를 저장할 변수
  TextEditingController nameController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _imageSize = MediaQuery.of(context).size.width / 4;
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              const Text(
                "반가워요! \n정보를 작성해주세요.",
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: '이름을 입력해주세요.',
                  hintStyle: TextStyle(
                    color: Color(0xffCECECE),
                    fontWeight: FontWeight.bold,
                  ),
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
              TextField(
                controller: messageController,
                decoration: InputDecoration(
                  hintText: '상태메세지를 입력해주세요.',
                  hintStyle: TextStyle(
                    color: Color(0xffCECECE),
                    fontWeight: FontWeight.bold,
                  ),
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
              Column(
                children: [
                  if (_pickedFile == null)
                    Container(
                      constraints: BoxConstraints(
                        minHeight: _imageSize,
                        minWidth: _imageSize,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          _showBottomSheet();
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFF3E0),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const Icon(
                              Icons.image,
                              size: 30,
                              color: Color(0xFFFFB300),
                            ),
                            Positioned(
                              bottom: 3,
                              right: 3,
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFB300),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Container(
                      width: _imageSize,
                      height: _imageSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: FileImage(File(_pickedFile!.path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            bottom: 3,
                            right: 3,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFB300),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              SizedBox(height: 210),
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
                    color: Color(0xffFFFFFF),
                  ),
                ),
                onPressed: () {
                  _submitUserInfo();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '이미지 선택',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF575757)),
                title: const Text('카메라로 촬영'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: Color(0xFF575757),
                ),
                title: const Text('앨범에서 선택'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  Future<void> _submitUserInfo() async {
    final String name = nameController.text;
    final String message = messageController.text;

    try {
      final response = await ApiService.submitUserInfo(
        id: widget.id,
        name: name,
        message: message,
        imageFile: _pickedFile != null ? File(_pickedFile!.path) : null,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Provider.of<UserModel>(
          context,
          listen: false,
        ).setUser(id: widget.id, name: name, message: message, school: '');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InformationStuPage(id: widget.id, name: name),
          ),
        );
      } else {
        if (kDebugMode) {
          print('유저 등록 실패: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('에러 : $e');
      }
    }
  }
}
