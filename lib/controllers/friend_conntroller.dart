import 'package:chat_application/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FriendConntroller extends GetxController {

  //friend list is to show the friends in my profile
  RxList<String> friendList = <String>[].obs;
  //requested list is to show the list of users I had requested for friendship
  RxList<String> requestedList = <String>[].obs;
  //requests list is the list containing all the uid of other users who have
  //requested to me for friendship
  RxList<String> requestsList = <String>[].obs;
  //set to store all the friends ,requested and requests
  RxSet<String> allKnownUsersSet=<String>{}.obs;

  RxBool isLoading = false.obs;

  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  late String myUid;

  onInit() {
    super.onInit();
    myUid = auth.currentUser!.uid;
    initializeAllList();
  }

  //all list are initilized whenever this page will be opened
  Future<void> initializeAllList() async {
    final doc = await db.collection('users').doc(myUid).get();
    final user = UserModel.fromJson(doc.data()!);

    friendList.value = user.friends ?? [];
    requestedList.value = user.requested ?? [];
    requestsList.value = user.requests ?? [];
    allKnownUsersSet=<String>{}.obs;
    allKnownUsersSet.addAll(friendList);
    allKnownUsersSet.addAll(requestedList);
    allKnownUsersSet.addAll(requestsList);

    print('initiliaze function');
    print(friendList);
    print(requestedList);
    print(requestsList);
  }

  //to add friend in the database in my list plus his list and remove from
  //my requests list and his requested list
  Future<void> addFriend(String otherUid) async {
    print('addFri function called');
    isLoading.value = true;
    try {
      if (!friendList.contains(otherUid)) {
        friendList.add(otherUid);
      }
      if (requestsList.contains(otherUid)) {
        requestsList.remove(otherUid);
      }

      List<String> otherFriendList = [];
      List<String> otherRequestedList = [];
      await db
          .collection('users')
          .doc(otherUid)
          .get()
          .then(
            (value) => {
              otherFriendList = UserModel.fromJson(value.data()!).friends!,
              otherRequestedList = UserModel.fromJson(value.data()!).requested!,
            },
          );

      if (!otherFriendList.contains(myUid)) {
        otherFriendList.add(myUid);
      }
      if (otherRequestedList.contains(myUid)) {
        otherRequestedList.remove(myUid);
      }

      await db.collection('users').doc(otherUid).update({
        'friends': otherFriendList,
        'requested': otherRequestedList,
      });

      await db.collection('users').doc(myUid).update({
        'friends': friendList,
        'requests': requestsList,
      });
    } catch (e) {
      print('ERROR IN FRIEND CONTROLLER ADDFRI' + e.toString());
    }
    isLoading.value = false;
  }

  //add to requested list of the current user while requesting
  Future<void> addInRequestedList(String otherUid) async {
    isLoading.value = true;
    print('addinrequestlist function');
    try {
      print(requestedList);

      if (!requestedList.contains(otherUid)) {
        requestedList.add(otherUid);
      }

      print(requestedList);

      List<String> otherRequestsList = [];
      await db
          .collection('users')
          .doc(otherUid)
          .get()
          .then(
            (value) => {
              otherRequestsList = UserModel.fromJson(value.data()!).requests!,
            },
          );

      if (!otherRequestsList.contains(myUid)) {
        otherRequestsList.add(myUid);
      }

      await db.collection('users').doc(myUid).update({
        'requested': requestedList.value,
      });

      await db.collection('users').doc(otherUid).update({
        'requests': otherRequestsList,
      });
    } catch (e) {}
    isLoading.value = false;
  }

  //to witdraw request to other user after not accepted for so long
  Future<void> withdrawRequest(String otherUid) async {
    isLoading.value = true;
    try {
      if (requestedList.contains(otherUid)) {
        requestedList.remove(otherUid);
      }
      await db.collection('users').doc(myUid).update({
        'requested': requestedList,
      });

      List<String> otherRequestsList = [];
      await db
          .collection('users')
          .doc(otherUid)
          .get()
          .then(
            (value) => {
              otherRequestsList = UserModel.fromJson(value.data()!).requests!,
            },
          );

      if (otherRequestsList.contains(myUid)) {
        otherRequestsList.remove(myUid);
      }
      await db.collection('users').doc(otherUid).update({
        'requests': otherRequestsList,
      });
    } catch (e) {
      print('ERROR IN FRIEND CONTROLLER WITHDRAW REQUEST' + e.toString());
    }
    isLoading.value = false;
  }

  //to reject other persons requests from my requestsList
  Future<void> rejectRequests(String otherUid) async {
    isLoading.value = true;
    try {
      if (requestsList.contains(otherUid)) {
        requestsList.remove(otherUid);
      }

      await db.collection('users').doc(myUid).update({
        'requests': requestsList,
      });

      List<String> otherRequestedList = [];
      await db
          .collection('users')
          .doc(otherUid)
          .get()
          .then(
            (value) => {
              otherRequestedList = UserModel.fromJson(value.data()!).requested!,
            },
          );

      if (otherRequestedList.contains(myUid)) {
        otherRequestedList.remove(myUid);
      }

      await db.collection('users').doc(otherUid).update({
        'requested': otherRequestedList,
      });
    } catch (e) {
      print('ERROR IN FRIEND CONTROLLER REJECTREQUESTS' + e.toString());
    }
    isLoading.value = false;
  }
}
