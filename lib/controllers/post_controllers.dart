import 'dart:async';
import 'package:chat_application/models/post_model.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

// Uses the provided PostModel exactly as-is
class PostController extends GetxController {
  final _postsRef = FirebaseFirestore.instance.collection('posts');

  // Loading flags
  final RxBool isLoadingTimestamp = false.obs;
  final RxBool isLoadingCategory = false.obs;

  // Reactive lists
  final RxList<PostModel> getPostByTimestamp = <PostModel>[].obs;
  final RxList<PostModel> getPostByCategory = <PostModel>[].obs;

  // Pagination cursors
  DocumentSnapshot<Map<String, dynamic>>? _lastTimestampDoc;
  DocumentSnapshot<Map<String, dynamic>>? _lastCategoryDoc;

  // Track current category to detect change
  String? _currentCategory;

  // Optional live subscription for first page (timestamp feed)

  @override
  void onInit() {
    super.onInit();
    // Initialize default feed by timestamp when the page/controller starts
    getPostsByTimestamp(reset: true, pageSize: 30, live: false);
  }

  @override
  void onClose() {
    super.onClose();
  }

  // 1) Upload post with custom UUID (v4 recommended)
  Future<String> uploadPost({
    required String title,
    required String category,
    required String description,
    required String authorId,
  }) async {
    final String id = const Uuid().v4(); // v4 is standard and well-supported
    final docRef = _postsRef.doc(id);

    // Build PostModel using the provided structure
    final post = PostModel(
      id: id,
      title: title.trim(),
      category: category.trim(),
      description: description.trim(),
      authorId: authorId,
      // createdAt is a String? in your model. If storing ISO time, set it here.
      // For reliable ordering, also write 'createdAtTs' as a server Timestamp.
      responsesCount: 0,
    );

    await docRef.set({
      ...post.toJson(),
      // Dedicated server timestamp for orderBy; avoids client clock issues
      'createdAtTs': FieldValue.serverTimestamp(),
    });

    return id;
  }

  // Internal: base query for timestamp ordering
  Query<Map<String, dynamic>> _timeQuery({int limit = 30}) {
    return _postsRef.orderBy('createdAtTs', descending: true).limit(limit);
  }

  // 2) Get posts by timestamp (first page when reset=true, else paginate)
  // live=true can attach a real-time stream to the first page
  Future<void> getPostsByTimestamp({
    bool reset = false,
    int pageSize = 30,
    bool live = false,
  }) async {
    if (reset) {
      isLoadingTimestamp.value = true;
      getPostByTimestamp.clear();
      _lastTimestampDoc = null;
    }

    final lastDoc = _lastTimestampDoc;
    final base = _timeQuery(limit: pageSize);
    final query = (lastDoc == null) ? base : base.startAfterDocument(lastDoc);

    if (!isLoadingTimestamp.value) isLoadingTimestamp.value = true;
    final snap = await query.get();

    final items = snap.docs.map((d) {
      final m = d.data();
      // Your PostModel.fromJson expects only a Map<String,dynamic>
      // If you want to keep 'id' in the model, you can add m['id'] = d.id;
      // m['id'] = d.id;
      return PostModel.fromJson(m);
    }).toList();

    if (lastDoc == null) {
      getPostByTimestamp.assignAll(items);
    } else {
      getPostByTimestamp.addAll(items);
    }

    if (snap.docs.isNotEmpty) {
      _lastTimestampDoc = snap.docs.last;
    }

    isLoadingTimestamp.value = false;

    
  }

  // Internal: base query for category + timestamp
  Query<Map<String, dynamic>> _categoryQuery(String category, {int limit = 30}) {
    return _postsRef
        .where('category', isEqualTo: category)
        .orderBy('createdAtTs', descending: true)
        .limit(limit);
  }

  // 3) Get posts by category (first page when reset=true or category changes; else paginate)
  Future<void> getPostsByCategory({
    required String category,
    bool reset = false,
    int pageSize = 30,
  }) async {
    final normalized = category.trim();
    final categoryChanged = (_currentCategory == null) || (_currentCategory != normalized);

    if (reset || categoryChanged) {
      isLoadingCategory.value = true;
      _currentCategory = normalized;
      getPostByCategory.clear();
      _lastCategoryDoc = null;
    }

    final lastDoc = _lastCategoryDoc;
    final base = _categoryQuery(normalized, limit: pageSize);
    final query = (lastDoc == null) ? base : base.startAfterDocument(lastDoc);

    if (!isLoadingCategory.value) isLoadingCategory.value = true;
    final snap = await query.get(); // may prompt to create composite index in console
    final items = snap.docs.map((d) {
      final m = d.data();
      // m['id'] = d.id;
      return PostModel.fromJson(m);
    }).toList();

    if (lastDoc == null) {
      getPostByCategory.assignAll(items);
    } else {
      getPostByCategory.addAll(items);
    }

    if (snap.docs.isNotEmpty) {
      _lastCategoryDoc = snap.docs.last;
    }

    isLoadingCategory.value = false;
  }

  Future<void> refreshTimestampFeed({int pageSize = 30}) =>
      getPostsByTimestamp(reset: true, pageSize: pageSize);

  Future<void> refreshCategoryFeed({int pageSize = 30}) async {
    if (_currentCategory != null) {
      await getPostsByCategory(category: _currentCategory!, reset: true, pageSize: pageSize);
    }
  }
}
