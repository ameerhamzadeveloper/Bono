import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService{


  Future<QuerySnapshot> fetchSearch1(List<String> contactList,int i,String format)async {
    Future<QuerySnapshot> snap = FirebaseFirestore.instance.collection('users').where(
        format, isEqualTo: contactList[i]).get();
    return snap;
  }
}