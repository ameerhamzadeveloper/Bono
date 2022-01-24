import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/provider/chat_provider.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/views/chat/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hexagon/hexagon.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat>  with TickerProviderStateMixin{
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    final pro = Provider.of<ChatProvider>(context,listen: false);
    pro.getContacts();
  }
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<SignUpProvider>(context);
    final chatPro = Provider.of<ChatProvider>(context);
    final Stream<QuerySnapshot> documentStream = firestore.collection('recentChats').doc(pro.phone.toString()).collection('myChats').snapshots();
    return Scaffold(
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
            _tabController.index == 0 ? StreamBuilder(
              stream: documentStream,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(snapshot.data == null){
                  return Center(child: Text("No Message"),);
                }else if(snapshot.data!.docs.length > 0){
                  return ListView(
                    shrinkWrap: true,
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => ChatScreen(profileImage: data['profileImage'],recieverName: data['recieverName'],recieverPhone: data['recieverID'],)
                            ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)
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
                                    onPressed: (c){},
                                    backgroundColor: Colors.grey,
                                    foregroundColor: Colors.white,
                                    icon: Icons.list,
                                    label: 'Archive',
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
                                  subtitle: Text(data['lastMessage']),
                                       trailing: Text(data['date']),
                                  title: Text(data['recieverName'])),
                            ),
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
            ): _tabController.index == 1 ?  Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(chatPro.networkCat.length, (index){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(chatPro.networkCat[index].name),
                      );
                    }),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: chatPro.moveList.isEmpty ?null: (){
                        showDialog(context: context, builder: (context){
                          return StatefulBuilder(
                            builder: (context,setState) {
                              return AlertDialog(
                                title: const Text("Wher to Move"),
                                content: SizedBox(
                                  height: 200,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap:()=>chatPro.makeCatSelect(0),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                 child: Text(chatPro.networkCat[0].name),
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(3),
                                                  color: chatPro.networkCat[0].isSel ? Colors.blue: Colors.grey
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap:()=>chatPro.makeCatSelect(1),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                child: Text(chatPro.networkCat[1].name),
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(3),
                                                    color: chatPro.networkCat[1].isSel ? Colors.blue: Colors.grey
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap:()=>chatPro.makeCatSelect(2),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                child: Text(chatPro.networkCat[2].name),
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(3),
                                                    color: chatPro.networkCat[2].isSel ? Colors.blue: Colors.grey
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap:()=>chatPro.makeCatSelect(3),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                child: Text(chatPro.networkCat[3].name),
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(3),
                                                    color: chatPro.networkCat[3].isSel ? Colors.blue: Colors.grey
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap:()=>chatPro.makeCatSelect(4),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                child: Text(chatPro.networkCat[4].name),
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(3),
                                                    color: chatPro.networkCat[4].isSel ? Colors.blue: Colors.grey
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap:()=>chatPro.makeCatSelect(5),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                child: Text(chatPro.networkCat[5].name),
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(3),
                                                    color: chatPro.networkCat[5].isSel ? Colors.blue: Colors.grey
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap:()=>chatPro.makeCatSelect(6),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                child: Text(chatPro.networkCat[6].name),
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(3),
                                                    color: chatPro.networkCat[6].isSel ? Colors.blue: Colors.grey
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
                                  CupertinoButton(child: const Text("Back"), onPressed: ()=> Navigator.pop(context)),
                                  CupertinoButton(child: const Text("Move"), onPressed: ()=> Navigator.pop(context)),
                                ],
                              );
                            }
                          );
                        });
                      },
                      child: const Text("Move"),
                    ),
                    TextButton(
                      onPressed:(){},
                      child: Text(chatPro.moveList.isEmpty ? "Select" :"Deselect"),
                    )
                  ],
                ),
                alPhabat("Friends"),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: chatPro.netWorkLsit.length,
                  itemBuilder: (contxt,i){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(chatPro.netWorkLsit[i].photo),
                              ),
                              const SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(chatPro.netWorkLsit[i].name,style: const TextStyle(fontSize: 18),),
                                  Text(chatPro.netWorkLsit[i].phone),
                                ],
                              ),
                            ],
                          ),
                          Checkbox(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                              value: chatPro.netWorkLsit[i].isSelect, onChanged: (val){
                            chatPro.checkBoxSelect(i);
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
                  chatPro.matchList.contains('a') ? alPhabat('A') :Container(),
                  getConList('a',chatPro),
                  chatPro.matchList.contains('b') ? alPhabat('B') :Container(),
                  getConList('b',chatPro),
                  chatPro.matchList.contains('c') ? alPhabat('C') :Container(),
                  getConList('c',chatPro),
                  chatPro.matchList.contains('d') ? alPhabat('D') :Container(),
                  getConList('d',chatPro),
                  chatPro.matchList.contains('e') ? alPhabat('E') :Container(),
                  getConList('e',chatPro),
                  chatPro.matchList.contains('f') ? alPhabat('F') :Container(),
                  getConList('f',chatPro),
                  chatPro.matchList.contains('g') ? alPhabat('G') :Container(),
                  getConList('g',chatPro),
                  chatPro.matchList.contains('h') ? alPhabat('H') :Container(),
                  getConList('h',chatPro),
                  chatPro.matchList.contains('i') ? alPhabat('I') :Container(),
                  getConList('i',chatPro),
                  chatPro.matchList.contains('j') ? alPhabat('J') :Container(),
                  getConList('j',chatPro),
                  chatPro.matchList.contains('k') ? alPhabat('K') :Container(),
                  getConList('k',chatPro),
                  chatPro.matchList.contains('l') ? alPhabat('L') :Container(),
                  getConList('l',chatPro),
                  chatPro.matchList.contains('m') ? alPhabat('M') :Container(),
                  getConList('m',chatPro),
                  chatPro.matchList.contains('n') ? alPhabat('N') :Container(),
                  getConList('n',chatPro),
                  chatPro.matchList.contains('o') ? alPhabat('O') :Container(),
                  getConList('o',chatPro),
                  chatPro.matchList.contains('p') ? alPhabat('P') :Container(),
                  getConList('p',chatPro),
                  chatPro.matchList.contains('q') ? alPhabat('Q') :Container(),
                  getConList('q',chatPro),
                  chatPro.matchList.contains('r') ? alPhabat('R') :Container(),
                  getConList('r',chatPro),
                  chatPro.matchList.contains('s') ? alPhabat('S') :Container(),
                  getConList('s',chatPro),
                  chatPro.matchList.contains('t') ? alPhabat('T') :Container(),
                  getConList('t',chatPro),
                  chatPro.matchList.contains('u') ? alPhabat('U') :Container(),
                  getConList('u',chatPro),
                  chatPro.matchList.contains('v') ? alPhabat('V') :Container(),
                  getConList('v',chatPro),
                  chatPro.matchList.contains('w') ? alPhabat('W') :Container(),
                  getConList('w',chatPro),
                  chatPro.matchList.contains('x') ? alPhabat('X') :Container(),
                  getConList('x',chatPro),
                  chatPro.matchList.contains('y') ? alPhabat('Y') :Container(),
                  getConList('y',chatPro),
                  chatPro.matchList.contains('z') ? alPhabat('Z') :Container(),
                  getConList('z',chatPro),

                ],
              ),
            )
          ],
        ),
      )
    );
  }
  Widget getConList(String alph,ChatProvider chatPro){
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: chatPro.nameCont.length,
      itemBuilder: (contxt,i){
        chatPro.addFirstChar(chatPro.nameCont[i].name.substring(0,1).toLowerCase());
        if(chatPro.nameCont[i].name.startsWith(alph.toLowerCase(),0) || chatPro.nameCont[i].name.startsWith(alph.toUpperCase(),0)){
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
                    const SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(chatPro.nameCont[i].name,style: const TextStyle(fontSize: 18),),
                        Text(chatPro.nameCont[i].phone),
                      ],
                    ),
                  ],
                ),
                InkWell(
                  onTap: (){

                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue,
                    ),
                    child: const Text("Invite",style: TextStyle(color: Colors.white),),
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




