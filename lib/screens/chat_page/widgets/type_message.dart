import 'package:chat_application/config/images.dart';
import 'package:chat_application/controllers/chat_controller.dart';
import 'package:chat_application/controllers/image_controller.dart';
import 'package:chat_application/models/user_model.dart';
import 'package:chat_application/widget/image_picker_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class TypeMessage extends StatelessWidget {
  final UserModel userModel;
  const TypeMessage({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final TextEditingController messageController = TextEditingController();
    final ChatController chatController = Get.put(ChatController());
    final ImageController imagePickerController = Get.put(ImageController());
    final RxString message = ''.obs;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: height * 0.01,
        horizontal: width * 0.005,
      ),
      margin: EdgeInsets.only(bottom: height * 0.005, top: height * 0.005),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: width * 0.015,
            offset: Offset(0, -height * 0.003),
          ),
        ],
      ),
      child: Row(
        children: [
          // Emoji Button
          IconButton(
            icon: Icon(Icons.emoji_emotions_outlined, size: width * 0.07),
            onPressed: () {
              // TODO: open emoji picker
            },
          ),

          // TextField
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(width * 0.07),
              ),
              child: TextField(
                controller: messageController,
                onChanged: (value) => message.value = value,
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: "Type a message...",
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: width * 0.04),
              ),
            ),
          ),

          SizedBox(width: width * 0.02),

          // Gallery Button (only if no image selected)
          Obx(
            () => chatController.selectedImagePath.value == ''
                ? IconButton(
                    onPressed: () {
                      ImagePickerBottomSheet(
                        context,
                        chatController.selectedImagePath,
                        imagePickerController,
                      );
                    },
                    icon: SvgPicture.asset(
                      AssetsImage.chatGallerySvg,
                      height: height * 0.032,
                    ),
                  )
                : const SizedBox(),
          ),

          SizedBox(width: width * 0.015),

          // Mic / Send Button
          Obx(
            () =>
                message.value.isNotEmpty ||
                    chatController.selectedImagePath.value.isNotEmpty
                ? InkWell(
                    onTap: () {
                      if (messageController.text.isNotEmpty ||
                          chatController.selectedImagePath.value.isNotEmpty) {
                        chatController.sendMessage(
                          userModel.id!,
                          messageController.text,
                          userModel,
                        );
                        messageController.clear();
                        message.value = '';
                      }
                    },
                    child: Container(
                      height: height * 0.055,
                      width: height * 0.055,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: chatController.isLoading.value
                            ? SizedBox(
                                height: height * 0.025,
                                width: height * 0.025,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : SvgPicture.asset(
                                AssetsImage.chatSendSvg,
                                height: height * 0.028,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                      ),
                    ),
                  )
                : Container(
                    height: height * 0.055,
                    width: height * 0.055,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        AssetsImage.chatMicSvg,
                        height: height * 0.028,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
