import 'package:chat_application/controllers/friend_conntroller.dart';
import 'package:chat_application/controllers/other_user_controller.dart';
import 'package:chat_application/controllers/user_controller.dart';
import 'package:chat_application/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final OtherUserController otherUserController =
    //     Get.find<OtherUserController>();
    RxBool requestSent = false.obs;
    final UserController userController = Get.find<UserController>();
    final FriendConntroller friendConntroller = Get.find<FriendConntroller>();
    final created = post.createdAt ?? ''; // you may format server ts on read
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: author + time
            Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  child: Icon(Icons.person, size: 18),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${post.authorName ?? 'Unknown'}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  created.isNotEmpty ? created : '',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Category chip
            if ((post.category ?? '').isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  post.category!,
                  style: const TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ),
            const SizedBox(height: 8),
            // Title
            Text(
              post.title ?? '',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            // Description
            Text(
              post.description ?? '',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            // Footer: responses count and CTA
            Row(
              children: [
                Icon(Icons.groups, size: 18, color: Colors.grey.shade700),
                const SizedBox(width: 6),
                Text(
                  '${post.responsesCount ?? 0} responses',
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: () {
                    friendConntroller.addInRequestedList(post.authorId!);
                    requestSent.value = true;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Request sent to ${post.authorName}'),
                      ),
                    );
                  },
                  child: Obx(
                    () => Text(
                      requestSent.value ? "Request sent" : "Send Request",
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
