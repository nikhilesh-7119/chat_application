import 'package:flutter/material.dart';

class EditableSection extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final bool isEditing;
  final VoidCallback onEditToggle;
  final double cardPadding;
  final double cardBorderRadius;
  final double sectionFontSize;
  final double subSectionFontSize;
  final double iconSize;
  final bool multiline;

  const EditableSection({
    super.key,
    required this.title,
    required this.controller,
    required this.isEditing,
    required this.onEditToggle,
    required this.cardPadding,
    required this.cardBorderRadius,
    required this.sectionFontSize,
    required this.subSectionFontSize,
    required this.iconSize,
    this.multiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: sectionFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: onEditToggle,
                icon: Icon(
                  isEditing ? Icons.check : Icons.edit,
                  size: iconSize,
                  color: Colors.blue,
                ),
                splashRadius: cardPadding * 0.95,
              ),
            ],
          ),
          SizedBox(height: cardPadding * 0.5),
          isEditing
              ? TextFormField(
                  controller: controller,
                  style: TextStyle(fontSize: subSectionFontSize),
                  maxLines: multiline ? null : 2,
                  minLines: 1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(cardBorderRadius),
                    ),
                    isDense: true,
                  ),
                )
              : Text(
                  controller.text,
                  style: TextStyle(fontSize: subSectionFontSize),
                ),
        ],
      ),
    );
  }
}