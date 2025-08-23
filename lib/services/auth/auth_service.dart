import 'dart:convert';
import 'dart:math';
import 'package:chat_application/controllers/friend_conntroller.dart';
import 'package:chat_application/controllers/user_controller.dart';
import 'package:chat_application/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static final AuthService instance = AuthService._internal();
  factory AuthService() => instance;
  AuthService._internal();

  final db = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String? _generatedOtp;
  DateTime? expiryTime;

  /// ---------- FIRESTORE CONFIG FETCH ----------
  Future<Map<String, String?>> _getBrevoConfig() async {
    final doc = await db.collection('config').doc('brevo').get();
    if (doc.exists) {
      final data = doc.data()!;
      return {
        'API_KEY': data['API_KEY'] as String?,
        'SENDER_EMAIL': data['SENDER_EMAIL'] as String?,
      };
    }
    throw Exception("Brevo config not found in Firestore");
  }

  /// ---------- AUTH METHODS ----------
  Future<void> signInOrCreate(String email) async {
    const String defaultPassword = '123456';
    try {
      // Try signing in
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: defaultPassword,
      );
      Get.put(UserController(), permanent: true);
      Get.put(FriendConntroller(), permanent: true);
    } on FirebaseAuthException catch (e) {
      print('ERROR IN AUTH SERVIDES BELOW SIGNIN CALL' + e.toString());
      if (e.code == 'invalid-credential') {
        // Create new user
        await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: defaultPassword,
        );
        await initUser(email);
        Get.put(UserController(), permanent: true);
        Get.put(FriendConntroller(), permanent: true);
      }
      print('❌ Sign in failed: ${e.message}');
    }
    return null;
  }

  Future<void> initUser(String email) async {
    final uid = firebaseAuth.currentUser!.uid;
    final userDoc = db.collection('users').doc(uid);

    final snapshot = await userDoc.get();
    if (!snapshot.exists) {
      var newUser = UserModel(
        email: email,
        id: uid,
        joinedAt: DateTime.now().toString(),
      );
      try {
        await userDoc.set(newUser.toJson());
        print("✅ Firestore user profile created");
      } catch (e) {
        print("❌ Firestore init failed: $e");
      }
    } else {
      print("ℹ️ Firestore profile already exists");
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
    if (Get.isRegistered<FriendConntroller>())
      Get.delete<FriendConntroller>(force: true);

    if (Get.isRegistered<UserController>())
      Get.delete<UserController>(force: true);
  }

  /// ---------- OTP HANDLING ----------
  String generateOtp() {
    final rng = Random();
    _generatedOtp = (rng.nextInt(900000) + 100000).toString();
    expiryTime = DateTime.now().add(const Duration(minutes: 5));
    return _generatedOtp!;
  }

  /// ---------- SEND OTP ----------
  Future<void> sendOtpEmail(String email, String otp) async {
    final config = await _getBrevoConfig();
    final apiKey = config['API_KEY'] ?? '';
    final sender = config['SENDER_EMAIL'] ?? 'no-reply@yourapp.com';

    final url = Uri.parse("https://api.brevo.com/v3/smtp/email");
    final body = jsonEncode({
      "sender": {"name": "StudentConnect", "email": sender},
      "to": [
        {"email": email},
      ],
      "subject": "Your OTP Code",
      "htmlContent":
          "<p>Your OTP is <b>$otp</b>. It is valid for 5 minutes.</p>",
    });

    final response = await http.post(
      url,
      headers: {
        "accept": "application/json",
        "api-key": apiKey,
        "content-type": "application/json",
      },
      body: body,
    );

    if (response.statusCode == 201) {
      print("✅ OTP email sent successfully");
    } else {
      print("❌ Failed to send OTP: ${response.body}");
      throw Exception("OTP email send failed");
    }
  }

  /// ---------- OTP FLOW ----------
  Future<void> sendOtpFlow(String email) async {
    final otp = generateOtp();
    print("Generated OTP: $otp");
    await sendOtpEmail(email, otp);
  }

  bool verifyOtp(String otp) {
    if (_generatedOtp == null || expiryTime == null) return false;
    if (DateTime.now().isAfter(expiryTime!)) return false;
    return otp == _generatedOtp;
  }
}
