import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({Key? key}) : super(key: key);

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  final ImagePicker picker = ImagePicker();

  XFile? pickedImage1;
  XFile? pickedImage2;
  XFile? pickedImage3;

  void _pickImage(int index, ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        if (index == 1) pickedImage1 = pickedFile;
        if (index == 2) pickedImage2 = pickedFile;
        if (index == 3) pickedImage3 = pickedFile;
      });
    }
  }

  void _showBottomSheet(int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
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
                  _pickImage(index, ImageSource.camera);
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
                  _pickImage(index, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageBox(XFile? file, int index) {
    return GestureDetector(
      onTap: () => _showBottomSheet(index),
      child: Container(
        margin: EdgeInsets.only(
          left: index == 0 ? 0 : 10, // 첫 번째가 아니면 왼쪽 마진
          right: 10, // 모든 아이템에 오른쪽 마진
        ),
        child:
            file == null
                ? DottedBorder(
                  color: const Color(0xffFFAD0A),
                  strokeWidth: 1.6,
                  dashPattern: const [6, 3], // 점선 패턴 (선 길이, 간격)
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(7),
                  child: Container(
                    width: 88,
                    height: 71,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: const Color(0xffFFF9EC),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Color(0xffFFAD0A),
                      size: 30,
                    ),
                  ),
                )
                : Container(
                  width: 88,
                  height: 71,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: const Color(0xffFFF9EC),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Image.file(File(file.path), fit: BoxFit.fill),
                  ),
                ),
      ),
    );
  }

  Widget _buildFirstImageBox(XFile? file, int index, void Function() onTap) {
    final _imageSize = MediaQuery.of(context).size.width / 4;
    if (file == null) {
      // 아직 선택되지 않은 경우: 동그란 아이콘 UI
      return GestureDetector(
        onTap: onTap,
        child: Container(
          constraints: BoxConstraints(
            minHeight: _imageSize,
            minWidth: _imageSize,
          ),
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
              const Icon(Icons.image, size: 30, color: Color(0xFFFFB300)),
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
      );
    } else {
      // 선택된 경우: 일반 이미지 박스처럼 표시
      return _buildImageBox(file, index);
    }
  }

  void _submit() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("작성 완료"),
            content: const Text("사진이 정상적으로 업로드되었습니다."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("확인"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '글 작성',
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

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 43),
            const Text(
              '오늘의 한마디',
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
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintText: '한마디를 작성해주세요.',
                hintStyle: TextStyle(
                  fontFamily: 'pretendard',
                  fontSize: 16,
                  color: Color(0xffAAAAAA),
                ),
                counterText: '최대 20자',
              ),
            ),
            const SizedBox(height: 69),
            const Text(
              '사진 (선택, 최대 3장)',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              '사진을 업로드해주세요.',
              style: TextStyle(
                color: Color(0xffAAAAAA),
                fontSize: 14,
                fontFamily: 'Pretendard',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildFirstImageBox(pickedImage1, 1, () => _showBottomSheet(1)),
                if (pickedImage1 != null) ...[
                  _buildImageBox(pickedImage2, 2),
                  _buildImageBox(pickedImage3, 3),
                ],
              ],
            ),
            Container(
              margin: EdgeInsets.only(
                top: pickedImage1 != null ? 255 : 236, // 이미지 있으면 255, 없으면 236
              ),
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: pickedImage1 != null ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB800),
                  disabledBackgroundColor: const Color(0xffD9D9D9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '작성하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
