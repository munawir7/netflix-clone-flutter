import 'package:flutter/material.dart';
import 'package:netflix_clone/core/constants/app_constant.dart';

import 'core/theme/app_theme.dart';
import 'presentation/screens/auth/login_screen.dart';

class NetflixApp extends StatelessWidget {
  const NetflixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const LoginScreen(),
    );
  }
}