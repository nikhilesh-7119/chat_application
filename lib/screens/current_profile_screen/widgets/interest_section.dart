import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_application/controllers/user_controller.dart';

class InterestsSection extends StatelessWidget {
  final UserController userController = Get.find<UserController>();
  final RxBool isEditing = false.obs;
  final RxString selectedInterest = ''.obs;

  final List<String> availableInterests = [
    "Python",
    "Machine Learning",
    "Data Science",
    "React",
    "Node.js",
    "MongoDB",
    "AI",
    "Cloud",
    "Cybersecurity",
  ];

  InterestsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardBorderRadius = BorderRadius.circular(screenWidth * 0.03);
    final cardPadding = EdgeInsets.all(screenWidth * 0.04);
    final sectionFontSize = screenWidth * 0.045;

    return Obx(() {
      final interests = userController.currentUser.value.interests ?? [];

      return Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: cardBorderRadius),
        elevation: 2,
        child: Padding(
          padding: cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title + Pencil / Check Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Interests",
                    style: TextStyle(
                      fontSize: sectionFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(isEditing.value ? Icons.check : Icons.edit),
                    onPressed: () {
                      isEditing.toggle();
                    },
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// Normal Mode → Show Chips
              if (!isEditing.value)
                interests.isEmpty
                    ? Text(
                        "No interests added yet",
                        style: TextStyle(fontSize: sectionFontSize * 0.8),
                      )
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: interests.map((interest) {
                          return Chip(
                            label: Text(interest),
                            backgroundColor: Colors.blue.shade100,
                            onDeleted: () {
                              userController.removeInterests(interest);
                            },
                          );
                        }).toList(),
                      ),

              /// Edit Mode → Dropdown + Chips
              if (isEditing.value) ...[
                DropdownButton<String>(
                  hint: const Text("Select Interest"),
                  value: null,
                  isExpanded: true,
                  items: availableInterests
                      .where((item) => !interests.contains(item))
                      .map((interest) {
                        return DropdownMenuItem<String>(
                          value: interest,
                          child: Text(interest),
                        );
                      })
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      final updated = [...interests, value];
                      userController.addInterests(updated);
                    }
                  },
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: interests.map((interest) {
                    return Chip(
                      label: Text(interest),
                      backgroundColor: Colors.blue.shade100,
                      onDeleted: () {
                        userController.removeInterests(interest);
                      },
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}
