import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:field_visit/constants/color_constants.dart';
import 'package:field_visit/screens/field_list_screen/field_list_screen.dart';
import 'package:field_visit/screens/home_screen/home_screen.dart';
import 'package:field_visit/screens/profile_screen/profile_screen.dart';
import 'package:field_visit/utils/no_internet_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  String _name = "";
  String _mobileNo = "";
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();

  List<dynamic> get _screens =>
      [const HomeScreen(), FieldListScreen(), ProfileScreen()];

  void _onDestinationSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // _loadUserData();
    _checkConnectivity(); // Check initial connectivity status
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _connectionStatus = result;
      });
    });
  }

  // Future<void> _loadUserData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _name = prefs.getString('name') ?? "Guest";
  //     _mobileNo = prefs.getString('userMobile') ?? "Not Available";
  //   });
  // }

  Future<void> _checkConnectivity() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _connectionStatus == ConnectivityResult.none
          ? const NoInternetScreen()
          : _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onItemSelected: _onDestinationSelected,
      ),
    );
  }
}

// Custom Bottom Navigation Bar Widget
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 70,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(
              icon: Icons.home,
              label: "Home",
              index: 0,
            ),
            // _buildNavItem(
            //   icon: Icons.laptop,
            //   label: "Appointment",
            //   index: 1,
            // ),
            _buildNavItem(
              icon: Icons.add_box,
              label: "Form",
              index: 1,
            ),
            // _buildNavItem(
            //   icon: Icons.business_center_outlined,
            //   label: "Driver",
            //   index: 2,
            // ),
            _buildNavItem(
              icon: Icons.person,
              label: "Profile",
              index: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = index == currentIndex;

    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? ColorConstants.orange : Colors.grey,
            size: 30,
          ),
          // Text(
          //   label,
          //   style: TextStyle(
          //     color: isSelected ? Colors.blue : Colors.black,
          //     fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          //   ),
          // ),
        ],
      ),
    );
  }
}
