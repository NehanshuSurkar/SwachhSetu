import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

import 'package:swacch_setu/splash_screen.dart';

void main() {
  runApp(const SmartWaterQualityApp());
}

class SmartWaterQualityApp extends StatelessWidget {
  const SmartWaterQualityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swachh Vidarbha',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF00A8E8),
        scaffoldBackgroundColor: const Color(0xFFF5FAFF),
        fontFamily: 'SF Pro Display',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          iconTheme: IconThemeData(color: Color(0xFF003459)),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF00A8E8),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 20,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
