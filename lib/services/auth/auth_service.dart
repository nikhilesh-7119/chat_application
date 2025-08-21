import 'dart:convert';
import 'dart:math';
import 'package:chat_application/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  Future<UserCredential?> signInOrCreate(String email) async {
    const String defaultPassword = '123456';
    try {
      // Try signing in
      return await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: defaultPassword,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Create new user
        return await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: defaultPassword,
        );
        await initUser(email);
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
      var newUser = UserModel(email: email, id: uid);
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

  /// ---------- OTP VERIFY + LOGIN ----------
  Future<UserCredential?> verifyOtpAndLogin(String email, String otp) async {
    // Check OTP validity
    if (!verifyOtp(otp)) {
      print("❌ Invalid or expired OTP");
      return null;
    }

    print("✅ OTP verified successfully");

    // Sign in or create new user
    UserCredential? userCred = await signInOrCreate(email);

    // if (userCred != null) {
    //  // Initialize Firestore user profile
    // await initUser(email);
    //  }

    // }

    return userCred;
  }
}
