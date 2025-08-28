import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_application/config/images.dart';
import 'package:chat_application/controllers/chat_controller.dart';
import 'package:chat_application/controllers/user_controller.dart';
import 'package:chat_application/models/chat_model.dart';
import 'package:chat_application/models/user_model.dart';
import 'package:chat_application/screens/chat_page/widgets/chat_bubble.dart';
import 'package:chat_application/screens/chat_page/widgets/type_message.dart';
import 'package:chat_application/screens/other_user_profile_screen/other_user_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatelessWidget {
  final UserModel userModel;
  const ChatScreen({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // screen size
    final width = size.width;
    final height = size.height;

    FirebaseAuth auth = FirebaseAuth.instance;
    ChatController chatController = Get.put(ChatController());
    UserController userController = Get.put(UserController());

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            // 🖼 Profile Image
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                Get.to(OtherUserProfileScreen(otherUserId: userModel.id!));
              },
              child: Container(
                margin: EdgeInsets.only(right: width * 0.03),
                height: height * 0.05,
                width: height * 0.05,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    imageUrl:
                        userModel.profileImage ?? AssetsImage.defaultProfileUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => SizedBox(
                      width: width * 0.04,
                      height: width * 0.04,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error, size: width * 0.05),
                  ),
                ),
              ),
            ),

            // 👤 Name + Status
            Expanded(
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  Get.to(OtherUserProfileScreen(otherUserId: userModel.id!));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userModel.name ?? 'User',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(fontSize: width * 0.045),
                      overflow: TextOverflow.ellipsis,
                    ),
                    StreamBuilder(
                      stream: chatController.getStatus(userModel.id!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text(
                            '. . . .',
                            style: TextStyle(fontSize: width * 0.03),
                          );
                        } else {
                          return Text(
                            snapshot.data?.status ?? 'null',
                            style: TextStyle(
                              fontSize: width * 0.03,
                              color: snapshot.data?.status == 'online'
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.03,
          vertical: height * 0.01,
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  StreamBuilder<List<ChatModel>>(
                    stream: chatController.getMessages(userModel.id!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }
                      if (snapshot.data == null || snapshot.data!.isEmpty) {
                        return Center(child: Text('No Messages'));
                      } else {
                        return ListView.builder(
                          reverse: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            DateTime timeStamp = DateTime.parse(
                              snapshot.data![index].timeStamp!,
                            );
                            String formattedTime = DateFormat(
                              'hh:mm a',
                            ).format(timeStamp);
                            return ChatBubble(
                              message: snapshot.data![index].message!,
                              isComing:
                                  snapshot.data![index].senderId! !=
                                  auth.currentUser!.uid,
                              time: formattedTime,
                              status: 'read',
                              imageUrl: snapshot.data![index].imageUrl ?? '',
                            );
                          },
                        );
                      }
                    },
                  ),

                  /// Image Preview
                  Obx(
                    () => (chatController.selectedImagePath.value != '')
                        ? Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    bottom: height * 0.015,
                                  ),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(
                                        File(
                                          chatController
                                              .selectedImagePath
                                              .value,
                                        ),
                                      ),
                                      fit: BoxFit.contain,
                                    ),
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(
                                      width * 0.04,
                                    ),
                                  ),
                                  height: height * 0.4,
                                ),
                                Positioned(
                                  right: width * 0.02,
                                  top: width * 0.02,
                                  child: IconButton(
                                    onPressed: () {
                                      chatController.selectedImagePath.value =
                                          '';
                                    },
                                    icon: Icon(Icons.close, size: width * 0.06),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox.shrink(),
                  ),
                ],
              ),
            ),

            /// Type Message
            TypeMessage(userModel: userModel),
          ],
        ),
      ),
    );
  }
}
