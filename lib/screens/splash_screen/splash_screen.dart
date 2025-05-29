import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:field_visit/screens/Login_screen/login_screen.dart';
import 'package:field_visit/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    login();
  }

  void login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool? isLoggedIn = prefs.getBool("isLoggedIn");
    print("---------------------isLoggedIn$isLoggedIn");
    // bool? isLoggedIn = false;

    if (isLoggedIn == true) {
      Timer(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const DashboardScreen(),
            ));
      });
    } else {
      Timer(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AvatarGlow(
              glowColor: Colors.blue, // Adjust glow color
              endRadius: 150.0, // Glow radius
              duration:
                  const Duration(milliseconds: 1000), // Glow animation speed
              repeat: true, // Keeps pulsing
              showTwoGlows: true, // Double layer glow
              child: Material(
                elevation: 8.0,
                shape: const CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 100, // Adjust image size
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Field Visit App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'आपले स्वागत आहे!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
