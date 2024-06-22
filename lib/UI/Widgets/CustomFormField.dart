import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants.dart';

class CustomFormField extends StatelessWidget {
  final Function validation;
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType textInputType;
  final Icon icon;
  final double hpadding;
  final double wpadding;
  final int minLines;
  final int maxLines;
  final bool autofocus;
  final bool readOnly;
  const CustomFormField(
      {Key? key,
      required this.validation,
      required this.label,
      required this.controller,
      this.isPassword = false,
      this.readOnly=false,
      this.maxLines=1,
      this.autofocus=true,
      this.textInputType = TextInputType.text,
      this.hpadding = 45,
      this.wpadding = 20,
      this.minLines=1,
      this.icon = const Icon(
        Icons.abc,
        color: Colors.blue,
        size: 35,
      )})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          elevation: 0.50,
          borderRadius: BorderRadius.circular(4.0.r),
          shadowColor: Colors.black,
          child: TextFormField(
            minLines: minLines,
            maxLines: maxLines,
            readOnly: readOnly,
            validator: (v) => validation(v),
            controller: controller,
            obscureText: isPassword,
            autofocus: autofocus,
            style: textStyleNormal(),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,

              // icon: icon,
              label: Text(
                label,
                style: const TextStyle(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 2.0.w,
                ),
                borderRadius: BorderRadius.circular(4.0.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 2.0.w,
                ),
                borderRadius: BorderRadius.circular(4.0.r),
              ),
            ),
            keyboardType: textInputType,
          ),
        ),
        SizedBox(
          height: 8.h,
        )
      ],
    );
  }
}
