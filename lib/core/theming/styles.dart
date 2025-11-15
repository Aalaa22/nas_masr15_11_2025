import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nas_masr_app/core/theming/colors.dart';
import 'package:nas_masr_app/main.dart';

class TextStyles {
  static TextStyle font24primarycolor700weight = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    color:ColorManager.primary_font_color,
    fontFamily: 'Tajawal',
  );

  static TextStyle font16primarycolor500weight = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color:ColorManager.primary_font_color,
    fontFamily: 'Tajawal',
  );

  static TextStyle font16secondrycolor500weight = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color:ColorManager.secondaryColor,
    fontFamily: 'Tajawal',
  );


}
