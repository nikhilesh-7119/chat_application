import 'package:chat_application/cards/editable_section_profile_screen.dart';
import 'package:chat_application/cards/profie_stat_card.dart';
import 'package:chat_application/controllers/friend_conntroller.dart';
import 'package:chat_application/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_application/controllers/user_controller.dart';
import 'package:chat_application/models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  final String uid; // Pass user id if needed

  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserController userController = Get.put(UserController());
  final FriendConntroller friendConntroller = Get.put(FriendConntroller());

  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _interestsController = TextEditingController();
  final TextEditingController _academicInfoController = TextEditingController();

  bool _isEditingBio = false;
  bool _isEditingInterests = false;
  bool _isEditingAcademic = false;

  UserModel? _lastUser; // to detect changes and avoid repeated updates

  @override
  void initState() {
    super.initState();
    userController.getUserDetails(); // Load current user details on init
  }

  @override
  void dispose() {
    _bioController.dispose();
    _interestsController.dispose();
    _academicInfoController.dispose();
    super.dispose();
  }

  void _populateFields(UserModel user) {
    // Populate only if data changed to avoid text reset on rebuild
    if (_lastUser != user) {
      _bioController.text = user.bio ?? '';
      _interestsController.text = (user.interests ?? []).join(', ');
      _academicInfoController.text =
          "University: user.university ?? ''}\nYear & Major: user.major ?? ''\nLocation: user.location ?? ''";
      _lastUser = user;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final cardPadding = screenWidth * 0.035;
    final avatarRadius = screenWidth * 0.14;
    final sectionFontSize = screenWidth * 0.045;
    final subSectionFontSize = screenWidth * 0.038;
    final iconSize = screenWidth * 0.054;
    final cardBorderRadius = screenWidth * 0.04;
    final editButtonSize = screenWidth * 0.09;

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
          IconButton(
            onPressed: () {
              // Navigate to settings
            },
            icon: Icon(Icons.settings, size: iconSize),
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

          _populateFields(user);

          return SingleChildScrollView(
            padding: EdgeInsets.all(cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: avatarRadius,
                        backgroundImage: user.profileImage != null
                            ? NetworkImage(user.profileImage!)
                            : null,
                        child:
                            user.profileImage == null && user.name!.isNotEmpty
                            ? Text(
                                user.name![0],
                                style: TextStyle(fontSize: avatarRadius * 0.8),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: editButtonSize * 0.38,
                          child: Icon(
                            Icons.edit,
                            size: editButtonSize * 0.52,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.012),
                Text(
                  user.name!,
                  style: TextStyle(
                    fontSize: sectionFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user.email!,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: subSectionFontSize,
                  ),
                ),
                SizedBox(height: screenHeight * 0.004),
                // Text(user.university ?? '', style: TextStyle(fontSize: subSectionFontSize)),
                // Text(
                //   "${user.location ?? ''} • Joined ${user.joinedAt ?? ''}",
                //   style:
                //       TextStyle(color: Colors.grey, fontSize: subSectionFontSize * 0.88),
                // ),
                SizedBox(height: screenHeight * 0.025),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(
                      () => ProfileStat(
                        title: 'Friends',
                        value: friendConntroller.friendList.length.toString(),
                      ),
                    ),
                    const ProfileStat(title: 'Posts', value: '5'),
                    const ProfileStat(title: 'Connections', value: '8'),
                  ],
                ),
                SizedBox(height: screenHeight * 0.025),

                EditableSection(
                  title: 'About',
                  controller: _bioController,
                  isEditing: _isEditingBio,
                  onEditToggle: () async {
                    if (_isEditingBio) {
                      await userController.updateBio(_bioController.text);
                    }
                    setState(() {
                      _isEditingBio = !_isEditingBio;
                    });
                  },
                  cardPadding: cardPadding,
                  cardBorderRadius: cardBorderRadius,
                  sectionFontSize: sectionFontSize,
                  subSectionFontSize: subSectionFontSize,
                  iconSize: iconSize,
                ),
                SizedBox(height: screenHeight * 0.025),

                EditableSection(
                  title: 'Interests',
                  controller: _interestsController,
                  isEditing: _isEditingInterests,
                  onEditToggle: () {
                    setState(() {
                      _isEditingInterests = !_isEditingInterests;
                    });
                  },
                  cardPadding: cardPadding,
                  cardBorderRadius: cardBorderRadius,
                  sectionFontSize: sectionFontSize,
                  subSectionFontSize: subSectionFontSize,
                  iconSize: iconSize,
                ),
                SizedBox(height: screenHeight * 0.025),

                EditableSection(
                  title: 'Academic Information',
                  controller: _academicInfoController,
                  isEditing: _isEditingAcademic,
                  onEditToggle: () {
                    setState(() {
                      _isEditingAcademic = !_isEditingAcademic;
                    });
                  },
                  cardPadding: cardPadding,
                  cardBorderRadius: cardBorderRadius,
                  sectionFontSize: sectionFontSize,
                  subSectionFontSize: subSectionFontSize,
                  iconSize: iconSize,
                  multiline: true,
                ),
                SizedBox(height: screenHeight * 0.025),

                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      AuthService().signOut();
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
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
