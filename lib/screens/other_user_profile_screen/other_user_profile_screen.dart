import 'package:chat_application/controllers/friend_conntroller.dart';
import 'package:chat_application/controllers/other_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OtherUserProfileScreen extends StatelessWidget {
  final String otherUserId;
  OtherUserProfileScreen({super.key, required this.otherUserId});

  final FriendConntroller friendConntroller = Get.put(FriendConntroller());

  @override
  Widget build(BuildContext context) {
    final OtherUserController otherUserController = Get.put(
      OtherUserController(otherUid: otherUserId),
    );

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final avatarRadius = width * 0.18;
    final cardBorderRadius = width * 0.04;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: width * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Obx(() {
        if (otherUserController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = otherUserController.otherUser.value;

        return SingleChildScrollView(
          padding: EdgeInsets.all(width * 0.04),
          child: Column(
            children: [
              // Profile Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(cardBorderRadius),
                ),
                child: Padding(
                  padding: EdgeInsets.all(width * 0.05),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: avatarRadius,
                        backgroundImage:
                            (user.profileImage != null &&
                                user.profileImage!.isNotEmpty)
                            ? NetworkImage(user.profileImage!)
                            : null,
                        child:
                            (user.profileImage == null &&
                                (user.name?.isNotEmpty ?? false))
                            ? Text(
                                user.name![0],
                                style: TextStyle(fontSize: avatarRadius * 1.2),
                              )
                            : null,
                      ),
                      SizedBox(height: height * 0.015),
                      Text(
                        user.name ?? "No Name",
                        style: TextStyle(
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.email ?? "No Email",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: width * 0.038,
                        ),
                      ),
                      SizedBox(height: height * 0.012),

                      // University
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.school, size: width * 0.045),
                          SizedBox(width: width * 0.02),
                          Text(
                            user.university ?? "No University",
                            style: TextStyle(
                              fontSize: width * 0.038,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: height * 0.01),

                      // Location
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on, size: width * 0.045),
                          SizedBox(width: width * 0.02),
                          Text(
                            user.location ?? "Unknown",
                            style: TextStyle(fontSize: width * 0.038),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),

                      SizedBox(height: height * 0.01),

                      // Joined Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today, size: width * 0.045),
                          SizedBox(width: width * 0.02),
                          Text(
                            user.joinedAt != null
                                ? "Joined on ${DateFormat("d MMM yyyy").format(DateTime.parse(user.joinedAt!))}"
                                : "Joined on NA",
                            style: TextStyle(fontSize: width * 0.038),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: height * 0.02),

              // Stats Section
              Container(
                height: height * 0.12,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(cardBorderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _statItem(
                      user.friends?.length ?? 0,
                      "Friends",
                      width,
                      Colors.blue,
                    ),
                    _statItem(0, "Posts", width, Colors.green),
                    _statItem(0, "Connections", width, Colors.purple),
                  ],
                ),
              ),

              SizedBox(height: height * 0.02),

              // About Section
              _infoCard("About", user.bio ?? "No about info", width, height),

              SizedBox(height: height * 0.02),

              // Interests Section
              _infoCard(
                "Interests",
                null,
                width,
                height,
                child: Wrap(
                  spacing: width * 0.02,
                  runSpacing: height * 0.01,
                  children: (user.interests ?? [])
                      .map(
                        (interest) => Chip(
                          label: Text(
                            interest,
                            style: TextStyle(fontSize: width * 0.035),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _statItem(int value, String label, double width, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "$value",
          style: TextStyle(
            fontSize: width * 0.05,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: width * 0.035, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _infoCard(
    String title,
    String? content,
    double width,
    double height, {
    Widget? child,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(width * 0.04),
        ),
        child: Padding(
          padding: EdgeInsets.all(width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: height * 0.01),
              if (content != null)
                Text(
                  content,
                  style: TextStyle(
                    fontSize: width * 0.038,
                    color: Colors.black87,
                  ),
                ),
              if (child != null) child,
            ],
          ),
        ),
      ),
    );
  }
}
