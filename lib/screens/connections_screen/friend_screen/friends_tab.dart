import 'package:chat_application/screens/connections_screen/friend_screen/widgets/buildConnectionCard.dart';
import 'package:chat_application/controllers/friend_conntroller.dart';
import 'package:chat_application/models/user_model.dart';
import 'package:chat_application/screens/other_user_profile_screen/other_user_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget friendsTab(BuildContext context, FriendConntroller friendController) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  final double listPadding = screenWidth * 0.03;
  final double cardSpacing = screenHeight * 0.014;

  return Obx(() {
    if (friendController.isLoading.value) {
      // show loading indicator when data is being updated
      return const Center(child: CircularProgressIndicator());
    }
    if (friendController.friendList.isEmpty) {
      return Center(
        child: Text(
          "No friends yet.",
          style: TextStyle(fontSize: screenWidth * 0.045),
        ),
      );
    }
    // You need to fetch user details (e.g. from Firestore) for each uid here!
    return ListView.separated(
      padding: EdgeInsets.all(listPadding),
      itemCount: friendController.friendList.length,
      separatorBuilder: (_, __) => SizedBox(height: cardSpacing),
      itemBuilder: (context, index) {
        final friendUid = friendController.friendList[index];

        return FutureBuilder<DocumentSnapshot>(
          future: friendController.db.collection('users').doc(friendUid).get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final user = UserModel.fromJson(
              snapshot.data!.data() as Map<String, dynamic>,
            );
            return GestureDetector(
              onTap: () {
                Get.to(OtherUserProfileScreen(otherUserId: user.id!));
              },
              child: buildConnectionCard(
                name: user.name,
                university: user.university ?? "",
                message: user.bio ?? "",
                tags: user.interests ?? [],
                timeAgo: "",
                avatar: CircleAvatar(
                  radius: screenWidth * 0.06,
                  backgroundImage: user.profileImage != null
                      ? NetworkImage(user.profileImage!)
                      : null,
                  child: user.profileImage == null
                      ? Text(user.name!.isNotEmpty ? user.name![0] : "")
                      : null,
                ),
              ),
            );
          },
        );
      },
    );
  });
}