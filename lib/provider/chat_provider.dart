import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:bono_gifts/models/contact_model.dart';
import 'package:bono_gifts/models/network_cat_model.dart';
import 'package:bono_gifts/models/network_model.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:provider/provider.dart';

class ChatProvider extends ChangeNotifier {
  List<String> phones = [];
  List<String> contactList = [];
  List<String> newList = [];
  List<ContModel> nameCont = [];
  List<NewtWorkModel> moveList = [];

  AudioCache audio = AudioCache(fixedPlayer: AudioPlayer());

  playSendMusic(){
    audio.play("send.wav");
  }
  playRecieveMessage(){
    audio.play("receive.wav");
  }


  FirebaseFirestore firestore = FirebaseFirestore.instance;

  makeNetWorkSelect(int index) {
    netWorkLsit[index].isSelect = !netWorkLsit[index].isSelect;
    notifyListeners();
  }

  makeCatSE(int idn) {
    networkCat[idn].isSel = !networkCat[idn].isSel;
    notifyListeners();
  }

  makeselect(int i) {
    for (var l in networkCat) {
      l.isSel = false;
    }
    networkCat[i].isSel = true;
    notifyListeners();
  }

  makeCatSelect(int ind){
    for(var l in networkCat){
      l.isSel = false;
    }
    networkCat[ind].isSel = true;
  }

  addFirstChar(String chat){
    matchList.add(chat);
  }

  checkBoxSelect(int i){
    makeNetWorkSelect(i);
    if(netWorkLsit[i].isSelect == true){

        moveList.add(NewtWorkModel(
            name: netWorkLsit[i].name,
            phone: netWorkLsit[i].phone,
            photo: netWorkLsit[i].photo,
            isSelect: netWorkLsit[i].isSelect));

    }else{

    }
  }

  List matchList = [];

  void getContacts() async {
    contactList.clear();
    if (await FlutterContacts.requestPermission()) {
      List<Contact> contacts = await FlutterContacts.getContacts();
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      for (var i = 0; i < contacts.length; i++) {
        contactList.add(contacts[i].phones[0].number.replaceAll(' ', ''));
        nameCont.add(ContModel(
            name: "${contacts[i].name.first} ${contacts[i].name.last}",
            phone: contacts[i].phones[0].number));
        // print(contactList);
        notifyListeners();
      }
    }
    Future.delayed(const Duration(seconds: 2), () {
      fetchNewtrork();
    });
    notifyListeners();
  }

  List<NewtWorkModel> netWorkLsit = [];

  final service = ChatService();

  List<NetCatMo> networkCat = [
    NetCatMo(name: 'All', isSel: false),
    NetCatMo(name: 'Friends', isSel: false),
    NetCatMo(name: 'Family', isSel: false),
    NetCatMo(name: 'Work', isSel: false),
    NetCatMo(name: 'School', isSel: false),
    NetCatMo(name: 'Neigbour', isSel: false),
    NetCatMo(name: 'Others', isSel: false),
  ];

  fetchNewtrork() {
    print(contactList);
    // .where('searchPhone',isLessThanOrEqualTo: contactList[i]).where('searchPhone1',isEqualTo: contactList[i])
    for (var i = 0; i < contactList.length; i++) {
      service.fetchSearch1(contactList, i, 'searchPhone1').then((value) {
        for (var d = 0; d < value.docs.length; d++) {
          print(value.docs[d]['name']);
          netWorkLsit.add(NewtWorkModel(
              name: value.docs[d]['name'],
              phone: value.docs[d]['phone'],
              photo: value.docs[d]['profile_url'],
              isSelect: false));
        }
      });
      service.fetchSearch1(contactList, i, 'phone').then((value) {
        for (var d = 0; d < value.docs.length; d++) {
          print(value.docs[d]['name']);
          netWorkLsit.add(NewtWorkModel(
              name: value.docs[d]['name'],
              phone: value.docs[d]['phone'],
              photo: value.docs[d]['profile_url'],
              isSelect: false));
        }
      });
      service.fetchSearch1(contactList, i, 'searchPhone').then((value) {
        for (var d = 0; d < value.docs.length; d++) {
          print(value.docs[d]['name']);
          netWorkLsit.add(NewtWorkModel(
              name: value.docs[d]['name'],
              phone: value.docs[d]['phone'],
              photo: value.docs[d]['profile_url'],
              isSelect: false));
        }
      });
    }
    notifyListeners();
  }
  DateTime date = DateTime.now();

  String docId = '';

  String generateRandomString(int len) {
    var r = Random();
    const _chars = 'BCDEFGxcbHIJKLsdfdMNOPhfQRSTUdfdfcvVWXYZ';
    docId = List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }

