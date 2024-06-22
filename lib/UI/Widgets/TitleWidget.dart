import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    Key? key,
    required this.title,
    this.fontSize = 34,
  }) : super(key: key);
  final String title;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Color(0xFF222222),
        fontSize: fontSize.sp,
        fontWeight: FontWeight.w700,
        height: 0,
      ),
    );
  }
}
