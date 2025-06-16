import 'dart:io';
import 'package:bab_babbab_front/screens/mypage/mypage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class MypageChange extends StatefulWidget {
  const MypageChange({Key? key}) : super(key: key);

  @override
  _MypageChangeState createState() => _MypageChangeState();
}

class _MypageChangeState extends State<MypageChange> {
  final picker = ImagePicker();
  XFile? _pickedFile; // 카메라로 촬영한 이미지를 저장할 변수
  File? _profileImage;
  final TextEditingController _statusController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _imageSize = MediaQuery.of(context).size.width / 4;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '정보 변경',
          style: TextStyle(
            color: Color(0xff575757),
            fontSize: 22,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xffD1D2D1)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 43),
              const Text(
                '상태 메시지 변경',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                maxLength: 20,
                decoration: const InputDecoration(
                  hintText: '한마디를 작성해주세요.',
                  counterText: '최대 20자',
                ),
              ),
              const SizedBox(height: 69),
              const Text(
                '프로필 사진 선택',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                '프로필 사진을 업로드해주세요.',
                style: TextStyle(color: Color(0xffAAAAAA), fontSize: 14),
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  if (_pickedFile == null) // 이미지 파일을 선택하지 않았을 때
                    Container(
                      constraints: BoxConstraints(
                        minHeight: _imageSize,
                        minWidth: _imageSize,
                      ),
                      child: GestureDetector(
                        onTap: _showBottomSheet,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // 큰 원 (배경)
                            Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFF3E0), // 연한 오렌지색 배경
                                shape: BoxShape.circle,
                              ),
                            ),

                            // 가운데 이미지 아이콘
                            const Icon(
                              Icons.image, // 또는 Icons.image_outlined
                              size: 30,
                              color: Color(0xFFFFB300), // 진한 오렌지
                            ),

                            // 오른쪽 아래에 + 버튼
                            Positioned(
                              bottom: 3,
                              right: 3,
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFB300), // 진한 오렌지
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
                  else // 이미지 선택했을 떄
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
                          // 오른쪽 아래에 + 버튼
                          Positioned(
                            bottom: 3,
                            right: 3,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFB300), // 진한 오렌지
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
              SizedBox(height: 236),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    // 저장 로직 처리
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyPage()),
                    );
                    print('상태 메시지 변경');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB800),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '정보 변경',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
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
}
