import 'package:clothing_brand/apptheme.dart';
import 'package:clothing_brand/cart_screen.dart';
import 'package:clothing_brand/check_out_screen.dart';
import 'package:clothing_brand/home_page.dart';
import 'package:clothing_brand/new_arrival_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return MaterialApp(home:HomePage(),debugShowCheckedModeBanner:false,
   theme: Apptheme.lightTheme,);
  }

}
