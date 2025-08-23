import 'dart:convert';
import 'dart:math';
import 'package:chat_application/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static final AuthService instance = AuthService._internal();
  factory AuthService() => instance;
  final db = FirebaseFirestore.instance;
  AuthService._internal();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
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
  Future<UserCredential?> signInOrCreate(String email) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    const String defaultPassword = '123456';

    try {
      // Try signing in first
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: defaultPassword,
      );
      print('User signed in successfully😂😂');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print(e.code + '😂😂😂');
      if (e.code == 'invalid-credential') {
        // If user doesn't exist, create a new one
        try {
          UserCredential newUserCredential = await auth
              .createUserWithEmailAndPassword(
                email: email,
                password: defaultPassword,
              );
          await initUser(email);
          print('New user created successfully 😂😂😂😂');
          return newUserCredential;
        } on FirebaseAuthException catch (e) {
          print('Failed to create user: ${e.message}');
        }
      } else {
        print('Sign in failed: ${e.message}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }

    return null;
  }

  Future<void> initUser(String email) async {
    var newUser = UserModel(email: email, id: firebaseAuth.currentUser!.uid);
    try {
      await db
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .set(newUser.toJson());
    } catch (e) {
      print(e.toString());
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

  /// ---------- SEND OTP ----------944654
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
    //   // Initialize Firestore user profile
    //   await initUser(email);
    // }

    return userCred;
  }
}
