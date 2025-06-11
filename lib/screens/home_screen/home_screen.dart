import 'dart:async';

import 'package:field_visit/auth/auth.dart';
import 'package:field_visit/constants/color_constants.dart';
import 'package:field_visit/models/comment_notification.dart';
import 'package:field_visit/screens/field_list_screen/field_list_screen.dart';
import 'package:field_visit/screens/notification_screen/notification_screen.dart';
import 'package:field_visit/screens/taluka_list_screen/taluka_list_screen.dart';
import 'package:field_visit/widgets/loading_popup.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = "";
  String designation = "";
  String totalVisit = "0";
  String currentYearVisit = "0";
  bool isLoading = true;
  Timer? _acceptOrderPollingTimer;
  int notificationcount = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadDashboardVisitCount();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      // final authProvider = Provider.of<Auth>(context, listen: false);
      final result = await Auth.fetchCommentNotificationList();
      setState(() {
        notificationcount = result.length;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching notifications: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_acceptOrderPollingTimer == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startPollingAcceptOrders();
      });
    }
  }

  @override
  void dispose() {
    _acceptOrderPollingTimer?.cancel();
    super.dispose();
  }

  void _startPollingAcceptOrders() {
    _loadDashboardVisitCount();

    fetchNotifications();
    _acceptOrderPollingTimer?.cancel();
    _acceptOrderPollingTimer =
        Timer.periodic(const Duration(seconds: 10), (timer) {
      _loadDashboardVisitCount();
      fetchNotifications();
    });
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? "Guest";
      designation = prefs.getString('userDesignation') ?? "Not Available";
    });
  }

  Future<void> _loadDashboardVisitCount() async {
    final result = await Auth.fetchDashboardVisitCount();
    if (!result.containsKey("error")) {
      setState(() {
        currentYearVisit = result["current_year_visit"] ?? "0";
        totalVisit = result["total_visit"] ?? "0";
        isLoading = false;
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to load dashboard data")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Orange curved background
          Container(
            height: screenHeight * 0.35,
            decoration: const BoxDecoration(
              color: ColorConstants.orange,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Top row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            height: screenHeight * 0.08,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Field Visit App",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: const Duration(milliseconds: 200),
                                    reverseDuration:
                                        const Duration(milliseconds: 200),
                                    child: const NotificationScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.notifications,
                                color: Colors.orange,
                                size: 32,
                              ),
                            ),
                          ),
                          // Badge
                          if (notificationcount > 0)
                            Positioned(
                              right: 4,
                              top: 4,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Text(
                                  "$notificationcount", // Replace this with your dynamic count
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      )
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
                                "अधिकारी : $name",
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

                  const SizedBox(height: 24),

                  // Visit Stats
                  // Row(
                  //   children: [
                  //     _buildStatCardtarget(
                  //       count: currentYearVisit,
                  //       target: "30",
                  //       labelTop: "अचिव्ह / टार्गेट",
                  //       labelBottom:
                  //           "चालू आर्थिक वर्षात \nकेलेल्या क्षेत्रीय भेटी",
                  //       circleColor: Colors.pink,
                  //     ),
                  //     const SizedBox(width: 16),
                  //     _buildStatCard(
                  //       count: totalVisit,
                  //       label: "आतापर्यंत केलेल्या\nक्षेत्रीय भेटी",
                  //       color: ColorConstants.orange,
                  //     ),
                  //   ],
                  // ),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildResponsiveStatCardtarget(
                        count: currentYearVisit,
                        target: "30",
                        labelTop: "अचिव्ह / टार्गेट",
                        labelBottom:
                            "चालू आर्थिक वर्षात \nकेलेल्या क्षेत्रीय भेटी",
                        circleColor: Colors.pink,
                        width: (screenWidth - 44) / 2, // responsive width
                      ),
                      _buildResponsiveStatCard(
                        count: totalVisit,
                        label: "आतापर्यंत केलेल्या\nक्षेत्रीय भेटी",
                        color: ColorConstants.orange,
                        width: (screenWidth - 44) / 2,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Button: Add new visit
                  OutlinedButton(
                    onPressed: () {
                      // Add action
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: const Duration(milliseconds: 200),
                          reverseDuration: const Duration(milliseconds: 200),
                          child: const FieldListScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: ColorConstants.orange),
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.02),
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

                  // Button: View assigned visits
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: const Duration(milliseconds: 200),
                          reverseDuration: const Duration(milliseconds: 200),
                          child: const TalukaListScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.orange,
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.02),
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
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
        margin: const EdgeInsets.only(bottom: 12),
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

  Widget _buildStatCardtarget({
    required String count,
    required String target,
    required String labelTop,
    required String labelBottom,
    required Color circleColor,
  }) {
    return Expanded(
      child: Container(
        // width: 130, // Fixed width as per design ratio
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              labelTop,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: circleColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Text(
                "$count/$target",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: circleColor,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              labelBottom,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.brown,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveStatCard({
    required String count,
    required String label,
    required Color color,
    required double width,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
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
    );
  }

  Widget _buildResponsiveStatCardtarget({
    required String count,
    required String target,
    required String labelTop,
    required String labelBottom,
    required Color circleColor,
    required double width,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            labelTop,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: circleColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Text(
              "$count/$target",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: circleColor,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            labelBottom,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.brown,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> showLoadingDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: LoadingPopup(),
        );
      },
    );
  }
}
