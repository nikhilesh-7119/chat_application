import 'package:chat_application/cards/buildConnectionCard.dart';
import 'package:chat_application/controllers/friend_conntroller.dart';
import 'package:chat_application/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget requestedTab(BuildContext context, FriendConntroller friendController) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  final double listPadding = screenWidth * 0.03;
  final double cardSpacing = screenHeight * 0.014;

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
        final friendUid = friendController.requestedList[index];

        return FutureBuilder<DocumentSnapshot>(
          future: friendController.db.collection('users').doc(friendUid).get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: CircularProgressIndicator());
            }
            final user = UserModel.fromJson(
              snapshot.data!.data() as Map<String, dynamic>,
            );
            return buildConnectionCard(
              name: user.name,
              //university: user.university ?? "",
              message: user.bio ?? "",
              tags: user.interests ?? [],
              timeAgo: "",
              avatar: CircleAvatar(
                radius: screenWidth * 0.06,
                // backgroundImage: user.image != null
                //     ? NetworkImage(user.image!)
                //     : null,
                // child: user.image == null
                //     ? Text(user.name!.isNotEmpty ? user.name![0] : "")
                //     : null,
              ),
            );
          },
        );
      },
    );
  });
}
