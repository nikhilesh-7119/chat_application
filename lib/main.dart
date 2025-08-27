import 'package:chat_application/services/auth/auth_gateway.dart';
import 'package:chat_application/screens/email_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        textTheme: TextTheme(titleLarge: TextStyle(color: Colors.white)),
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        textTheme: TextTheme(titleLarge: TextStyle(color: Colors.white)),
      ),
      themeMode: ThemeMode.light,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,

      home: AuthGateway(),
      getPages: [
        // GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/email_page', page: () => EmailPage()),
      ],
    );
  }
}
