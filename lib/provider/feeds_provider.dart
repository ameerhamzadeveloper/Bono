import 'dart:typed_data';

import 'package:bono_gifts/models/feeds_models.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/services/feeds_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FeedsProvider extends ChangeNotifier{
  XFile? image;
  Uint8List? bytesImage;
  String title = '';
  String description = '';
  TextEditingController commnetController = TextEditingController();
  
  final colRef = FirebaseFirestore.instance.collection('userPosts');

  getImage()async{
    XFile? tempImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    image = tempImage;
    bytesImage = await image!.readAsBytes();
    notifyListeners();
  }

  setDescription(String des){
    description = des;
  }
  setTitle(String titl){
    title = titl;
  }

  final service = FeedsService();

  List<FeedsModels> feeds = [];

  uploadPost(BuildContext context){
    final pro = Provider.of<SignUpProvider>(context,listen: false);
    Map<String,dynamic> data = {
      'title':title,
      'des':description,
      'image':bytesImage,
      'phone':pro.phone,
      'profileImage': pro.userImage,
      'profileName':pro.name,
    };
    service.savePost(data).then((value) {
      if(value){
        Navigator.pop(context);
      }
      print(value);
    });

  }

  getFeedsPosts(){
    service.getFeedsPosts().then((value){
      for(var fed in value.docs){
        feeds.add(FeedsModels(image: fed['image url'], description: fed['des'],
            title: fed['title'], date: fed['timestamp'].toDate(),
            profileImage: fed['profileImage'],profileName: fed['profileName'],
          isDesOpen: false,phone: fed['phone']
         ),
        );
        notifyListeners();
      }
    });
  }

  addComment(String docRed,BuildContext context){
    service.addComments(docRed, context, commnetController.text);
    commnetController.clear();
  }


  setCommentText(String val){
    commnetController = TextEditingController(text: val);
  }


}