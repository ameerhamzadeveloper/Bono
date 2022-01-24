 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String recieverName;
  final String profileImage;
  final String recieverPhone;

  ChatScreen({required this.recieverName,required this.profileImage,required this.recieverPhone});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  DateTime date = DateTime.now();
   FirebaseFirestore firestore = FirebaseFirestore.instance;
   TextEditingController message = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<SignUpProvider>(context);
    final Stream<QuerySnapshot> documentStream = firestore.collection('chats').doc(pro.phone.toString()).collection(widget.recieverPhone).orderBy('timestamp').snapshots();
    return Scaffold(
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0,0.2),
                  blurRadius: 3,
                  spreadRadius: 2
                )
              ]
            ),
            padding: const EdgeInsets.all(8),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(widget.profileImage),
                          )
                        ],
                      ),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.recieverName,style: TextStyle(fontSize: 18),),
                          Row(
                            children: [
                              Icon(Icons.circle,color: Colors.green,size: 10,),
                              Text("Online"),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  Row(children:[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                        children: [
                          Icon(Icons.motorcycle_rounded),
                          Text("35 min")
                        ],
                  ),

                      ],
                    ),
                    SizedBox(width: 10,),
                  Column(
                    children: [
                      Icon(Icons.more_horiz),
                      Image.asset("assets/images/icons/product_icon.png",height: 20,width: 20,)
                    ],
                  )
                ],
              ),])
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: documentStream,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(snapshot.data == null){
                  return Container();
                }else{
                  return ListView(
                    // physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                      return Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment:
                          data['senderID'] == pro.phone ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: <Widget>[
                            Material(
                              borderRadius: data['senderID'] == pro.phone
                                  ? const BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  bottomLeft: Radius.circular(30.0),
                                  bottomRight: Radius.circular(30.0))
                                  : const BorderRadius.only(
                                bottomLeft: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                              ),
                              elevation: 5.0,
                              color: data['senderID'] == pro.phone ? Colors.lightBlueAccent : Colors.grey,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                child: Text(
                                  data['message'],
                                  style: TextStyle(
                                    color: data['senderID'] == pro.phone ? Colors.white : Colors.black54,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
          Container(
            color: Colors.grey[300],
            child: Center(
              child: Row(
                children: [
                  IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.camera_alt),
                  ),
                  Expanded(child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      height: 45,

                      child: Center(
                        child: TextField(
                          controller: message,
                          decoration:  InputDecoration(
                              border: InputBorder.none,
                              hintText: "Type Your Message",
                            suffixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.star,color: Colors.lightBlueAccent,)),
                            // prefix: IconButton(onPressed: (){}, icon: Icon(Icons.star,color: Colors.lightBlueAccent,)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ),
                  IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.mic),
                  ),
                 MaterialButton(
                   minWidth: 20,
                   onPressed: (){
                     firestore.collection('chats').doc(pro.phone.toString()).collection(widget.recieverPhone).add({
                       'message':message.text,
                       'date': "${date.year}/${date.month}/${date.day}",
                       'timestamp':DateTime.now(),
                       'recieverID':widget.recieverPhone,
                       'senderID':pro.phone,
                       'profileImage':pro.userImage,
                     });
                     firestore.collection('chats').doc(widget.recieverPhone).collection(pro.phone.toString()).add({
                       'message':message.text,
                       'date': "${date.year}/${date.month}/${date.day}",
                       'timestamp':DateTime.now(),
                       'recieverID':widget.recieverPhone,
                       'senderID':pro.phone,
                       'profileImage':pro.userImage,
                     });
                     firestore.collection('recentChats').doc(widget.recieverPhone).collection('myChats').doc(pro.phone).set({
                       'lastMessage':message.text,
                       'date': "${date.year}/${date.month}/${date.day}",
                       'timestamp':DateTime.now(),
                       'recieverID':widget.recieverPhone,
                       'senderID':pro.phone,
                       'recieverName':pro.name,
                       'profileImage':pro.userImage,
                       // 'token': widget.fcmToken,
                     });
                     firestore.collection('recentChats').doc(pro.phone.toString()).collection('myChats').doc(widget.recieverPhone).set({
                       'lastMessage':message.text,
                       'date': "${date.year}/${date.month}/${date.day}",
                       'timestamp':DateTime.now(),
                       'recieverID':widget.recieverPhone,
                       'senderID':pro.phone,
                       'recieverName':widget.recieverName,
                       'profileImage':widget.profileImage,
                       // 'token':widget.fcmToken,
                     });
                     message.clear();
                   },
                   child: Image.asset("assets/images/icons/arrow_icon.png",height: 20,width: 20,),
                 )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}