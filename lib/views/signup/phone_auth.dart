import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/routes/routes_names.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class PhoneAuthentication extends StatefulWidget {
  const PhoneAuthentication({Key? key}) : super(key: key);

  @override
  _PhoneAuthenticationState createState() => _PhoneAuthenticationState();
}

class _PhoneAuthenticationState extends State<PhoneAuthentication> {

  GlobalKey<FormState> key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<SignUpProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: key,
            child: Column(
              children: [
                const SizedBox(height: 30,),
                const Text("Let's veify your phone number",style: TextStyle(fontSize: 22,color: Colors.blue),textAlign: TextAlign.center,),
                const SizedBox(height: 20,),
                const Text("Please Enter your phone number We will send you an sms message to verif your number",textAlign: TextAlign.center,),
                const SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    children: [
                      CountryCodePicker(
                        onChanged: (val){
                          pro.setDialCode(val.dialCode!);
                        },
                        onInit: (val){
                          pro.setDialCode(val!.dialCode!);
                        },
                        initialSelection: pro.code,
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,
                        alignLeft: false,
                      ),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          validator: (val){
                            if(val!.isEmpty){
                              return "Please Enter your phone";
                            }
                          },
                          onChanged: (val){
                            pro.setPhoneNum(val);
                          },
                          controller: pro.phoneNumber,
                          decoration: const InputDecoration(
                            hintText: "1234567890",
                            border: InputBorder.none
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: ()=>Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    MaterialButton(
                      color: Colors.blue,
                      onPressed: (){
                        if(key.currentState!.validate()){
                          pro.authUserWithPhone();
                          Navigator.pushNamed(context,verifyOTP);
                        }
                      },
                      child: const Text("Next",style: TextStyle(color: Colors.white),),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
