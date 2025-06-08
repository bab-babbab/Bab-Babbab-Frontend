import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:ui' as ui;

// 점선 테두리를 그리는 CustomPainter
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double dashSpace;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    final path =
        Path()..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              strokeWidth / 2,
              strokeWidth / 2,
              size.width - strokeWidth,
              size.height - strokeWidth,
            ),
            Radius.circular(8),
          ),
        );

    _drawDashedPath(canvas, path, paint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      double distance = 0;
      while (distance < pathMetric.length) {
        final segment = pathMetric.extractPath(distance, distance + dashLength);
        canvas.drawPath(segment, paint);
        distance += dashLength + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// PostItem 위젯 (기본 이미지 + 1개 추가 가능)
class PostItem extends StatefulWidget {
  const PostItem({super.key});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  final int maxImages = 2; // 최대 이미지 개수를 2개로 변경
  bool _hasDefaultImage = true; // 기본 이미지 존재 여부

  // 사용자 정보 변수화
  final String userName = '정수진';
  final String userGrade = '3학년 / 2반';
  final String statusMessage = '오늘 인증!';

  Future<void> _showImageSourceDialog() async {
    if (_selectedImages.length >= maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('최대 ${maxImages}개의 이미지만 선택할 수 있습니다.')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '이미지 선택',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.camera_alt, color: Color(0xFF575757)),
                title: Text('카메라로 촬영'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: Color(0xFF575757)),
                title: Text('앨범에서 선택'),
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

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 80,
      );

      if (pickedFile != null && _selectedImages.length < maxImages) {
        setState(() {
          _selectedImages.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('이미지를 선택하는 중 오류가 발생했습니다.')));
    }
  }

  Widget _buildImageContainer(int index) {
    // 기본 이미지 (첫 번째)
    if (index == 0 && _hasDefaultImage) {
      return Container(
        width: 90,
        height: 75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color(0xFFBDBDBD), // 회색 배경 (기본 이미지)
        ),
        child: Icon(Icons.image, size: 40, color: Colors.white),
      );
    }

    // 실제 선택된 이미지들
    int imageIndex = _hasDefaultImage ? index - 1 : index;
    if (imageIndex >= 0 && imageIndex < _selectedImages.length) {
      return Container(
        width: 90,
        height: 75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color(0xFFBDBDBD), // 회색 배경
          image: DecorationImage(
            image: FileImage(_selectedImages[imageIndex]),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    // 추가 버튼 (노란색 점선 박스)
    int totalImages = (_hasDefaultImage ? 1 : 0) + _selectedImages.length;
    if (totalImages < maxImages) {
      return GestureDetector(
        onTap: _showImageSourceDialog,
        child: Container(
          width: 90,
          height: 75,
          decoration: BoxDecoration(
            color: Color(0xFFFFF9EC),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomPaint(
            painter: DashedBorderPainter(
              color: Color(0xFFFFAD0A),
              strokeWidth: 2,
              dashLength: 5,
              dashSpace: 3,
            ),
            child: Container(
              width: 90,
              height: 75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.add, size: 30, color: Color(0xFFFFAD0A))],
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    // 총 컨테이너 개수 계산: 기본이미지(1) + 선택된이미지들 + 추가버튼(조건부)
    int totalContainers = 1 + _selectedImages.length; // 기본 이미지 + 선택된 이미지들
    int totalImages = (_hasDefaultImage ? 1 : 0) + _selectedImages.length;
    if (totalImages < maxImages) {
      totalContainers += 1; // 추가 버튼
    }

    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 사용자 정보
          Row(
            children: [
              Text(
                '$userName ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              Text(
                userGrade,
                style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
              ),
              Spacer(),
            ],
          ),
          SizedBox(height: 8),

          // 제목
          Text(
            statusMessage,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
          SizedBox(height: 15),

          // 이미지 그리드 (기본이미지 + 추가이미지들 + 추가버튼)
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(
              totalContainers,
              (index) => _buildImageContainer(index),
            ),
          ),
        ],
      ),
    );
  }
}

// PostsPage 위젯 (원래 코드 그대로)
class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "전체 보기",
          style: TextStyle(
            color: Color(0xFF575757),
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        shape: Border(bottom: BorderSide(color: Color(0xFFD7D7D7), width: 1)),
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Color(0xFFD1D2D1), size: 35),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Color(0xFFF7F8F9), // 배경색 설정
        child: Padding(
          padding: EdgeInsets.only(top: 20), // 원하는 간격 추가 (50px 예시)
          child: ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: 4,
            itemBuilder: (context, index) {
              return PostItem();
            },
          ),
        ),
      ),
    );
  }
}
