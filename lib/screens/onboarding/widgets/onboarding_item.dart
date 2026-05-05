// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingItem extends StatelessWidget {
  final String image;
  final String title;
  final String subTitle;

  const OnboardingItem({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(40.r),
          child: Image.asset(
            image,
            height: 390.h,
            width: double.infinity,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 10.h),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1.2,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            subTitle,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black.withOpacity(0.7),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
