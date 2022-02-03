import 'package:bono_gifts/provider/buy_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
class OrderSummry extends StatefulWidget {
  const OrderSummry({Key? key}) : super(key: key);

  @override
  _OrderSummryState createState() => _OrderSummryState();
}

class _OrderSummryState extends State<OrderSummry> {
  @override
  Widget build(BuildContext context) {
    var form = DateFormat('dd-MMM');
    final pro = Provider.of<BuyProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Center(child: Text("Buy Gifts",style: TextStyle(fontSize: 20),)),
              const SizedBox(height: 10,),
              Container(
                padding: const EdgeInsets.only(top:25,bottom: 25,left: 15,right: 15),
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text("To"),
                    CircleAvatar(radius: 25, backgroundImage: NetworkImage(pro.userImage!),),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pro.userName!,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w400),),
                        Text("Birthday ${form.format(pro.userDob!).toString()} (In ${pro.diffDays} Days)",style: TextStyle(color: Colors.blue),),
                      ],
                    ),
                    IconButton(onPressed: (){}, icon: const Icon(Icons.clear,color: Colors.white,))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
