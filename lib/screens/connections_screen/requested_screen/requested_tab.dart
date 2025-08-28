import 'package:chat_application/screens/connections_screen/friend_screen/widgets/buildConnectionCard.dart';
import 'package:chat_application/controllers/friend_conntroller.dart';
import 'package:chat_application/models/user_model.dart';
import 'package:chat_application/screens/connections_screen/requested_screen/widgets/requested_card.dart';
import 'package:chat_application/screens/connections_screen/requests_screen/widget/requests_card.dart';
import 'package:chat_application/screens/other_user_profile_screen/other_user_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget requestedTab(BuildContext context, FriendConntroller friendController) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  final double listPadding = screenWidth * 0.03;
  final double cardSpacing = screenHeight * 0.014;
  friendController.initializeAllList();

  return Obx(() {
    if (friendController.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }
    if (friendController.requestedList.isEmpty) {
      return Center(
        child: Text(
          "No friends yet.",
          style: TextStyle(fontSize: screenWidth * 0.045),
        ),
      );
    }
    return ListView.separated(
      padding: EdgeInsets.all(listPadding),
      itemCount: friendController.requestedList.length,
      separatorBuilder: (_, __) => SizedBox(height: cardSpacing),
      itemBuilder: (context, index) {
        final requestedUid = friendController.requestedList[index];

        return FutureBuilder<DocumentSnapshot>(
          future: friendController.db
              .collection('users')
              .doc(requestedUid)
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: CircularProgressIndicator());
            }
            final user = UserModel.fromJson(
              snapshot.data!.data() as Map<String, dynamic>,
            );
            return GestureDetector(
              onTap: () {
                Get.to(OtherUserProfileScreen(otherUserId: user.id!));
              },
              child: requested_card(
                name: user.name,
                university: user.university ?? "",
                skills: user.interests ?? [],
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