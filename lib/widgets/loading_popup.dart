import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';

class LoadingPopup extends StatelessWidget {
  const LoadingPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AvatarGlow(
            glowColor: Colors.blue,
            endRadius: 150.0,
            duration: const Duration(milliseconds: 1000),
            repeat: true,
            showTwoGlows: true,
            child: Material(
              elevation: 8.0,
              shape: const CircleBorder(),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 100,
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 150,
                  height: 150,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
