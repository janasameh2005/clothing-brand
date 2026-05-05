<<<<<<< HEAD
import 'package:clothes/screens/splash/pages/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Drapia',
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFFFEF9E1),
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFEF9E1)),
            useMaterial3: true,
          ),
          home: const SplashView(),
        );
      },
    );
  }
=======
import 'package:clothing_brand/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return MaterialApp(home:HomePage(),debugShowCheckedModeBanner:false,);
  }

>>>>>>> e017c960c780cd06065218d0b130d7608d792847
}
