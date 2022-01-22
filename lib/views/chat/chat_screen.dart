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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: false,
        title: Text(widget.recieverName.toString(),style: TextStyle(color: Colors.black),),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     pro.joinAudioMeeting();
          //   },
          //   icon: Icon(Icons.call, color: Colors.black,),
          // ),
          // IconButton(
          //   onPressed: () {
          //     pro.joinVideoMeeting();
          //   },
          //   icon: Icon(Icons.videocam_outlined, color: Colors.black,),
          // )
        ],
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
                                  ? BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  bottomLeft: Radius.circular(30.0),
                                  bottomRight: Radius.circular(30.0))
                                  : BorderRadius.only(
                                bottomLeft: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                              ),
                              elevation: 5.0,
                              color: data['senderID'] == pro.phone ? Colors.lightBlueAccent : Colors.grey,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
          Padding(
            padding: const EdgeInsets.only(left: 8.0,bottom: 10),
            child: Column(
              children: [
                Container(
                  height: 2,
                  color: Colors.grey,
                ),
                Row(
                  children: [
                    Expanded(child: TextField(
                      controller: message,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type Your Message"
                      ),
                    ),
                    ),
                    IconButton(onPressed: () {
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
                    }, icon: Icon(Icons.send))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}