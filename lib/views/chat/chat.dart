import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/helper/country_code_without_plus.dart';
import 'package:bono_gifts/helper/helper.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/views/chat/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:provider/provider.dart';
class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat>  with TickerProviderStateMixin{
  late TabController _tabController;

  getFirebaseContact(){
    FirebaseFirestore.instance.collection('users').get().then((value){
      for(var d in value.docs){
        print("calling");
        phones.add(d['searchPhone']);
        print(d['searchPhone']);
      }
      getContacts();
    });
  }

  List<String> phones = [];
  List<String> contactList = [];
  List<String> newList = [];
  List<String> newDbList = [];
  List<String> newContList = [];
  List<ContModel> nameCont = [];

  void getContacts()async{
    newList.clear();
    contactList.clear();
    newDbList.clear();
    newContList.clear();
    if (await FlutterContacts.requestPermission()) {
      List<Contact> contacts = await FlutterContacts.getContacts();
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      for(var i = 0;i< contacts.length;i++){
        setState(() {
          contactList.add(contacts[i].phones[0].number.replaceAll(' ', ''));
          nameCont.add(ContModel(name: "${contacts[i].name.first} ${contacts[i].name.last}", phone: contacts[i].phones[0].number));
          // print(contactList);
        });
      }
    }
    // compareDBListDailCode();
    compareContactListDailCode();
    Future.delayed(Duration(seconds: 3),(){
      matchTheList();
    });
  }

  // compareDBListDailCode(){
  //   for(var j = 0; j < DailCode().dailCode.length;j++){
  //     for(var i = 0; i < phones.length;i++){
  //       if(phones[i].contains(DailCode().dailCode[j]['dial_code']!)){
  //         // print(phones[i].replaceAll(DailCode().dailCode[j]['dial_code']!, ''));
  //         newDbList.add(phones[i].replaceAll(DailCode().dailCode[j]['dial_code']!, ''));
  //       }
  //     }
  //   }
  // }

  compareContactListDailCode(){
    // for(var j = 0; j < DailCode().dailCode.length;j++){
    //   for(var i = 0; i < contactList.length;i++){
    //     // if(contactList[i].contains(DailCode().dailCode[j]['dial_code']!) || (contactList[i].substring(0,2) == '00')||(contactList[i].startsWith('0',0))){
    //       var list = contactList[i].replaceAll(' ', '');
    //
    //       var lw = list.substring(0,2) == '00'? list.substring(2, list.length).replaceAll(DailCodeWithoutPlus().dailCode[j]['dial_code']!, '') : list;
    //       var li = lw.startsWith('0',0) ? lw.substring(1, lw.length -1): lw;
    //       // var nL = ;
    //       // print("contact ${list.replaceAll(DailCode().dailCode[j]['dial_code']!, '')}");
    //       newContList.add(li.replaceAll(DailCode().dailCode[j]['dial_code']!, ''));
        // }
        // var list = contactList[i].replaceAll(' ', '');
        // var doublezero = list[i].substring(0,2) == '00' ? list.substring(2, list.length).replaceAll(DailCodeWithoutPlus().dailCode[j]['dial_code']!, ''):list;
        // var singZero = doublezero[i].startsWith('0',0) ? doublezero.substring(1, list.length) : doublezero;
        // var countCode = singZero.contains(DailCode().dailCode[j]['dial_code']!) ? singZero.replaceAll(DailCode().dailCode[j]['dial_code']!, ''):singZero;
        // newContList.add(countCode);
        // var list = contactList[i].replaceAll(' ', '');
        // if(contactList[i].substring(0,2) == '00'){
        //   var fL = contactList[i].substring(2, contactList[i].length);
        //   var fl = contactList[i].substring(2, contactList[i].length).replaceFirst(DailCodeWithoutPlus().dailCode[j]['dial_code']!, '',0);
        //   print("wihtout country code ${fl} $j and $i");
        //   newContList.add(fl);
        // }
        // else if(contactList[i].startsWith('0',0)){
        //   newContList.add(contactList[i].substring(1, contactList[i].length));
        // }else if(contactList[i].contains(DailCode().dailCode[j]['dial_code']!)){
        //   // var nL = ;
        //   print("contact ${contactList[i].replaceAll(DailCode().dailCode[j]['dial_code']!, '')}");
        //   newContList.add(contactList[i].replaceAll(DailCode().dailCode[j]['dial_code']!, ''));
        // }
    //   }
    // }
  }

