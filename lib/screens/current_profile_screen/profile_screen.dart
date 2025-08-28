import 'package:chat_application/controllers/friend_conntroller.dart';
import 'package:chat_application/controllers/image_controller.dart';
import 'package:chat_application/screens/current_profile_screen/widgets/edit_academic_info.dart';
import 'package:chat_application/screens/current_profile_screen/widgets/interest_section.dart';
import 'package:chat_application/screens/current_profile_screen/widgets/profile_editable_screen.dart';
import 'package:chat_application/screens/current_profile_screen/widgets/editable_section_profile_screen.dart';
import 'package:chat_application/screens/current_profile_screen/widgets/profie_stat_card.dart';
import 'package:chat_application/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_application/controllers/user_controller.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final UserController userController = Get.put(UserController());
  final FriendConntroller friendConntroller = Get.find<FriendConntroller>();

  final TextEditingController _bioController = TextEditingController();

  // Reactive editing states
  final RxBool _isEditingBio = false.obs;

  final ImageController imageController = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final cardPadding = screenWidth * 0.035;
    final avatarRadius = screenWidth * 0.16;
    final sectionFontSize = screenWidth * 0.045;
    final subSectionFontSize = screenWidth * 0.038;
    final iconSize = screenWidth * 0.054;
    final cardBorderRadius = screenWidth * 0.03;
    final editButtonSize = screenWidth * 0.10;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: sectionFontSize * 1.08,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.settings, size: iconSize),
            onSelected: (value) {
              if (value == 'edit') {
                Get.to(ProfileEditableScreen());
              }
              // you can add more options like logout/settings later
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit Profile')),
            ],
          ),
        ],
      ),

      body: SafeArea(
        child: Obx(() {
          final isLoading = userController.isLoading.value;
          final user = userController.currentUser.value;

          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (user == null) {
            return Center(
              child: Text(
                'User data not found',
                style: TextStyle(fontSize: sectionFontSize),
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Profile Info Container
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(screenWidth * 0.10),
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
                    children: [
                      /// Avatar + Edit
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: avatarRadius,
                            backgroundImage: user.profileImage != null
                                ? NetworkImage(user.profileImage!)
                                : null,
                            child:
                                user.profileImage == null &&
                                    user.name!.isNotEmpty
                                ? Text(
                                    user.name![0],
                                    style: TextStyle(
                                      fontSize: avatarRadius * 0.8,
                                    ),
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: editButtonSize * 0.40,
                              child: IconButton(
                                onPressed: () async {
                                  String pickedImagePath = await imageController
                                      .pickImage(ImageSource.gallery);
                                  // print('IMAGE IS PICKED IN PROFILE SCREEN'+pickedImagePath);
                                  String imageUrl = await imageController
                                      .uploadFileToSupabase(pickedImagePath);
                                  // print('IMAGE PICKED AND PATH IS' + imageUrl);
                                  if (imageUrl != '') {
                                    await userController.updateProfileImage(
                                      imageUrl,
                                    );
                                  }
                                },
                                icon: Icon(
                                  Icons.edit,
                                  size: editButtonSize * 0.52,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.015),

                      /// Name, Email, University, Location
                      Text(
                        user.name ?? '',
                        style: TextStyle(
                          fontSize: sectionFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.email ?? '',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: subSectionFontSize,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.006),
                      Text(
                        user.university ?? 'NA',
                        style: TextStyle(fontSize: subSectionFontSize),
                      ),
                      Text(
                        "${user.location ?? 'NA'} • Joined at ${user.joinedAt ?? 'NA'}",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: subSectionFontSize * 0.88,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.025),

                /// Stats Row
                Container(
                  height: screenHeight * 0.12,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(cardBorderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Obx(
                          () => ProfileStat(
                            title: 'Friends',
                            value: friendConntroller.friendList.length
                                .toString(),
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: ProfileStat(
                          title: 'Posts',
                          value: '5',
                          color: Colors.green,
                        ),
                      ),
                      const Expanded(
                        child: ProfileStat(
                          title: 'Connections',
                          value: '8',
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.025),

                /// About Section
                Obx(
                  () => EditableSection(
                    title: 'About',
                    controller: _bioController,
                    isEditing: _isEditingBio.value,
                    onEditToggle: () async {
                      if (_isEditingBio.value) {
                        await userController.updateBio(_bioController.text);
                      }
                      _isEditingBio.toggle();
                    },
                    cardPadding: cardPadding,
                    cardBorderRadius: cardBorderRadius,
                    sectionFontSize: sectionFontSize,
                    subSectionFontSize: subSectionFontSize,
                    iconSize: iconSize,
                  ),
                ),
                SizedBox(height: screenHeight * 0.025),

                InterestsSection(),
                SizedBox(height: screenHeight * 0.025),

                /// Academic Section
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.035), // instead of 12
                  margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(cardBorderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: screenWidth * 0.005,
                        blurRadius: screenWidth * 0.015,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + Edit Icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Academic Information',
                            style: TextStyle(
                              fontSize: sectionFontSize, // responsive
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Get.to(() => EditAcademicInfo());
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.blue,
                              size: iconSize, // already responsive
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      // University
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'University:',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: subSectionFontSize, // responsive
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              user.university ?? 'NA',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: subSectionFontSize,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.008),

                      // Year & Major
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Year & Major:',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: subSectionFontSize,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              '${user.year ?? 'NA'} year ${user.major ?? ''}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: subSectionFontSize,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.008),

                      // Location
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Location:',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: subSectionFontSize,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              user.location ?? 'NA',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: subSectionFontSize,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.025),

                /// Logout Button
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      AuthService().signOut();
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,

                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.09,
                        vertical: screenHeight * 0.018,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      ),
                      textStyle: TextStyle(fontSize: sectionFontSize * 0.90),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
