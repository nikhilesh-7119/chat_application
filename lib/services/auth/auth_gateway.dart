import 'package:chat_application/controllers/friend_conntroller.dart';
import 'package:chat_application/screens/email_page.dart';
import 'package:chat_application/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/user_controller.dart';

class AuthGateway extends StatelessWidget {
  const AuthGateway({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // If user is logged in
          if (snapshot.hasData && snapshot.data != null) {
            final uid = snapshot.data!.uid;
            Get.put(UserController(), permanent: true);
            Get.put(FriendConntroller(), permanent: true);
            return HomeScreen();
          }

          // If user is not logged in
          return const EmailPage();
        },
      ),
    );
  }
}