  matchTheList(){
    print(phones);
    print("new Cont ${newContList.toSet().toList()}");
    for(var i = 0;i< phones.length;i++){
      for(var j =0;j<contactList.toSet().toList().length;j++){
        if(contactList.toSet().toList()[j].contains(phones[i])){
          print("iorere ${contactList[j]}");
          setState(() {
            newList.add(contactList[j]);
          });
        }
      }
    }
    Future.delayed(Duration(seconds: 2),(){
      fetchNewtrork();
    });
  }
  List<NewtWorkModel> netWorkLsit = [];

  fetchNewtrork(){
    print("called");
    print(newList.length);
    for(var i = 0; i<newList.length;i++){
      FirebaseFirestore.instance.collection('users').where('phone', isLessThanOrEqualTo: newList[i]).get().then((value){
        print(value.docs[i].id);
        setState(() {
          netWorkLsit.add(NewtWorkModel(name: value.docs[i]['name'], phone: value.docs[i]['phone'], photo: value.docs[i]['profile_url'],isSelect: false));
        });
      });
    }
  }
  void pro(){
    print(newContList);
    print(newDbList);
  }

  Future<void> readJson() async {
    DailCode().dailCode.forEach((element) {
      print(element['dial_code']!.replaceAll(' ', ''));
    });
  }

  List<NewtWorkModel> moveList = [];

  makeNetWorkSelect(int index){
    setState(() {
      netWorkLsit[index].isSelect = !netWorkLsit[index].isSelect;
    });
  }
  String otp = '';

  List<NetCatMo> networkCat = [
    NetCatMo(name: 'All', isSel: false),
    NetCatMo(name: 'Friends', isSel: false),
    NetCatMo(name: 'Family', isSel: false),
    NetCatMo(name: 'Work', isSel: false),
    NetCatMo(name: 'School', isSel: false),
    NetCatMo(name: 'Neigbour', isSel: false),
    NetCatMo(name: 'Others', isSel: false),
  ];

  makeCatSE(int idn){
    setState(() {
      networkCat[idn].isSel = !networkCat[idn].isSel;
    });
  }

