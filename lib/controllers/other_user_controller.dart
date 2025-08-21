import 'package:chat_application/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class OtherUserController extends GetxController{
  final String otherUid;
  OtherUserController({required this.otherUid});

  final auth=FirebaseAuth.instance;
  final db=FirebaseFirestore.instance;

  //this user will have the data of the otherUser based on friendlist 
  //and the functions to show the name profileImage and other data of the 
  //other user
  Rx<UserModel> otherUser=UserModel().obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    await db.collection('users').doc(otherUid).get().then((value)=>{
      otherUser.value=UserModel.fromJson(value.data()!),
    });
  }
}