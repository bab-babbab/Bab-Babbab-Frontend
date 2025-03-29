import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class ImageBox extends StatelessWidget {
  final bool showPlusButton;

  const ImageBox({super.key, this.showPlusButton = false});

  @override
  Widget build(BuildContext context) {
    return showPlusButton
        ? DottedBorder(
          color: Colors.orange,
          strokeWidth: 1.6,
          dashPattern: [10, 3], // 점선 길이 조정 가능
          borderType: BorderType.RRect,
          radius: Radius.circular(8),
          child: Container(
            padding: EdgeInsets.all(16),
            width: 88,
            height: 66,
            color: Colors.orange.withOpacity(0.1),
            child: Icon(Icons.add, color: Colors.orange),
          ),
        )
        : Container(
          width: 88,
          height: 71,
          margin: EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade300,
          ),
        );
  }
}
