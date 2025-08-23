import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
<<<<<<< Updated upstream:lib/cards/profile_card.dart
  final String name;
  final String desc;
  final String image;
  final String year;
  final String location;
  const ProfileCard({
    super.key,
    required this.name,
    required this.desc,
    required this.image,
    required this.year,
    required this.location,
  });
=======
  final VoidCallback onTap;
  final UserModel userModel;
  const ProfileCard({super.key, required this.userModel, required this.onTap});
>>>>>>> Stashed changes:lib/screens/discover_screen/widgets/profile_card.dart

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
<<<<<<< Updated upstream:lib/cards/profile_card.dart
              CircleAvatar(radius: 24, backgroundImage: NetworkImage(image)),
=======
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(
                  userModel.profileImage ?? 'no Image url',
                ),
              ),
>>>>>>> Stashed changes:lib/screens/discover_screen/widgets/profile_card.dart
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.school, size: 12, color: Colors.grey),
                      SizedBox(width: 5),
                      Text(
                        year,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_city, size: 10, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        location,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            desc!,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          //],
          const SizedBox(height: 10),

          // Wrap(
          //   spacing: 6,
          //   children: (student["tags"]! as List<String>)
          //       .map(
          //         (tag) => Chip(
          //           label: Text(tag),
          //           backgroundColor: Colors.blue.shade50,
          //           labelStyle: const TextStyle(
          //             color: Colors.black87,
          //             fontSize: 12,
          //           ),
          //         ),
          //       )
          //       .toList(),
          // ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
<<<<<<< Updated upstream:lib/cards/profile_card.dart
              onPressed: () {},
=======
              onPressed: onTap,
>>>>>>> Stashed changes:lib/screens/discover_screen/widgets/profile_card.dart
              child: const Text(
                "Send Friend Request",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
