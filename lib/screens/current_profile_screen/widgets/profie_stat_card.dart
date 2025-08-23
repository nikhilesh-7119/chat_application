import 'package:flutter/material.dart';

class ProfileStat extends StatelessWidget {
  final String title;
  final String value;
  final Color color; // ✅ new parameter for value color

  const ProfileStat({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // dynamic sizing
    final valueFontSize = screenWidth * 0.06;
    final titleFontSize = screenWidth * 0.035;
    final spacing = screenHeight * 0.005;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: valueFontSize,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: spacing),
        Text(
          title,
          style: TextStyle(fontSize: titleFontSize, color: Colors.black),
        ),
      ],
    );
  }
}
