import 'package:chat_application/controllers/friend_conntroller.dart';
import 'package:chat_application/models/user_model.dart';
import 'package:chat_application/screens/other_user_profile_screen/other_user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart';

class ProfileCard extends StatelessWidget {
  // final VoidCallback onTap;
  final UserModel userModel;
  const ProfileCard({
    super.key,
    required this.userModel,
    // required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    final FriendConntroller friendConntroller = Get.find<FriendConntroller>();
    final RxBool tapped = false.obs;
    return GestureDetector(
      onTap: () {
        Get.to(OtherUserProfileScreen(otherUserId: userModel.id!));
      },
      child: Container(
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
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(
                    userModel.profileImage ?? 'no Image url',
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userModel.name ?? 'User',
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
                          userModel.year ?? 'No year',
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
                          userModel.location ?? 'India',
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
              userModel.bio ?? 'bio not given',
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),

            const SizedBox(height: 10),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 36,
              child: Obx(
                () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: tapped.value
                      ? null
                      : () async {
                          tapped.value = true;
                          await friendConntroller.addInRequestedList(
                            userModel.id!,
                          );
                        },
                  child: Text(
                    tapped.value ? "Request sent" : "Send Message Request",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}