import 'package:clothing_brand/apptheme.dart';
import 'package:clothing_brand/cart_cubit.dart';
import 'package:clothing_brand/cart_screen.dart';
import 'package:clothing_brand/check_out_screen.dart';
import 'package:clothing_brand/home_page.dart';
import 'package:clothing_brand/new_arrival_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => CartCubit(),
      child: const MaterialApp(home: HomePage()),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return MaterialApp(home:CartScreen(),debugShowCheckedModeBanner:false,
   theme: Apptheme.lightTheme,);
  }

}