  makeselect(int i){

    setState(() {
      for(var l in networkCat){
        l.isSel = false;
      }
      networkCat[i].isSel = true;
    });
  }
  List matchList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    getFirebaseContact();

  }
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<SignUpProvider>(context);
    final Stream<QuerySnapshot> documentStream = firestore.collection('recentChats').doc(pro.phone.toString()).collection('myChats').snapshots();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(logo,height: 100,width: 100,),
              const SizedBox(height: 10,),
              Container(
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),

                ),
                child: TabBar(
                  controller: _tabController,
                  // give the indicator a decoration (color and border radius)
                  indicator: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ),
                    // color: Colors.green,
                  ),
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.black,
                  onTap: (i) {
                    setState(() {
                      _tabController.index = i;
                    });
                    if (_tabController.index == 0) {
                    }
                    if (_tabController.index == 1) {

                    }
                    if (_tabController.index == 2) {

                    }
                  },
                  tabs: const [
                    // first tab [you can add an icon using the icon property]
                    Tab(
                      text: 'Chat',
                    ),
                    // second tab [you can add an icon using the icon property]
                    Tab(
                      text: 'Network',
                    ),
                    Tab(
                      text: 'Contacts',
                    ),
                  ],
                ),
              ),
              _tabController.index == 0 ? Container(
                child:  Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
        stream: documentStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.data == null){
            return Center(child: Text("No Messages"),);
          }else{
            return ListView(
              shrinkWrap: true,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(data['profileImage']),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(recieverName: data['recieverName'],profileImage: data['profileImage'],recieverPhone: data['recieverID'])));
                    },
                    title: Text(data['recieverName']),
                    subtitle: Text(data['lastMessage']),
                    trailing: Text(data['date']),
                  ),
                );
              }).toList(),
            );
          }
        },
      )
    ),
              ): _tabController.index == 1 ?  Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(networkCat.length, (index){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(networkCat[index].name),
                        );
                      }),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: moveList.isEmpty ?null: (){
                          showDialog(context: context, builder: (context){
                            return StatefulBuilder(
                              builder: (context,setState) {
                                return AlertDialog(
                                  title: const Text("Wher to Move"),
                                  content: Container(
                                    height: 200,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap:(){
                                                setState(() {
                                                  for(var l in networkCat){
                                                    l.isSel = false;
                                                  }
                                                  networkCat[0].isSel = true;
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                   child: Text(networkCat[0].name),
                                                  padding: const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(3),
                                                    color: networkCat[0].isSel ? Colors.blue: Colors.grey
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap:(){
                                                setState(() {
                                                  for(var l in networkCat){
                                                    l.isSel = false;
                                                  }
                                                  networkCat[1].isSel = true;
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                  child: Text(networkCat[1].name),
                                                  padding: const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(3),
                                                      color: networkCat[1].isSel ? Colors.blue: Colors.grey
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap:(){
                                                setState(() {
                                                  for(var l in networkCat){
                                                    l.isSel = false;
                                                  }
                                                  networkCat[2].isSel = true;
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                  child: Text(networkCat[2].name),
                                                  padding: const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(3),
                                                      color: networkCat[2].isSel ? Colors.blue: Colors.grey
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap:(){
                                                setState(() {
                                                  for(var l in networkCat){
                                                    l.isSel = false;
                                                  }
                                                  networkCat[3].isSel = true;
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                  child: Text(networkCat[3].name),
                                                  padding: const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(3),
                                                      color: networkCat[3].isSel ? Colors.blue: Colors.grey
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap:(){
                                                setState(() {
                                                  for(var l in networkCat){
                                                    l.isSel = false;
                                                  }
                                                  networkCat[4].isSel = true;
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                  child: Text(networkCat[4].name),
                                                  padding: const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(3),
                                                      color: networkCat[4].isSel ? Colors.blue: Colors.grey
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap:(){
                                                setState(() {
                                                  for(var l in networkCat){
                                                    l.isSel = false;
                                                  }
                                                  networkCat[5].isSel = true;
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                  child: Text(networkCat[5].name),
                                                  padding: const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(3),
                                                      color: networkCat[5].isSel ? Colors.blue: Colors.grey
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap:(){
                                                setState(() {
                                                  for(var l in networkCat){
                                                    l.isSel = false;
                                                  }
                                                  networkCat[6].isSel = true;
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                  child: Text(networkCat[6].name),
                                                  padding: const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(3),
                                                      color: networkCat[6].isSel ? Colors.blue: Colors.grey
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    CupertinoButton(child: Text("Back"), onPressed: ()=> Navigator.pop(context)),
                                    CupertinoButton(child: Text("Move"), onPressed: ()=> Navigator.pop(context)),
                                  ],
                                );
                              }
                            );
                          });
                        },
                        child: Text("Move"),
                      ),
                      TextButton(
                        onPressed:(){},
                        child: Text(moveList.isEmpty ? "Select" :"Deselect"),
                      )
                    ],
                  ),
                  alPhabat("Friends"),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: netWorkLsit.length,
                    itemBuilder: (contxt,i){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(netWorkLsit[i].photo),
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(netWorkLsit[i].name,style: TextStyle(fontSize: 18),),
                                    Text(netWorkLsit[i].phone),
                                  ],
                                ),
                              ],
                            ),
                            Checkbox(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                value: netWorkLsit[i].isSelect, onChanged: (val){
                              makeNetWorkSelect(i);
                              if(netWorkLsit[i].isSelect == true){
                                setState(() {
                                  moveList.add(NewtWorkModel(
                                      name: netWorkLsit[i].name,
                                      phone: netWorkLsit[i].phone,
                                      photo: netWorkLsit[i].photo,
                                      isSelect: netWorkLsit[i].isSelect));
                                });
                              }else{

                              }
                              print(moveList);
                            })
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ):
              SingleChildScrollView(
                child: Column(
                  children: [
                    matchList.contains('a') ? alPhabat('A') :Container(),
                    getConList('a'),
                    matchList.contains('b') ? alPhabat('B') :Container(),
                    getConList('b'),
                    matchList.contains('c') ? alPhabat('C') :Container(),
                    getConList('c'),
                    matchList.contains('d') ? alPhabat('D') :Container(),
                    getConList('d'),
                    matchList.contains('e') ? alPhabat('E') :Container(),
                    getConList('e'),
                    matchList.contains('f') ? alPhabat('F') :Container(),
                    getConList('f'),
                    matchList.contains('g') ? alPhabat('G') :Container(),
                    getConList('g'),
                    matchList.contains('h') ? alPhabat('H') :Container(),
                    getConList('h'),
                    matchList.contains('i') ? alPhabat('I') :Container(),
                    getConList('i'),
                    matchList.contains('j') ? alPhabat('J') :Container(),
                    getConList('j'),
                    matchList.contains('k') ? alPhabat('K') :Container(),
                    getConList('k'),
                    matchList.contains('l') ? alPhabat('L') :Container(),
                    getConList('l'),
                    matchList.contains('m') ? alPhabat('M') :Container(),
                    getConList('m'),
                    matchList.contains('n') ? alPhabat('N') :Container(),
                    getConList('n'),
                    matchList.contains('o') ? alPhabat('O') :Container(),
                    getConList('o'),
                    matchList.contains('p') ? alPhabat('P') :Container(),
                    getConList('p'),
                    matchList.contains('q') ? alPhabat('Q') :Container(),
                    getConList('q'),
                    matchList.contains('r') ? alPhabat('R') :Container(),
                    getConList('r'),
                    matchList.contains('s') ? alPhabat('S') :Container(),
                    getConList('s'),
                    matchList.contains('t') ? alPhabat('T') :Container(),
                    getConList('t'),
                    matchList.contains('u') ? alPhabat('U') :Container(),
                    getConList('u'),
                    matchList.contains('v') ? alPhabat('V') :Container(),
                    getConList('v'),
                    matchList.contains('w') ? alPhabat('W') :Container(),
                    getConList('w'),
                    matchList.contains('x') ? alPhabat('X') :Container(),
                    getConList('x'),
                    matchList.contains('y') ? alPhabat('Y') :Container(),
                    getConList('y'),
                    matchList.contains('z') ? alPhabat('Z') :Container(),
                    getConList('z'),

                  ],
                ),
              )
            ],
          ),
        ),
    )
    );
  }
  Widget getConList(String alph){
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: nameCont.length,
      itemBuilder: (contxt,i){
        print(nameCont[i]);
        matchList.add(nameCont[i].name.substring(0,1).toLowerCase());
        if(nameCont[i].name.startsWith(alph.toLowerCase(),0) || nameCont[i].name.startsWith(alph.toUpperCase(),0)){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person),
                    ),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(nameCont[i].name,style: TextStyle(fontSize: 18),),
                        Text(nameCont[i].phone),
                      ],
                    ),
                  ],
                ),
                InkWell(
                  onTap: (){
                    pro();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue,
                    ),
                    child: Text("Invite",style: TextStyle(color: Colors.white),),
                  ),
                )
              ],
            ),
          );
        }
        else{
          return Container();
        }
      },
    );
  }
}
Widget alPhabat(String name){
  return Container(
    padding: const EdgeInsets.all(8),
    // height: 20,
    width: double.infinity,
    color: Colors.white,
    child:  Center(child: Text(name,style: const TextStyle(color: Colors.blue ,fontSize: 18,fontWeight: FontWeight.w500),)),
  );
}

class ContModel{
  String name;
  String phone;

  ContModel({required this.name,required this.phone});
}

class NewtWorkModel {
  String photo;
  String name;
  String phone;
  bool isSelect;
  NewtWorkModel({required this.name,required this.phone,required this.photo,required this.isSelect});
}
class NetCatMo{
  String name;
  bool isSel;
  NetCatMo({required this.name,required this.isSel});
}