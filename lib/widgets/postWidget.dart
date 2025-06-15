import 'package:flutter/material.dart';

// 게시물 위젯 컴포넌트
class PostWidget extends StatelessWidget {
  final String userName;
  final String userGrade;
  final String statusMessage;
  final bool isTopPost;
  final int imageCount; // 이미지 개수
  final List<String>? imageUrls; // 🔥 실제 이미지 URL 리스트 추가
  final VoidCallback? onDetailTap;

  const PostWidget({
    super.key,
    required this.userName,
    required this.userGrade,
    required this.statusMessage,
    this.isTopPost = false,
    this.imageCount = 0, // 기본값 0개
    this.imageUrls, // 🔥 이미지 URL 리스트 추가
    this.onDetailTap,
  });

  Widget _buildImageWidget(int index) {
    // 🔥 실제 이미지 URL이 있으면 네트워크 이미지 표시, 없으면 더미 이미지
    if (imageUrls != null && index < imageUrls!.length) {
      return Container(
        width: 90,
        height: 75,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrls![index],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // 이미지 로딩 실패시 더미 이미지 표시
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xFFBDBDBD),
                ),
                child: Icon(Icons.image, size: 40, color: Colors.white),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xFFE0E0E0),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    value:
                        loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                    strokeWidth: 2,
                    color: Color(0xFFFFB800),
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else {
      // 더미 이미지 (회색 컨테이너)
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
            isTopPost ? Border.all(color: Color(0xFFFFAD0A), width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SizedBox(
        height: 150,
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
                // 더보기 버튼
                GestureDetector(
                  onTap: onDetailTap,
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
              statusMessage,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 15),

            // 이미지들 (실제 이미지 또는 더미 이미지)
            if (imageCount > 0)
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(
                  imageCount,
                  (index) => _buildImageWidget(index),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
