import 'package:chat_application/config/images.dart';
import 'package:chat_application/controllers/contact_controller.dart';
import 'package:chat_application/controllers/user_controller.dart';
import 'package:chat_application/models/user_model.dart';
import 'package:chat_application/screens/chat_page/widgets/chat_screen.dart';
import 'package:chat_application/screens/chat_page/widgets/chat_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    Contactcontroller contactcontroller = Get.put(Contactcontroller());
    UserController profileController = Get.put(UserController());

    // 📱 Screen size from MediaQuery
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Messages",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: RefreshIndicator(
        child: Obx(
          () => ListView(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.03, // 3% of screen width
              vertical: height * 0.01, // 1% of screen height
            ),
            children: contactcontroller.chatRoomList.map((e) {
              UserModel send;
              if (e.receiver!.id == profileController.currentUser.value.id) {
                send = e.sender!;
              } else {
                send = e.receiver!;
              }
              return InkWell(
                onTap: () {
                  Get.to(ChatScreen(userModel: send));
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.008),
                  child: ChatTile(
                    name: send.name ?? 'User Name',
                    imageUrl:
                        send.profileImage ?? AssetsImage.defaultProfileUrl,
                    lastTime: e.lastMessageTimeStamp ?? 'Last Time',
                    lastChat: e.lastMessage ?? 'Last Message',
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        onRefresh: () {
          return contactcontroller.getChatRoomList();
        },
      ),
    );
  }
}
