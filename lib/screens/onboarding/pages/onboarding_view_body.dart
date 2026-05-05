import 'package:clothes/screens/auth/pages/sign_up_page.dart';
import 'package:clothes/screens/onboarding/widgets/custom_indicator.dart';
import 'package:clothes/screens/onboarding/widgets/onboarding_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingViewBody extends StatefulWidget {
  const OnboardingViewBody({super.key});

  @override
  State<OnboardingViewBody> createState() => _OnboardingViewBodyState();
}

class _OnboardingViewBodyState extends State<OnboardingViewBody> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'image': 'assets/images/onboarding/onboarding1.png',
      'title': 'Welcome to the world of Drapia',
      'subTitle':
          'Where elegance meets individuality. We’ve designed a shopping experience as unique and beautiful as you are.',
    },
    {
      'image': 'assets/images/onboarding/onboarding2.png',
      'title': 'Express Your True Style',
      'subTitle':
          'Discover a curated collection of the latest global and local trends, handpicked to suit every occasion in your life.',
    },
    {
      'image': 'assets/images/onboarding/onboarding3.png',
      'title': 'Your Dream Wardrobe, Just a Tap Away',
      'subTitle':
          'Shine with every click. Enjoy a seamless shopping experience from home.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          // Skip Button
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              },
              child: Text(
                'Skip',
                style: TextStyle(
                  color: const Color(0xFF6F2C2C),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          // PageView
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _onboardingData.length,
              itemBuilder: (context, index) => OnboardingItem(
                image: _onboardingData[index]['image']!,
                title: _onboardingData[index]['title']!,
                subTitle: _onboardingData[index]['subTitle']!,
              ),
            ),
          ),

          // Bottom Controls
          Padding(
            padding: EdgeInsets.only(bottom: 40.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Indicators
                CustomIndicator(
                  activeIndex: _currentPage,
                  count: _onboardingData.length,
                ),

                // Action Button
                _currentPage == _onboardingData.length - 1
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const SignUpPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6F2C2C),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        child: Text(
                          'Enter Drapia',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF6F2C2C),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
