import 'package:chat_application/controllers/user_controller.dart';
import 'package:chat_application/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FriendConntroller extends GetxController {
  // final UserController userController=Get.put(UserController());

  RxList<String> friendList = <String>[].obs;
  RxList<String> requestedList = <String>[].obs;
  RxList<String> requestsList = <String>[].obs;
  RxBool isLoading=false.obs;

  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  late String myUid;

  onInit() {
    super.onInit();
    myUid=auth.currentUser!.uid;
    initializeAllList();
  }

  //all list are initilized whenever this page will be opened
  initializeAllList() async {
    final doc = await db.collection('users').doc(myUid).get();
    final user = UserModel.fromJson(doc.data()!);

    friendList.value = user.friends ?? [];
    requestedList.value = user.requested ?? [];
    requestsList.value = user.requests ?? [];

  print('initiliaze function');
    print(friendList);
    print(requestedList);
    print(requestsList);
  }


  //to add friend in the database in my list plus his list and remove from
  //my requests list and his requested list
  Future<void> addFri(String otherUid)async{
    print('addFri function called');
    isLoading.value=true;
    try{
      if(!friendList.contains(otherUid)){
        friendList.add(otherUid);
      }
      if(requestsList.contains(otherUid)){
        requestsList.remove(otherUid);
      }

      List<String> otherFriendList=[];
      List<String> otherRequestedList=[];
      await db.collection('users').doc(otherUid).get().then((value)=>{
        otherFriendList=UserModel.fromJson(value.data()!).friends!,
        otherRequestedList=UserModel.fromJson(value.data()!).friends!,
      });

      if(!otherFriendList.contains(myUid)){
        otherFriendList.add(myUid);
      }
      if(otherRequestedList.contains(myUid)){
        otherRequestedList.remove(myUid);
      }

      await db.collection('users').doc(otherUid).update({
        'friends':otherFriendList,
        'requested':otherRequestedList
      });

      await db.collection('users').doc(myUid).update({
        'friends':friendList,
        'requests':requestsList
      });
    } catch (e){
      print('ERROR IN FRIEND CONTROLLER ADDFRI'+e.toString());
    }
    isLoading.value=false;
  }


  //add to requested list of the current user while requesting
  Future<void> addInRequestedList(String otherUid) async {
    isLoading.value=true;
    print('addinrequestlist function');
    try{
      print(requestedList);
      
      if(!requestedList.contains(otherUid)){
        requestedList.add(otherUid);
      }

      print(requestedList);

      List<String> otherRequestsList=[];
      await db.collection('users').doc(otherUid).get().then((value)=>{
        otherRequestsList=UserModel.fromJson(value.data()!).requests!,
      });

      if(!otherRequestsList.contains(myUid)){
        otherRequestsList.add(myUid);
      }

      await db.collection('users').doc(myUid).update({
        'requested': requestedList.value,
      });

      await db.collection('users').doc(otherUid).update({
        'requests':otherRequestsList,
      });
    } catch (e){

    }
    isLoading.value=false;
  }

}
