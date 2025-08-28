import 'package:chat_application/services/auth/auth_gateway.dart';
import 'package:chat_application/screens/email_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Supabase.initialize(
    url: 'https://vnacqsborwypthofarkq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZuYWNxc2Jvcnd5cHRob2ZhcmtxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU4OTM4MDQsImV4cCI6MjA3MTQ2OTgwNH0.ouKHzwBbxEqq1-jULLpSp-kB-XTSlttUgLvS7Gv7728',
  );
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
      getPages: [GetPage(name: '/email_page', page: () => EmailPage())],
    );
  }
}
