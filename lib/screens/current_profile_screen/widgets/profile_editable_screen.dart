import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_application/controllers/user_controller.dart';

class ProfileEditableScreen extends StatelessWidget {
  ProfileEditableScreen({super.key});

  final UserController userController = Get.find<UserController>();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final fieldSpacing = height * 0.025;
    final fieldFontSize = width * 0.04;
    final labelFontSize = width * 0.045;
    final buttonPaddingV = height * 0.018;
    final buttonPaddingH = width * 0.18;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(
            fontSize: labelFontSize * 1.1,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          final isLoading = userController.isLoading.value;
          final user = userController.currentUser.value;

          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (user == null) {
            return Center(
              child: Text(
                "User data not found",
                style: TextStyle(fontSize: labelFontSize),
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(width * 0.05),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Name
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                      labelStyle: TextStyle(fontSize: labelFontSize),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(width * 0.025),
                      ),
                    ),
                    style: TextStyle(fontSize: fieldFontSize),
                    validator: (value) => value == null || value.isEmpty
                        ? "Enter your name"
                        : null,
                  ),
                  SizedBox(height: fieldSpacing),

                  /// Email
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(fontSize: labelFontSize),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(width * 0.025),
                      ),
                    ),
                    style: TextStyle(fontSize: fieldFontSize),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value == null || value.isEmpty
                        ? "Enter your email"
                        : null,
                  ),
                  SizedBox(height: fieldSpacing),

                  /// Save button
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await userController.updateName(_nameController.text);
                          await userController.updateEmail(
                            _emailController.text,
                          );
                          await userController.updateYear(_yearController.text);
                          await userController.updateName(_nameController.text);
                          Get.back(); // navigate back after save
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(
                          vertical: buttonPaddingV,
                          horizontal: buttonPaddingH,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(width * 0.025),
                        ),
                      ),
                      child: Text(
                        "Save",
                        style: TextStyle(
                          fontSize: labelFontSize,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}