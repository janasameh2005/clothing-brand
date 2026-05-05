import 'package:clothes/screens/splash/widgets/splash_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashViewBody extends StatelessWidget {
  const SplashViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background decorative icons
        const SplashBackground(),

        // Main Logo in the center
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/splash/Drapia.png',
                width: 200.w,
              ),
              SizedBox(width: 10.w),
              Image.asset(
                'assets/images/splash/3.png',
                height: 100.h,
                width: 80.w,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
