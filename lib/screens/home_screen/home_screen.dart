import 'package:field_visit/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          // Orange header background with curved bottom
          Container(
            height: 350,
            decoration: const BoxDecoration(
              color: ColorConstants.orange,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),

          // Foreground content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
              child: Column(
                children: [
                  // Top row with logo and notification
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            'assets/images/logo.png', // Replace with your logo
                            height: 70,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Field Visit App",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.notifications,
                        color: Colors.white,
                        size: 35,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Officer Info Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 28,
                          backgroundImage: AssetImage('assets/images/logo.png'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "अधिकारी :$name",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "पदनाम: ",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Text(
                                      designation,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Visit Stats Cards
                  Row(
                    children: [
                      _buildStatCard(
                        count: "05",
                        label: "चालू आर्थिक वर्ष\nकेलेल्या क्षेत्रीय भेटी",
                        color: Colors.pink[100]!,
                      ),
                      const SizedBox(width: 16),
                      _buildStatCard(
                        count: "35",
                        label: "आतापर्यंत केलेल्या\nक्षेत्रीय भेटी",
                        color: ColorConstants.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Button 1
                  OutlinedButton(
                    onPressed: () {
                      // Add action
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: ColorConstants.orange),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "नवीन क्षेत्रीय भेटीचा तपशील जोडा",
                        style: TextStyle(
                          color: ColorConstants.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Button 2
                  ElevatedButton(
                    onPressed: () {
                      // Add action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.orange,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "दिलेल्या क्षेत्रीय भेटीचा तपशील पाहा",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String count,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Text(
                count,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
