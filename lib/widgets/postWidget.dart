import 'package:bab_babbab_front/widgets/post_detail_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

// 게시물 위젯 컴포넌트
class PostWidget extends StatefulWidget {
  final String userName;
  final String userGrade;
  final String statusMessage;
  final bool isTopPost;
  final List<File>? initialImages;
  final VoidCallback? onDetailTap;
  final int maxImages;
  final Function(List<File>)? onImagesChanged; // 이미지 변경 콜백 추가

  const PostWidget({
    super.key,
    required this.userName,
    required this.userGrade,
    required this.statusMessage,
    this.isTopPost = false,
    this.initialImages,
    this.onDetailTap,
    this.maxImages = 2,
    this.onImagesChanged, // 콜백 추가
  });

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _hasDefaultImage = true;

  @override
  void initState() {
    super.initState();
    if (widget.initialImages != null) {
      _selectedImages = List.from(widget.initialImages!);
    }
  }

  // 이미지가 변경될 때 부모 위젯에 알림
  void _notifyImagesChanged() {
    if (widget.onImagesChanged != null) {
      widget.onImagesChanged!(_selectedImages);
    }
  }

  Future<void> _showImageSourceDialog() async {
    if (_selectedImages.length >= widget.maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('최대 ${widget.maxImages + 1}개의 이미지만 선택할 수 있습니다.'),
        ),
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

      if (pickedFile != null && _selectedImages.length < widget.maxImages) {
        setState(() {
          _selectedImages.add(File(pickedFile.path));
        });
        _notifyImagesChanged(); // 이미지 변경 알림
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
          color: Color(0xFFBDBDBD),
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
          color: Color(0xFFBDBDBD),
          image: DecorationImage(
            image: FileImage(_selectedImages[imageIndex]),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    // 추가 버튼 (노란색 점선 박스)
    if (_selectedImages.length < widget.maxImages) {
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
    // 총 컨테이너 개수 계산
    int totalContainers = 1 + _selectedImages.length;
    if (_selectedImages.length < widget.maxImages) {
      totalContainers += 1;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
            widget.isTopPost
                ? Border.all(color: Color(0xFFFFAD0A), width: 2)
                : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 사용자 정보
            Row(
              children: [
                Text(
                  '${widget.userName} ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                Text(
                  widget.userGrade,
                  style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                ),
                Spacer(),
                // 더보기 버튼
                GestureDetector(
                  onTap: widget.onDetailTap,
                  child: Row(
                    children: [
                      Text(
                        '더보기',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF999999),
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: Color(0xFF999999),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            // 제목 (한 줄만 표시, 넘치면 ... 처리)
            Text(
              widget.statusMessage,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
              maxLines: 1, // 한 줄만 표시
              overflow: TextOverflow.ellipsis, // 넘치면 ... 표시
            ),
            SizedBox(height: 15),

            // 이미지 그리드
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
      ),
    );
  }
}

// PostsListPage 위젯 (이름 변경으로 중복 방지)
class PostsListPage extends StatefulWidget {
  const PostsListPage({super.key});

  @override
  State<PostsListPage> createState() => _PostsListPageState();
}

class _PostsListPageState extends State<PostsListPage> {
  // 각 게시물별 이미지 데이터를 저장할 Map
  Map<int, List<File>> _postImages = {};

  @override
  void initState() {
    super.initState();
    // 샘플 이미지 데이터 초기화 (테스트용)
    _initializeSampleImages();
  }

  // 샘플 이미지 데이터 초기화 (실제로는 File 객체가 아닌 가상의 데이터)
  void _initializeSampleImages() {
    // 실제 앱에서는 실제 File 객체를 사용하겠지만,
    // 여기서는 테스트를 위해 null로 설정하고 PostDetailWidget에서 처리
    _postImages = {
      0: [], // 첫 번째 게시물: 이미지 없음 (기본 이미지만 표시)
      1: [], // 두 번째 게시물: 이미지 없음
      2: [], // 세 번째 게시물: 이미지 없음
      3: [], // 네 번째 게시물: 이미지 없음
    };
  }

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
          padding: EdgeInsets.only(top: 20), // 원하는 간격 추가
          child: ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: 4,
            itemBuilder: (context, index) {
              return PostWidget(
                userName: _getUserName(index),
                userGrade: _getUserGrade(index),
                statusMessage: _getStatusMessage(index),
                isTopPost: index == 0, // 첫 번째 게시물만 상단 게시물로 설정
                maxImages: 2,
                initialImages: _postImages[index], // 해당 게시물의 이미지 전달
                onDetailTap: () {
                  // PostDetailWidget으로 이동하면서 이미지 데이터 전달
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PostDetailWidget(
                            selectedImages:
                                _postImages[index], // 해당 게시물의 이미지 전달
                            postData: _getPostData(index), // 게시물 데이터도 전달
                          ),
                    ),
                  );
                },
                onImagesChanged: (images) {
                  // PostWidget에서 이미지가 변경될 때 콜백
                  setState(() {
                    _postImages[index] = images;
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // 게시물 데이터를 Map으로 전달 (PostDetailWidget에서 사용할 추가 정보)
  Map<String, dynamic> _getPostData(int index) {
    return {
      'userName': _getUserName(index),
      'userGrade': _getUserGrade(index),
      'statusMessage': _getStatusMessage(index),
      'timestamp': _getTimestamp(index),
    };
  }

  // 더미 데이터 함수들 (실제로는 서버에서 받아올 데이터)
  String _getUserName(int index) {
    final names = ['정수진', '김철수', '박영희', '이민수'];
    return names[index % names.length];
  }

  String _getUserGrade(int index) {
    final grades = ['3학년 / 2반', '2학년 / 1반', '1학년 / 3반', '3학년 / 1반'];
    return grades[index % grades.length];
  }

  String _getStatusMessage(int index) {
    final messages = [
      '봉사활동 완료! 오늘도 뜻깊은 하루였습니다 🌟',
      '점심 맛있게 먹었어요! 친구들과 함께해서 더 맛있었음 🍽️',
      '운동 완료! 10km 달리기 성공했습니다 🏃‍♂️',
      '숙제 끝! 수학 문제가 어려웠지만 해냈어요 📚',
    ];
    return messages[index % messages.length];
  }

  String _getTimestamp(int index) {
    final timestamps = [
      '2024.06.09 오후 3:25',
      '2024.06.09 오전 12:15',
      '2024.06.08 오후 6:30',
      '2024.06.08 오후 9:45',
    ];
    return timestamps[index % timestamps.length];
  }
}