  sendTextMessage(BuildContext context,message,String recieverPhone,String messageCount,String recieverName,String profileImage){
    final pro = Provider.of<SignUpProvider>(context,listen: false);
    firestore.collection('chats').doc(pro.phone.toString()).collection(recieverPhone).doc(docId).set({
      'message':message.text,
      'date': "${date.year}/${date.month}/${date.day}",
      'timestamp':DateTime.now(),
      'recieverID':recieverPhone,
      'senderID':pro.phone,
      'profileImage':pro.userImage,
      'count':messageCount,
      'isSendMe':true,
      'isSeen':false,
      'isOnline':true,
      'messageType': 'text',
      'isFavorite':false,
      'id':docId,
    });
    firestore.collection('chats').doc(recieverPhone).collection(pro.phone.toString()).doc(docId).set({
      'message':message.text,
      'date': "${date.year}/${date.month}/${date.day}",
      'timestamp':DateTime.now(),
      'recieverID':recieverPhone,
      'senderID':pro.phone,
      'profileImage':pro.userImage,
      'count':messageCount,
      'isSendMe':false,
      'isSeen':false,
      'isOnline':false,
      'messageType': 'text',
      'isFavorite':false,
      'id':docId,
    });
    firestore.collection('recentChats').doc(recieverPhone).collection('myChats').doc(pro.phone).set({
      'lastMessage':message.text,
      'date': "${date.year}/${date.month}/${date.day}",
      'timestamp':DateTime.now(),
      'recieverID':recieverPhone,
      'senderID':pro.phone,
      'recieverName':pro.name,
      'profileImage':pro.userImage,
      'count':messageCount,
      'isSendMe':false,
      'isSeen':false,
      'isOnline':false,
      'messageType': 'text',
      // 'token': widget.fcmToken,
    });
    firestore.collection('recentChats').doc(pro.phone.toString()).collection('myChats').doc(recieverPhone).set({
      'lastMessage':message.text,
      'date': "${date.year}/${date.month}/${date.day}",
      'timestamp':DateTime.now(),
      'recieverID':recieverPhone,
      'senderID':pro.phone,
      'recieverName':recieverName,
      'profileImage':profileImage,
      'count':messageCount,
      'isSendMe':true,
      'isSeen':false,
      'isOnline':true,
      'messageType': 'text',
      // 'token':widget.fcmToken,
    });
    playSendMusic();
  }

  sendImageMessage(BuildContext context,message,String recieverPhone,String messageCount,String recieverName,String profileImage){
    final pro = Provider.of<SignUpProvider>(context,listen: false);
    firestore.collection('chats').doc(pro.phone.toString()).collection(recieverPhone).doc(docId).set({
      'message':message,
      'date': "${date.year}/${date.month}/${date.day}",
      'timestamp':DateTime.now(),
      'recieverID':recieverPhone,
      'senderID':pro.phone,
      'profileImage':pro.userImage,
      'count':messageCount,
      'isSendMe':true,
      'isSeen':false,
      'isOnline':true,
      'messageType': 'image',
      'isFavorite':false,
      'id':docId,
    });
    firestore.collection('chats').doc(recieverPhone).collection(pro.phone.toString()).doc(docId).set({
      'message':message,
      'date': "${date.year}/${date.month}/${date.day}",
      'timestamp':DateTime.now(),
      'recieverID':recieverPhone,
      'senderID':pro.phone,
      'profileImage':pro.userImage,
      'count':messageCount,
      'isSendMe':false,
      'isSeen':false,
      'isOnline':false,
      'messageType': 'image',
      'isFavorite':false,
      'id':docId,
    });
    firestore.collection('recentChats').doc(recieverPhone).collection('myChats').doc(pro.phone).set({
      'lastMessage':message,
      'date': "${date.year}/${date.month}/${date.day}",
      'timestamp':DateTime.now(),
      'recieverID':recieverPhone,
      'senderID':pro.phone,
      'recieverName':pro.name,
      'profileImage':pro.userImage,
      'count':messageCount,
      'isSendMe':false,
      'isSeen':false,
      'isOnline':false,
      'messageType': 'image',
      // 'token': widget.fcmToken,
    });
    firestore.collection('recentChats').doc(pro.phone.toString()).collection('myChats').doc(recieverPhone).set({
      'lastMessage':message,
      'date': "${date.year}/${date.month}/${date.day}",
      'timestamp':DateTime.now(),
      'recieverID':recieverPhone,
      'senderID':pro.phone,
      'recieverName':recieverName,
      'profileImage':profileImage,
      'count':messageCount,
      'isSendMe':true,
      'isSeen':false,
      'isOnline':true,
      'messageType': 'image',
      // 'token':widget.fcmToken,
    });
    playSendMusic();
  }

  likeMessage(String parentDoc,String subDoc,String docId,bool val){
    service.likeMessage(parentDoc, subDoc, docId,val);
  }
}
