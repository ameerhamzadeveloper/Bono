import 'package:bono_gifts/provider/wcmp_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:provider/provider.dart';
class PaymnetScreen extends StatefulWidget {
  const PaymnetScreen({Key? key}) : super(key: key);

  @override
  _PaymnetScreenState createState() => _PaymnetScreenState();
}

class _PaymnetScreenState extends State<PaymnetScreen> {

  bool google = true;
  bool apple = false;
  bool paypal = false;
  String tokenizeKey = "sandbox_zjk38q83_d9s5x28jpgg8snjs";

  @override
  Widget build(BuildContext context) {
    final pror = Provider.of<WooCommerceMarketPlaceProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Center(child: Text("Buy Gifts",style: TextStyle(fontSize: 20),)),
              const SizedBox(height: 10,),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: google,
                            onChanged: (val){
                              setState(() {
                                apple = false;
                                paypal = false;
                                google = true;
                              });
                            },
                          ),
                          Image.asset("assets/images/icons/Google.png",height: 30)
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: apple,
                            onChanged: (val){
                              setState(() {
                                apple = true;
                                paypal = false;
                                google = false;
                              });
                            },
                          ),
                          Image.asset("assets/images/icons/Apple.png",height: 30)
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: paypal,
                            onChanged: (val){
                              setState(() {
                                apple = false;
                                paypal = true;
                                google = false;
                              });
                            },
                          ),
                          Image.network("https://assets.stickpng.com/images/580b57fcd9996e24bc43c530.png",height: 30)
                        ],
                      ),
                      SizedBox(height: 40,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Total Price : ${pror.price!}",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500),),
                        ],
                      ),
                      SizedBox(height: 20,),
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
                            onPressed: ()async{
                              if(google == true){
                                final request = BraintreeDropInRequest(
                                  clientToken: tokenizeKey,
                                  collectDeviceData: true,
                                  googlePaymentRequest: BraintreeGooglePaymentRequest(
                                    totalPrice: '4.20',
                                    currencyCode: 'USD',
                                    billingAddressRequired: false,
                                    googleMerchantID: 'bonoMirchent'
                                  ),
                                  // paypalRequest: BraintreePayPalRequest(
                                  //   amount: '4.20',
                                  //   displayName: 'Example company',
                                  // ),
                                );
                                final result = await BraintreeDropIn.start(request);
                                if (result!.paymentMethodNonce != null) {
                                  // print(result.deviceData.toString());
                                  print(result.paymentMethodNonce.description);
                                  print(result.paymentMethodNonce.nonce);
                                  // print(result.paymentMethodNonce.typeLabel);
                                  print(result.toString());
                                }else{
                                  print("Payment cancel");
                                }
                              }else if(apple == true){

                              }else if(paypal == true){
                                final request = BraintreeDropInRequest(
                                  // clientToken: "d9s5x28jpgg8snjs",
                                  tokenizationKey: tokenizeKey,
                                  collectDeviceData: true,
                                  // googlePaymentRequest: BraintreeGooglePaymentRequest(
                                  //     totalPrice: '4.20',
                                  //     currencyCode: 'USD',
                                  //     billingAddressRequired: false,
                                  //     googleMerchantID: 'bonoMirchent'
                                  // ),
                                  paypalRequest: BraintreePayPalRequest(
                                    amount: '4.20',
                                    displayName: 'Example company',
                                  ),
                                );
                                final result = await BraintreeDropIn.start(request);
                                if (result != null) {
                                  print(result.paymentMethodNonce);
                                }
                              }
                            },
                            child: const Text("Pay",style: TextStyle(color: Colors.white),),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
