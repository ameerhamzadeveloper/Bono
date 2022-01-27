import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class FeedsService{

  Future<bool> savePost(Map<String,dynamic> map) async {
    final CollectionReference ref = FirebaseFirestore.instance.collection('userPosts');
    // final CollectionReference comRef = FirebaseFirestore.instance.collection('userPosts').doc(map['phone']).collection('comments');
      var snapshot = await FirebaseStorage.instance.ref().child('Posts Pictures/${map['phone']}').putData(map['image']);
      var url = (await snapshot.ref.getDownloadURL()).toString();
      var userData = {
        'title': map['title'],
        'des': map['des'],
        'image url': url,
        'like':0,
        'share':0,
        'timestamp': DateTime.now(),
        'phone':map['phone'],
        'profileImage': map['profileImage'],
        'profileName':map['profileName'],
      };
      await ref.add(userData).then((value){
        print("Posted");
      });


    return true;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getFeedsPosts()async{
    Future<QuerySnapshot<Map<String, dynamic>>> data = FirebaseFirestore.instance.collection('userPosts').limit(10).get();
    return data;
  }
  
  addComments(String docRed,BuildContext context,String text){
    final pro = Provider.of<SignUpProvider>(context,listen: false);
    FirebaseFirestore.instance.collection('userPosts').doc(docRed).collection('comments').add({
      'name':pro.name,
      'image':pro.userImage,
      'text': text,
    });
  }

}