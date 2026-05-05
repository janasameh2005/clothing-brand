import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomIndicator extends StatelessWidget {
  final int activeIndex;
  final int count;

  const CustomIndicator({
    super.key,
    required this.activeIndex,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        count,
        (index) => Container(
          margin: EdgeInsets.only(right: 8.w),
          width: 12.w,
          height: 12.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: activeIndex == index ? const Color(0xFF6F2C2C) : Colors.transparent,
            border: Border.all(
              color: const Color(0xFF6F2C2C),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
