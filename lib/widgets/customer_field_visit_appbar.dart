import 'package:flutter/material.dart';
import 'package:field_visit/constants/color_constants.dart'; // Ensure this has your ColorConstants.orange

class CustomFieldVisitAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomFieldVisitAppBar({super.key});

  @override
  Size get preferredSize =>
      const Size.fromHeight(150); // Adjust height as needed

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: const BoxDecoration(
        color: ColorConstants.orange,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Image.asset(
            'assets/images/logo.png', // Make sure your logo is placed here
            height: 70,
            width: 70,
          ),
          const SizedBox(width: 12),
          const Text(
            'Field Visit App',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
