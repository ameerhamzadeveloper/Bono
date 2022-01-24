import 'package:bono_gifts/models/contact_model.dart';
import 'package:bono_gifts/models/network_cat_model.dart';
import 'package:bono_gifts/models/network_model.dart';
import 'package:bono_gifts/services/chat_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ChatProvider extends ChangeNotifier {
  List<String> phones = [];
  List<String> contactList = [];
  List<String> newList = [];
  List<ContModel> nameCont = [];
  List<NewtWorkModel> moveList = [];

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
    Future.delayed(const Duration(seconds: 3), () {
      fetchNewtrork();
    });
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
          netWorkLsit.add(NewtWorkModel(
              name: value.docs[d]['name'],
              phone: value.docs[d]['phone'],
              photo: value.docs[d]['profile_url'],
              isSelect: false));
        }
      });
      service.fetchSearch1(contactList, i, 'phone').then((value) {
        for (var d = 0; d < value.docs.length; d++) {
          netWorkLsit.add(NewtWorkModel(
              name: value.docs[d]['name'],
              phone: value.docs[d]['phone'],
              photo: value.docs[d]['profile_url'],
              isSelect: false));
        }
      });
      service.fetchSearch1(contactList, i, 'searchPhone').then((value) {
        for (var d = 0; d < value.docs.length; d++) {
          netWorkLsit.add(NewtWorkModel(
              name: value.docs[d]['name'],
              phone: value.docs[d]['phone'],
              photo: value.docs[d]['profile_url'],
              isSelect: false));
        }
      });
    }
  }
}
