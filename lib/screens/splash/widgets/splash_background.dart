import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashBackground extends StatelessWidget {
  const SplashBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top Left
        _buildIcon('assets/images/splash/1.png', 80.h, 20.w, 15),
        // Top Middle
        _buildIcon('assets/images/splash/2.png', 20.h, 170.w, -10),
        // Top Right
        _buildIcon('assets/images/splash/3.png', 100.h, 280.w, 25),
        
        // Middle Left
        _buildIcon('assets/images/splash/4.png', 280.h, -10.w, -5),
        // Middle Right
        _buildIcon('assets/images/splash/5.png', 260.h, 290.w, 10),
        
        // Center-ish Right
        _buildIcon('assets/images/splash/1.png', 450.h, 100.w, -20, opacity: 0.1),
        
        // Bottom Left-ish
        _buildIcon('assets/images/splash/3.png', 550.h, 20.w, 5),
        // Bottom Middle-ish
        _buildIcon('assets/images/splash/6.png', 600.h, 140.w, 0),
        // Bottom Right-ish
        _buildIcon('assets/images/splash/2.png', 580.h, 280.w, -15),
        
        // Bottom Left
        _buildIcon('assets/images/splash/4.png', 750.h, 5.w, 10),
        // Bottom Middle
        _buildIcon('assets/images/splash/1.png', 780.h, 150.w, 0, width: 80.w),
        // Bottom Right
        _buildIcon('assets/images/splash/5.png', 760.h, 300.w, -5),
      ],
    );
  }

  Widget _buildIcon(String asset, double top, double left, double rotationDegrees, {double opacity = 0.2, double? width}) {
    return Positioned(
      top: top,
      left: left,
      child: Transform.rotate(
        angle: rotationDegrees * pi / 180,
        child: Opacity(
          opacity: opacity,
          child: Image.asset(
            asset,
            width: width ?? 60.w,
          ),
        ),
      ),
    );
  }
}
