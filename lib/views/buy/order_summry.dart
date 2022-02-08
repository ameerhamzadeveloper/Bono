import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/provider/buy_provider.dart';
import 'package:bono_gifts/provider/wcmp_provider.dart';
import 'package:bono_gifts/views/buy/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
enum DurationVal { first, second, third }
class OrderSummry extends StatefulWidget {
  const OrderSummry({Key? key}) : super(key: key);

  @override
  _OrderSummryState createState() => _OrderSummryState();
}

class _OrderSummryState extends State<OrderSummry> {
  DurationVal? _duration = DurationVal.first;
  var formtr = DateFormat('MMM');
  @override
  Widget build(BuildContext context) {
    var form = DateFormat('dd-MMM');
    final pro = Provider.of<BuyProvider>(context);
    final pror = Provider.of<WooCommerceMarketPlaceProvider>(context);
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
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Image.network(pror.image!,height: 100,width: 100,)
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pror.name!,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500),),
                        Text("Size : ${pror.size}"),
                        Text("Quanotity : 1"),
                        Text("Price : \$${pror.price}"),
                        Text("Total : \$${pror.price}",style: TextStyle(fontWeight: FontWeight.bold),)
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Text("What you would like to be writenon the cake"),
              SizedBox(height: 30,),
              Row(
                children: [
                  Text("Pick a delivery date",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500),),
                ],
              ),
              Container(
                // color: Colors.white,
                child: Column(
                  children: [
                    ListTile(
                      title: Text("As soon as possible (10\$ Delivery)"),
                      trailing: Radio<DurationVal>(
                        // fillColor: Color(0xff17B5AF),
                        activeColor: Color(0xff17B5AF),
                        onChanged: (val){
                          setState(() {
                            _duration = DurationVal.first;
                          });
                        },
                        value: DurationVal.first,
                        groupValue: _duration,
                      ),
                    ),

                    ListTile(
                      title: Text("On his birthday (7\$ Delivery)"),
                      trailing: Radio<DurationVal>(
                        activeColor: Color(0xff17B5AF),
                        onChanged: (val){
                          setState(() {
                            _duration = DurationVal.second;
                          });
                        },
                        value: DurationVal.second,
                        groupValue: _duration,
                      ),
                    ),

                    ListTile(
                      title: Text("Or Select date"),
                      trailing: Radio<DurationVal>(
                        activeColor: Color(0xff17B5AF),
                        onChanged: (val){
                          setState(() {
                            _duration = DurationVal.third;
                          });
                        },
                        value: DurationVal.third,
                        groupValue: _duration,
                      ),
                    ),
                    _duration == DurationVal.third ? InkWell(
                      onTap: (){
                        DatePicker.showPicker(
                          context,
                          showTitleActions: true,
                          // minTime: DateTime(1950, 3, 5),
                          // maxTime: DateTime.now(),
                          onChanged: (date) {
                            var formt = DateFormat('dd-MMM-yyyy');


                            pror.setDOB(formt.format(date).toString(),date);
                          }, onConfirm: (date) {

                        },);
                        // currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                      child: Container(
                          padding: const EdgeInsets.all(18),
                          width: getWidth(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all()
                                ),
                                child: Center(
                                  child: Text(pror.dob != null ? pror.dob!.substring(7,11) :pror.todayDate.year.toString()),
                                ),
                              ),
                              SizedBox(width: 10,),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all()
                                ),
                                child: Center(
                                  child: Text(pror.dob != null ? pror.dob!.substring(3,6) :formtr.format(pror.todayDate).toString()),
                                ),
                              ),
                              SizedBox(width: 10,),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all()
                                ),
                                child: Center(
                                  child: Text(pror.dob != null ? pror.dob!.substring(0,2) :pror.todayDate.day.toString()),
                                ),
                              )
                            ],
                          )),
                    ):Container(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: (){
                            // pro.checkIfUSer('+923033374110');
                            Navigator.pop(context);
                          },
                          child: const Text("Back"),
                        ),
                        MaterialButton(
                          color: Colors.blue,
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (contxt) => const PaymnetScreen()));
                          },
                          child: const Text("Next",style: TextStyle(color: Colors.white),),
                        )
                      ],
                    )
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
