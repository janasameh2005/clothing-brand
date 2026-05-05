import 'package:clothes/core/di/service_locator.dart';
import 'package:clothes/screens/auth/pages/sign_up_page_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => ServiceLocator.authCubit,
        child: const SignUpPageBody(),
      ),
    );
  }
}
