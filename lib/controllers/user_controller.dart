import 'package:chat_application/controllers/image_controller.dart';
import 'package:chat_application/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  RxBool isLoading = false.obs;
  Rx<UserModel> currentUser = UserModel().obs;

  void onInit() {
    super.onInit();
    getUserDetails();
  }

  //function to extract the current user details
  Future<void> getUserDetails() async {
    isLoading.value = true;
    try {
      await db
          .collection('users')
          .doc(auth.currentUser!.uid)
          .get()
          .then(
            (value) => {currentUser.value = UserModel.fromJson(value.data()!)},
          );
    } catch (e) {
      print('ERROR IN PROFILE CONTROLLER GET USER DETAILS' + e.toString());
    }
    isLoading.value = false;
  }

  //update interests to the user
  Future<void> addInterests(List<String> newinterest) async {
    isLoading.value = true;

    // List<String> interests = currentUser.value.interests!;
    // if (!interests.contains(interest)) {
    //   interests.add(interest);
    // }

    try {
      await db.collection('users').doc(auth.currentUser!.uid).update({
        'interests': newinterest,
      });
      await getUserDetails();
    } catch (e) {
      print('ERROR FROM USERCONTROLLER ADDINTEREST' + e.toString());
    }

    isLoading.value = false;
  }

  //remove interests from the user
  Future<void> removeInterests(String interest) async {
    isLoading.value = true;

    List<String> newInterests = currentUser.value.interests!;
    if (newInterests.contains(interest)) {
      newInterests.remove(interest);
    }

    try {
      await db.collection('users').doc(auth.currentUser!.uid).update({
        'interests': newInterests,
      });
      await getUserDetails();
    } catch (e) {
      print('ERROR FROM USERCONTROLLER REMOVE INTEREST' + e.toString());
    }

    isLoading.value = false;
  }

  //update profile Image
  Future<void> updateProfileImage(String imageUrl) async {
    isLoading.value = true;
    try {
      // String imageUrl = await ImageController().uploadFileToSupabase(imagePath);
      await db.collection('users').doc(auth.currentUser!.uid).update({
        'profileImage': imageUrl,
      });
      await getUserDetails();
    } catch (e) {
      print('ERROR IN USERCONTROLLER UPDATE PROFILEIMAGE' + e.toString());
    }
    isLoading.value = false;
  }

  //to update the name
  Future<void> updateName(String newName) async {
    isLoading.value = true;
    try {
      await db.collection('users').doc(auth.currentUser!.uid).update({
        'name': newName,
      });
      await getUserDetails();
    } catch (e) {
      print('ERROR IN PROFILE CONTROLLER UPDATE NAME ' + e.toString());
    }
    isLoading.value = false;
  }

  //to update bio
  Future<void> updateBio(String newBio) async {
    isLoading.value = true;
    try {
      await db.collection('users').doc(auth.currentUser!.uid).update({
        'bio': newBio,
      });
      await getUserDetails();
    } catch (e) {
      print('ERROR IN PROFILE CONTROLLER UPDATE BIO' + e.toString());
    }
    isLoading.value = false;
  }

  Future<void> updateEmail(String email) async {
    isLoading.value = true;
    try {
      await db.collection('users').doc(auth.currentUser!.uid).update({
        'email': email,
      });
      await getUserDetails();
    } catch (e) {
      print('ERROR IN PROFILE CONTROLLER UPDATE EMAIL' + e.toString());
    }
    isLoading.value = false;
  }

  //to update academic info
  Future<void> updateAcademicInfo(String newInfo) async {
    isLoading.value = true;
    try {
      await db.collection('users').doc(auth.currentUser!.uid).update({
        'academicInfo': newInfo,
      });
      await getUserDetails();
    } catch (e) {
      print('ERROR IN PROFILE CONTROLLER UPDATE ACADEMIC INFO' + e.toString());
    }
    isLoading.value = false;
  }

  //to update university
  Future<void> updateUniversity(String newUniversity) async {
    isLoading.value = true;
    try {
      await db.collection('users').doc(auth.currentUser!.uid).update({
        'university': newUniversity,
      });
      await getUserDetails();
    } catch (e) {
      print('ERROR IN PROFILE CONTROLLER UPDATE UNIVERSITY' + e.toString());
    }
    isLoading.value = false;
  }

  //to update location
  Future<void> updateLocation(String newLocation) async {
    isLoading.value = true;
    try {
      await db.collection('users').doc(auth.currentUser!.uid).update({
        'location': newLocation,
      });
      await getUserDetails();
    } catch (e) {
      print('ERROR IN PROFILE CONTROLLER UPDATE LOCATION' + e.toString());
    }
    isLoading.value = false;
  }

  //to update year
  Future<void> updateYear(String newYear) async {
    isLoading.value = true;
    try {
      await db.collection('users').doc(auth.currentUser!.uid).update({
        'year': newYear,
      });
      await getUserDetails();
    } catch (e) {
      print('ERROR IN PROFILE CONTROLLER UPDATE LOCATION' + e.toString());
    }
    isLoading.value = false;
  }

  //to update major
  Future<void> updateMajor(String newMajor) async {
    isLoading.value = true;
    try {
      await db.collection('users').doc(auth.currentUser!.uid).update({
        'major': newMajor,
      });
      await getUserDetails();
    } catch (e) {
      print('ERROR IN PROFILE CONTROLLER UPDATE LOCATION' + e.toString());
    }
    isLoading.value = false;
  }
}
