import 'package:field_visit/auth/auth.dart';
import 'package:field_visit/constants/color_constants.dart';
import 'package:field_visit/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 80),

                // Logo
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 250,
                  ),
                ),
                const SizedBox(height: 30),

                // Mobile Number Field
                TextFormField(
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    labelText: 'मोबाईल क्रमांक टाका',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 2),
                    ),
                    counterText: '',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  ),
                  onChanged: (value) {
                    if (value.length == 10) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'कृपया मोबाईल क्रमांक टाका';
                    } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return 'मोबाईल क्रमांक 10 अंकांचा असावा';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Password Field
                TextFormField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'पासवर्ड टाका',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 2),
                    ),
                    prefixIcon: const Icon(Icons.lock, color: Colors.orange),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.orange,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'कृपया पासवर्ड टाका';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        );

                        final responseMessage = await Auth.login(
                          mobileController.text.trim(),
                          passwordController.text.trim(),
                        );

                        Navigator.of(context).pop(); // close the loading dialog

                        if (responseMessage == "Successfully logged In.") {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          mobileController.clear();
                          passwordController.clear();
                          prefs.setBool("isLoggedIn", true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('यशस्वी लॉगिन: $responseMessage')),
                          );
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DashboardScreen()),
                            (route) =>
                                false, // This removes all previous routes
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(responseMessage)),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'लॉग इन',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Forgot Password
                TextButton(
                  onPressed: () {
                    // Navigate to Forgot Password screen
                  },
                  child: const Text(
                    'पासवर्ड बदलवा',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
