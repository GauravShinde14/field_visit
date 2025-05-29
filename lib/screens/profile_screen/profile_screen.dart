import 'package:field_visit/constants/color_constants.dart';
import 'package:field_visit/screens/Login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "";
  String designation = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? "Guest";
      designation = prefs.getString('userDesignation') ?? "Not Available";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Orange curved background
          Container(
            height: 150,
            decoration: const BoxDecoration(
              color: ColorConstants.orange,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 70,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Field Visit App',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),

                // Profile Box
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(24),
                        topLeft: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          "प्रोफाइल",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey.shade200,
                          child: const Icon(Icons.person,
                              size: 60, color: Colors.grey),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: "अधिकारी : ",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                              style: const TextStyle(fontSize: 16),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text.rich(
                              TextSpan(
                                text: "पदनाम : ",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: designation,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Scrollable Tiles
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200], // A light grey color
                                  borderRadius:
                                      BorderRadius.circular(8), // Radius of 8
                                ),
                                child: ListTile(
                                  leading: const Icon(Icons.settings),
                                  title: const Text("सेटींग"),
                                  onTap: () {
                                    // Navigate to settings
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
                                  leading: const Icon(Icons.logout),
                                  title: const Text("लॉग आउट"),
                                  onTap: () {
                                    // Logout logic here
                                    showLogOutDialog(context);
                                  },
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showLogOutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Are You Sure\nWant to Log Out?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Delete Account Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      // Handle Delete Action
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();

                      preferences.clear();
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              duration: const Duration(milliseconds: 200),
                              reverseDuration:
                                  const Duration(milliseconds: 200),
                              child: const LoginScreen()));
                    },
                    child: const Text(
                      "Log Out",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Not Now Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: ColorConstants.orange),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Not Now",
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
