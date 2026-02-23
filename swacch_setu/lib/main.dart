import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

import 'package:swacch_setu/splash_screen.dart';

void main() {
  runApp(const SanitationApp());
}

class SanitationApp extends StatelessWidget {
  const SanitationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swachh Vidarbha',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFF5F9FF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
