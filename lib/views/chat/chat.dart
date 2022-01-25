import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/helper/country_code_without_plus.dart';
import 'package:bono_gifts/helper/helper.dart';
import 'package:bono_gifts/provider/chat_provider.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/services/chat_service.dart';
import 'package:bono_gifts/views/chat/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
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
    Future.delayed(const Duration(seconds: 2),(){
      fetchNewtrork();
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

  List<NewtWorkModel> netWorkLsit = [];
  final service = ChatService();

  fetchNewtrork(){
    for (var i = 0; i < contactList.length; i++) {
      service.fetchSearch1(contactList, i, 'searchPhone1').then((value) {
        for (var d = 0; d < value.docs.length; d++) {
          print(value.docs[d]['name']);
          if(!netWorkLsit.contains(value.docs[d]['phone'])) {
          setState(() {
            netWorkLsit.add(NewtWorkModel(
                name: value.docs[d]['name'],
                phone: value.docs[d]['phone'],
                photo: value.docs[d]['profile_url'],
                isSelect: false));
          });
        }
        }
      });
      service.fetchSearch1(contactList, i, 'phone').then((value) {
        for (var d = 0; d < value.docs.length; d++) {
          print(value.docs[d]['name']);
          if(!netWorkLsit.contains(value.docs[d]['phone'])) {
          setState(() {
            netWorkLsit.add(NewtWorkModel(
                name: value.docs[d]['name'],
                phone: value.docs[d]['phone'],
                photo: value.docs[d]['profile_url'],
                isSelect: false));
          });
        }}
      });
      service.fetchSearch1(contactList, i, 'searchPhone').then((value) {
        for (var d = 0; d < value.docs.length; d++) {
          print(value.docs[d]['name']);
          if(!netWorkLsit.contains(value.docs[d]['phone'])) {
         setState(() {
           netWorkLsit.add(NewtWorkModel(
               name: value.docs[d]['name'],
               phone: value.docs[d]['phone'],
               photo: value.docs[d]['profile_url'],
               isSelect: false));
         });
        }}
      });
    }
    Future.delayed(Duration(seconds: 2),(){
      removeDuplicate();
    });
  }

  removeDuplicate(){
   setState(() {
     netWorkLsit.toSet().toList();
   });
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
    getContacts();

  }
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<SignUpProvider>(context);
    final Stream<QuerySnapshot> documentStream = firestore.collection('recentChats').doc(pro.phone.toString()).collection('myChats').orderBy('timestamp').snapshots();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(logo,height: 70,width: 70,),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
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
            ),
            _tabController.index == 0 ? Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: StreamBuilder(
                stream: documentStream,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.data == null){
                    return Center(child: Text("No Message"),);
                  }else if(snapshot.data!.docs.length > 0){
                    return ListView(
                      shrinkWrap: true,
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                        return InkWell(
                          onTap: (){
                            print(data['recieverName']);
                            print(data['recieverID']);

                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => ChatScreen(profileImage: data['profileImage'],recieverName: data['recieverName'],recieverPhone: data['recieverID'] == pro.phone ? data['senderID'] : data['recieverID'],)
                            ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(top: BorderSide(color: Colors.grey),bottom: data.length == data.length ? BorderSide(color: Colors.grey):BorderSide.none)
                            ),
                            child: Slidable(
                              // Specify a key if the Slidable is dismissible.
                              key: const ValueKey(0),

                              startActionPane: ActionPane(
                                motion: const ScrollMotion(),

                                dismissible: DismissiblePane(onDismissed: () {}),

                                children:  [

                                ],
                              ),

                              // The end action pane is the one at the right or the bottom side.
                              endActionPane: ActionPane(
                                motion: ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    // An action can be bigger than the others.
                                    flex: 2,
                                    onPressed: (c){
                                      print(data['isSeen']);
                                    },
                                    backgroundColor: Colors.grey,
                                    foregroundColor: Colors.white,
                                    icon: Icons.list,
                                    label: 'More',
                                  ),
                                  SlidableAction(
                                    onPressed: (c){},
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    icon: Icons.shopping_basket,
                                    label: 'Send',
                                  ),
                                ],
                              ),

                              // The child of the Slidable is what the user sees when the
                              // component is not dragged.
                              child: ListTile(
                                // leading: HexagonWidget.flat(
                                //   width: 20,
                                //   height: 20,
                                //   color: Colors.limeAccent,
                                //   // padding: 4.0,
                                //   child: Text("io"),
                                // ),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(data['profileImage']),
                                  ),
                                  subtitle: data['messageType'] == 'image' ? Row(
                                    children: [
                                      Icon(Icons.insert_photo_rounded,color: Colors.grey,),
                                      Text("Image")
                                    ],
                                  ):Text(data['lastMessage'].toString().length > 10 ?  "${data['lastMessage'].toString().substring(0,10)}..." : data['lastMessage']),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(data['date']),
                                      const SizedBox(height: 4,),
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 10,
                                        child: Center(child: data['isSendMe'] == true ? data['isSeen'] == true ? Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.check,size: 10,),
                                            Icon(Icons.check,size: 10,),
                                          ],
                                        ): Icon(Icons.check,size: 10,): Text(data['count'],style: TextStyle(fontSize: 9),)),
                                      )
                                    ],
                                  ),
                                  title: Text(data['recieverName'])),
                            ),
                          ),
                        );}).toList(),
                    );
                  }else{
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: getHeight(context) / 5,),
                          Text("Invite your friends",style: TextStyle(fontSize: 22),),
                          SizedBox(height:20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal:15.0),
                            child: Text("Seems your contacts don't have Bono yet Use the button below to invite your friends to Bono",textAlign: TextAlign.center,),
                          ),
                          SizedBox(height:20),
                          MaterialButton(
                            minWidth: getWidth(context),
                            color:Colors.blue,
                            onPressed: (){
                              Share.share("Hi, Iam using Bono messaging app. it let's you surprise your friends with real gifts!. Let's chat there :)....,click the link below to download it\n www.gitbono.com");
                            },
                            child: Text("Inivte a friend",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 18),),
                          ),
                          // SizedBox(height: getHeight(context) / 3,),
                        ],
                      ),
                    );
                  }
                },
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
                  itemCount: netWorkLsit.toSet().toList().length,
                  itemBuilder: (contxt,i){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(netWorkLsit.toSet().toList()[i].photo),
                              ),
                              SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(netWorkLsit.toSet().toList()[i].name,style: TextStyle(fontSize: 18),),
                                  Text(netWorkLsit.toSet().toList()[i].phone),
                                ],
                              ),
                            ],
                          ),
                          Checkbox(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                              value: netWorkLsit.toSet().toList()[i].isSelect, onChanged: (val){
                            makeNetWorkSelect(i);
                            if(netWorkLsit.toSet().toList()[i].isSelect == true){
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