import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageController extends GetxController {

  final ImagePicker imagePicker=ImagePicker();

  final store=Supabase.instance.client;

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

    if(imagePath==null){
    return '';}

    try{
      final response = await store.storage.from('files').upload(imagePath, file);
      // print(response);
      final downloadUrl = store.storage.from('files').getPublicUrl(imagePath);
      // print(downloadUrl+'😂😂');
      return downloadUrl;
    } catch(e){
      // print(e.toString());
      return '';
    }
  }

  

}