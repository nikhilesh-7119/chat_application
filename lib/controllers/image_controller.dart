import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageController extends GetxController {

  final ImagePicker imagePicker=ImagePicker();

  final store=Supabase.instance.client;
  final auth=FirebaseAuth.instance;

  Future<String> pickImage(ImageSource source)async{
    final XFile? image=await imagePicker.pickImage(source: source);
    if(image!=null){
      return image.path;
    }
    return '';
  }

  Future<String> uploadFileToSupabase(String imagePath) async{
    // final path = '$imageUrl';
    final file = File(imagePath);
    print(imagePath+"image is picked anf in uploading function");

    if(imagePath==null){
      print("IMAGEPATH IS NULL");
    return '';}

    try{
      print('IN TRY BLOCK IN IMAGECONTROLLER');
      final response = await store.storage.from('profileImages').upload(imagePath, file);
      print(response+"RESPONSE");
      final downloadUrl = store.storage.from('profileImages').getPublicUrl(imagePath);
      print(downloadUrl+'😂😂');
      return downloadUrl;
    } catch(e){
      // print(e.toString());
      return '';
    }
  }

  

}