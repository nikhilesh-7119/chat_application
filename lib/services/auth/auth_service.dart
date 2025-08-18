import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? _generatedOtp;
  DateTime? expiryTime;

  /// ---------- FIRESTORE CONFIG FETCH ----------
  Future<Map<String, String?>> _getBrevoConfig() async {
    final doc = await FirebaseFirestore.instance
        .collection('config')
        .doc('brevo')
        .get();

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
  Future<UserCredential> signUp(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signIn(String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  String? getCurrentUserEmail() {
    return _firebaseAuth.currentUser?.email;
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
