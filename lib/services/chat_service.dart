import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatService{


  Future<QuerySnapshot> fetchSearch1(List<String> contactList,int i,String format)async {
    Future<QuerySnapshot> snap = FirebaseFirestore.instance.collection('users').where(
        format, isEqualTo: contactList[i]).get();
    return snap;
  }

  Future<String> uploadImage(Uint8List? imageBytes, String cid, String filename,String userid) async {
    var snapshot = await FirebaseStorage.instance.ref().child('chats/${userid}/$cid/$filename').putData(imageBytes!);
    var url = (await snapshot.ref.getDownloadURL()).toString();
    return url;
  }
  
  likeMessage(String parentDoc,String subDoc,String docId,bool value){
    FirebaseFirestore.instance.collection('chats').doc(parentDoc).collection(subDoc).doc(docId).update({
      'isFavorite': value,
    });
    FirebaseFirestore.instance.collection('chats').doc(subDoc).collection(parentDoc).doc(docId).update({
      'isFavorite': value,
    });
  }
}