import 'package:chat_application/controllers/friend_conntroller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_application/models/user_model.dart';


class DiscoverController extends GetxController {
  final db = FirebaseFirestore.instance;

  // Inject FriendController (ensure it’s already put somewhere like Get.put(FriendController()))
  final FriendConntroller friendController = Get.find<FriendConntroller>();
  final auth=FirebaseAuth.instance;

  // State
  RxList<UserModel> discoverUsers = <UserModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMore = true.obs;
  

  // Paging
  static const int pageSize = 20;
  DocumentSnapshot? _lastDoc;

  @override
  void onInit() {
    super.onInit();
    // Initial fetch
    refreshDiscover();
  }

  Future<void> refreshDiscover() async {
    isLoading.value = true;
    try {
      discoverUsers.clear();
      hasMore.value = true;
      _lastDoc = null;
      await _fetchPage(reset: true);
    } catch (e) {
      // log or handle
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoadingMore.value) return;
    isLoadingMore.value = true;
    try {
      await _fetchPage();
    } catch (e) {
      // log or handle
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> _fetchPage({bool reset = false}) async {
    // Defensive: ensure FriendController has required data
    final myUid = auth.currentUser!.uid;
    final known = friendController.allKnownUsersSet;

    // Base query: order by a stable field; fall back to 'joinedAt' or 'name'
    Query query = db.collection('users').orderBy('joinedAt', descending: true).limit(pageSize);

    if (_lastDoc != null) {
      query = (query as Query<Map<String, dynamic>>).startAfterDocument(_lastDoc!);
    }

    final snap = await query.get();
    if (snap.docs.isEmpty) {
      hasMore.value = false;
      return;
    }

    // Update paging cursor
    _lastDoc = snap.docs.last;

    // Map to models and filter
    final List<UserModel> page = [];
    for (final d in snap.docs) {
      final data = d.data() as Map<String, dynamic>?; // null-safe
      if (data == null) continue;

      final user = UserModel.fromJson(data);
      // Ensure id is present; if not, use doc id
      user.id ??= d.id;

      // Exclude self and any known users (friends + requested + requests)
      if (user.id == null) continue;
      if (user.id == myUid) continue;
      if (known.contains(user.id)) continue;

      page.add(user);
    }

    // Append to observable list
    if (page.isEmpty && snap.docs.length < pageSize) {
      // If nothing qualified and we reached a small page, we might be near the end
      // Still allow another loadMore() because filters can skip many users
    }
    discoverUsers.addAll(page);

    // If Firestore returned fewer than pageSize, we likely reached the end
    if (snap.docs.length < pageSize) {
      hasMore.value = false;
    }
  }

  // Utility to be called after sending a request to someone (optional):
  // keeps the card updated without a full refresh
  void markRequestedLocally(String otherUid) {
    friendController.requestedList.add(otherUid);
    friendController.allKnownUsersSet.add(otherUid);
    // Optionally remove the user from current discover list immediately:
    // discoverUsers.removeWhere((u) => u.id == otherUid);
  }
}
