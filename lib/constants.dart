import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Color backgroundColor = Color.fromRGBO(249, 249, 249, 1.0);
Color darkbackgroundColor = Color.fromRGBO(33, 33, 33, 1);
TextStyle textStyleNormal(
    {Color color = Colors.black,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400}) {
  return TextStyle(
      color: color,
      overflow: TextOverflow.ellipsis,
      fontFamily: 'Metropolis',
      fontWeight: fontWeight,
      fontSize: fontSize.sp);
}

Color unselectedColor = Color(0xFF9B9B9B);
