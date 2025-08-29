import 'package:chat_application/controllers/post_controllers.dart';
import 'package:chat_application/screens/post_screen/widgets/post_card.dart';
import 'package:chat_application/screens/post_screen/widgets/upload_post_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_application/models/post_model.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final PostController controller = Get.put(PostController());
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    // Attach infinite scroll for timestamp feed
    _scrollCtrl.addListener(() async {
      if (_scrollCtrl.position.pixels >=
          _scrollCtrl.position.maxScrollExtent - 200) {
        // Load next page by timestamp
        await controller.getPostsByTimestamp();
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    // Make the entire screen scrollable
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: mediaQuery.size.height),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // Create New Post
                  UploadPostContainer(
                    onSubmitted:
                        (
                          title,
                          category,
                          description,
                          authorId,
                          authName,
                        ) async {
                          await controller.uploadPost(
                            authorName:
                                FirebaseAuth
                                    .instance
                                    .currentUser!
                                    .displayName ??
                                'Unknown',
                            title: title,
                            category: category,
                            description: description,
                            authorId: authorId,
                          ); // [3]
                          // Refresh the timestamp feed to bring new post to top
                          await controller.getPostsByTimestamp(reset: true);
                        },
                  ), // [3]

                  const SizedBox(height: 8),

                  // Recent posts header row with category filter button (optional)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 6,
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Recent Posts',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.filter_list),
                          onPressed: () async {
                            final selected = await _pickCategory(context);
                            if (selected == null || selected.isEmpty) {
                              await controller.getPostsByTimestamp(reset: true);
                            } else {
                              await controller.getPostsByCategory(
                                category: selected,
                                reset: true,
                              ); // [3]
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  // The scrolling list area
                  Expanded(
                    child: Obx(() {
                      final bool showingCategory =
                          controller.getPostByCategory.isNotEmpty &&
                          (controller.isLoadingCategory.value ||
                              controller.getPostByTimestamp.isEmpty);

                      final RxBool isLoading = showingCategory
                          ? controller.isLoadingCategory
                          : controller.isLoadingTimestamp;

                      final List<PostModel> items = showingCategory
                          ? controller.getPostByCategory
                          : controller.getPostByTimestamp;

                      return RefreshIndicator(
                        onRefresh: () async {
                          if (showingCategory) {
                            await controller.getPostsByCategory(
                              category: (controller.getPostByCategory.isNotEmpty
                                  ? controller
                                            .getPostByCategory
                                            .first
                                            .category ??
                                        ''
                                  : ''),
                              reset: true,
                            ); // [3][18]
                          } else {
                            await controller.getPostsByTimestamp(
                              reset: true,
                            ); // [17][18]
                          }
                        },
                        child: CustomScrollView(
                          controller: _scrollCtrl,
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            SliverList(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final post = items[index];
                                return PostCard(post: post);
                              }, childCount: items.length),
                            ),
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                ),
                                child: Center(
                                  child: isLoading.value
                                      ? const CircularProgressIndicator()
                                      : const SizedBox.shrink(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> _pickCategory(BuildContext context) async {
    return await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) {
        final cats = const [
          'Data Science',
          'Mobile Development',
          'Web Development',
          'AI',
          'UI/UX',
        ];
        return ListView.separated(
          shrinkWrap: true,
          itemCount: cats.length + 1,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (ctx, i) {
            if (i == 0) {
              return ListTile(
                leading: const Icon(Icons.clear),
                title: const Text('All Categories'),
                onTap: () => Navigator.pop(ctx, ''),
              );
            }
            final cat = cats[i - 1];
            return ListTile(
              leading: const Icon(Icons.category),
              title: Text(cat),
              onTap: () => Navigator.pop(ctx, cat),
            );
          },
        );
      },
    );
  }
}
