import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.width=double.infinity
  }) : super(key: key);
  final String label;
  final double width;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 48.h,
      child: ElevatedButton(
        child: Text(
          label,
          style:
              textStyleNormal(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        onPressed: () async {
          await onPressed();
        },
        style: TextButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
