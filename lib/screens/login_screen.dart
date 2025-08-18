// import 'package:chat_application/services/auth/auth_service.dart';
// import 'package:chat_application/helper/global.dart';
// import 'package:chat_application/screens/home_screen.dart';
// import 'package:chat_application/screens/email_page.dart';
// import 'package:chat_application/widget/text_field_input.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final FocusNode _focusNode = FocusNode();
//   bool _isLoading = false;
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//   }

//   void loginUser() async {
//     setState(() {
//       _isLoading = true;
//     });
//     final email = _emailController.text;
//     final password = _passwordController.text;

//     try {
//       final response = await AuthService().SignIn(email, password);
//       if (response.user != null) {
//         Get.offAll(HomeScreen());
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Login failed! Please try again.')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     mq = MediaQuery.sizeOf(context);
//     return Scaffold(
//       appBar: AppBar(),
//       body: SafeArea(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 32),
//           width: double.infinity,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Flexible(flex: 2, child: Container()),
//               Text(
//                 'Welcome Back!!',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: mq.height * 0.05,
//                 ),
//               ),
//               const SizedBox(height: 64),
//               TextFieldInput(
//                 textEditingController: _emailController,
//                 hintText: 'Enter Your Email',
//                 textInputType: TextInputType.emailAddress,
//               ),
//               const SizedBox(height: 24),
//               TextFieldInput(
//                 textEditingController: _passwordController,
//                 hintText: 'Enter Your Password',
//                 textInputType: TextInputType.text,
//                 isPass: true,
//               ),
//               const SizedBox(height: 24),
//               InkWell(
//                 onTap: loginUser,
//                 child: Container(
//                   width: double.infinity,
//                   alignment: Alignment.center,
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   decoration: const ShapeDecoration(
//                     color: Colors.blue,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(16)),
//                     ),
//                   ),

//                   child: _isLoading == true
//                       ? Center(child: CircularProgressIndicator())
//                       : Text('Log in', style: TextStyle(color: Colors.white)),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Flexible(flex: 2, child: Container()),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(vertical: 8),
//                     child: Text('Dont have an account? '),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Get.to(() => SignupScreen());
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                       child: Text(
//                         'Sign up.',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
