import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/provider/buy_provider.dart';
import 'package:bono_gifts/views/buy/select_network.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
class BuyPage extends StatefulWidget {
  const BuyPage({Key? key}) : super(key: key);

  @override
  _BuyPageState createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final pro = Provider.of<BuyProvider>(context,listen: false);
  }
  @override
  Widget build(BuildContext context) {
    var form = DateFormat('dd-MMM');
    final pro = Provider.of<BuyProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Center(child: Text("Buy Gifts",style: TextStyle(fontSize: 20),)),
            const SizedBox(height: 10,),
            pro.userName != null ? Container(
              padding: const EdgeInsets.only(top:25,bottom: 25,left: 15,right: 15),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("To"),
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(pro.userImage!),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pro.userName!,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w400),),
                      Text("Birthday ${form.format(pro.userDob!).toString()} (In ${pro.diffDays} Days)",style: TextStyle(color: Colors.blue),),
                    ],
                  ),
                  IconButton(onPressed: (){}, icon: Icon(Icons.clear))
                ],
              ),
            ):
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SelectNetwokr()));
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top:25,bottom: 25,left: 15,right: 15),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(child: Text("To")),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("add a recepient",style: TextStyle(fontSize: 20),),
                        const SizedBox(width: 10,),
                        RotatedBox(
                          quarterTurns: 4,
                          child: Image.asset(addBtn,height: 30,),
                        ),
                      ],
                    ),
                    Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
