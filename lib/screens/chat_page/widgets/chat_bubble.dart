import 'package:chat_application/config/images.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isComing;
  final String time;
  final String status;
  final String imageUrl;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isComing,
    required this.time,
    required this.status,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.012), // ~10px
      child: Column(
        crossAxisAlignment: isComing
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(screenWidth * 0.025), // ~10px
            constraints: BoxConstraints(
              minWidth: screenWidth * 0.25, // ~100px
              maxWidth: screenWidth * 0.75, // ~1.3 ratio
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: isComing
                  ? BorderRadius.only(
                      topLeft: Radius.circular(screenWidth * 0.04), // ~15px
                      topRight: Radius.circular(screenWidth * 0.04),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(screenWidth * 0.04),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(screenWidth * 0.04),
                      topRight: Radius.circular(screenWidth * 0.04),
                      bottomLeft: Radius.circular(screenWidth * 0.04),
                      bottomRight: Radius.circular(0),
                    ),
            ),
            child: imageUrl.isEmpty
                ? Text(message)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          screenWidth * 0.025,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.contain,
                          placeholder: (contest, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      if (message.isNotEmpty)
                        SizedBox(height: screenHeight * 0.012),
                      if (message.isNotEmpty) Text(message),
                    ],
                  ),
          ),
          SizedBox(height: screenHeight * 0.012),
          Row(
            mainAxisAlignment: isComing
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              isComing
                  ? Text(time, style: Theme.of(context).textTheme.labelMedium)
                  : Row(
                      children: [
                        Text(
                          time,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        SizedBox(width: screenWidth * 0.025), // ~10px
                        SvgPicture.asset(
                          AssetsImage.chatStatusSvg,
                          width: screenWidth * 0.05, // ~20px
                        ),
                      ],
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
