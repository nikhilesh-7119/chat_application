import 'package:flutter/material.dart';

class ProfileStat extends StatelessWidget {
  final String title;
  final String value;
  const ProfileStat({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final statFontSize = MediaQuery.of(context).size.width * 0.05;
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: statFontSize,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: statFontSize * 0.2),
        Text(
          title,
          style: TextStyle(color: Colors.grey, fontSize: statFontSize * 0.75),
        ),
      ],
    );
  }
}
