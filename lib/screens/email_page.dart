import 'package:chat_application/screens/otp_screen.dart';
import 'package:chat_application/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<EmailPage> {
  final authService = AuthService();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEAF0FF), // light blue top
              Color(0xFFDDE6FF), // little darker bottom
            ],
          ),
        ),
        child: Center(
          child: Container(
            width: screenWidth * 0.85,
            padding: EdgeInsets.all(screenWidth * 0.05),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: screenWidth * 0.02,
                  spreadRadius: screenWidth * 0.005,
                  offset: Offset(0, screenHeight * 0.005),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "StudyConnect",
                  style: TextStyle(
                    fontSize: screenWidth * 0.06, // responsive text
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  "Connect with fellow students who share your interests",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: screenHeight * 0.025),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.015,
                      horizontal: screenWidth * 0.025,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.06,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      ),
                    ),
                    onPressed: () async {
                      await authService.sendOtpFlow(_emailController.text);
                      Get.offAll(OtpScreen(email: _emailController.text));
                    },
                    child: Text(
                      "Send Verification Code",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
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
