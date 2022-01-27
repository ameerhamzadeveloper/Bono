import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/provider/feeds_provider.dart';
import 'package:bono_gifts/routes/routes_names.dart';
import 'package:bono_gifts/views/chat/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class Feeds extends StatefulWidget {
  @override
  _FeedsState createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> {

  @override
  void initState() {
    super.initState();
    final pro = Provider.of<FeedsProvider>(context,listen: false);
    pro.getFeedsPosts();
  }
  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<FeedsProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: lightBlue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RotatedBox(
                    quarterTurns: 4,
                    child: Image.asset(butteryFly,height: 30,),
                  ),
                  RotatedBox(
                    quarterTurns: 4,
                    child: Image.asset(butteryFly,height: 50,),
                  ),
                  RotatedBox(
                    quarterTurns: 4,
                    child: Image.asset(logo,height: 80,),
                  ),
                  RotatedBox(
                    quarterTurns: 4,
                    child: Image.asset(butteryFly,height: 50,),
                  ),
                  RotatedBox(
                    quarterTurns: 4,
                    child: Image.asset(butteryFly,height: 30,),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: ()=> Navigator.pushNamed(context, addPOst),
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    RotatedBox(
                      quarterTurns: 4,
                      child: Image.asset(addBtn,height: 30,),
                    ),
                    const SizedBox(width: 10,),
                    const Text("Post a celebration or event",style: TextStyle(fontSize: 20),)
                  ],
                ),
              ),
            ),
            pro.feeds.isEmpty ? Center(child: CircularProgressIndicator(),):
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: pro.feeds.length,
                  itemBuilder: (ctx,i){
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          color:lightBlue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                  pro.feeds[i].profileName,
                              ),
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(
                                  pro.feeds[i].profileImage
                                ),
                              ),
                              // SizedBox(
                              //   height: 7,
                              // ),
                              Text(
                                pro.feeds[i].date.toString(),
                                style: TextStyle(color: Colors.black,fontSize: 12),
                              ),

                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: MediaQuery.of(context).size.width / 3,),
                            Expanded(child: Text(pro.feeds[i].title)),
                            TextButton(onPressed: (){pro.openDescription(i);}, child: Text(pro.feeds[i].isDesOpen ? "Read Less":"Read More"))
                          ],
                        ),
                        pro.feeds[i].isDesOpen ? Text(
                          pro.feeds[i].description.toString(),
                          style: TextStyle(color: Colors.black,fontSize: 12),
                        ):Container(),
                        SizedBox(height: 5,),
                        Stack(
                          children: [
                            Image.network(pro.feeds[i].image,width: getWidth(context),fit: BoxFit.cover,),
                            Positioned(
                              bottom:0,
                              right:0,
                              // alignment: Alignment.bottomRight,
                              child: Container(
                                // color:Colors.black.withOpacity(0.2),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const SizedBox(height: 10,),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: (){},
                                        child: Column(
                                          children: [
                                            Image.asset(sharedIcon,height: 40,width: 40,),
                                            Text("0",style: TextStyle(color: Colors.white),)
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(onTap: (){
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context, builder: (contxt){
                                          return SafeArea(
                                            child: Container(
                                              color: Colors.transparent,
                                              child: Container(
                                                decoration:  const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:  BorderRadius.only(
                                                        topLeft:  Radius.circular(10.0),
                                                        topRight:  Radius.circular(10.0))),

                                                height: MediaQuery.of(context).size.height,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        const SizedBox(height: 20,),
                                                        const Divider(),
                                                        StreamBuilder(
                                                          stream: pro.colRef.doc(pro.feeds[i].docid).collection('comments').snapshots(),
                                                          builder: (context,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
                                                            if(snapshot.connectionState == ConnectionState.waiting){
                                                              return Center(child: CircularProgressIndicator(),);
                                                            }else if(snapshot.hasData){
                                                              List<DocumentSnapshot> docs = snapshot.data!.docs;
                                                              return ListView.builder(
                                                                physics: const NeverScrollableScrollPhysics(),
                                                                itemCount: docs.length,
                                                                shrinkWrap: true,
                                                                itemBuilder: (context,i){
                                                                  return Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Container(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      decoration: BoxDecoration(
                                                                          color: Colors.grey.withOpacity(0.4),
                                                                          borderRadius: const BorderRadius.only(
                                                                            topLeft: Radius.circular(20),
                                                                            topRight: Radius.circular(20),
                                                                            bottomRight: Radius.circular(20),
                                                                          )
                                                                      ),
                                                                      child: Row(
                                                                        children: [
                                                                          Column(
                                                                            children: [
                                                                              CircleAvatar(
                                                                                backgroundImage: NetworkImage(docs[i]['image']),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          const SizedBox(width: 10,),
                                                                          Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(docs[i]['name']),
                                                                              Text(docs[i]['text']),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            }else{
                                                              return const Center(child: Text("No Commnets"),);
                                                            }
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(30),
                                                            color: Colors.grey.withOpacity(0.4)
                                                        ),
                                                        padding: const EdgeInsets.only(left:3.0,right: 3.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            const SizedBox(width: 10,),
                                                             Expanded(
                                                              child: TextField(
                                                                onChanged: (val){
                                                                  pro.setCommentText(val);
                                                                },
                                                                controller: pro.commnetController,
                                                                decoration: const InputDecoration(
                                                                  hintText: "Write a comment...",
                                                                  border: InputBorder.none,
                                                                ),
                                                              ),
                                                            ),
                                                            IconButton(onPressed: (){
                                                              pro.addComment(pro.feeds[i].docid, context);
                                                            }, icon: const Icon(Icons.send))
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                      },
                                      child:  Column(
                                        children: [
                                          Image.asset(commentIcon,height: 40,width: 40,),
                                          Text("0",style: TextStyle(color: Colors.white),)
                                        ],
                                      )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(recieverName: pro.feeds[i].profileName,profileImage: pro.feeds[i].profileImage,recieverPhone:pro.feeds[i].phone)));
                                      }, child:  Column(
                                        children: [
                                          Image.asset(chatIconNew,height: 40,width: 40,),
                                          Text("0",style: TextStyle(color: Colors.white),)
                                        ],
                                      ),),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: (){},
                                        child: Column(
                                          children: [
                                            Image.asset(giftICon,height: 40,width: 40,),
                                            Text("0",style: TextStyle(color: Colors.white),)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    );
                  },
                )
          ],
        ),
      ),
    );
  }
}
