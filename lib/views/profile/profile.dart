import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/routes/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  var formtr = DateFormat('MMM');
  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<SignUpProvider>(context);
    return Scaffold(
      body: pro.name == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MaterialButton(
                              color: Colors.grey[300],
                              onPressed: () => pro.logout(context),
                              child: const Text("Sign out"),
                            ),
                            // const SizedBox(width: 20,),
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(pro.userImage!),
                            ),
                            // const SizedBox(width: 20,),
                            MaterialButton(
                              color: Colors.grey,
                              onPressed: () =>
                                  Navigator.pushNamed(context, editProfile),
                              child: const Text(
                                "Edit Profile",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        pro.name!,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      Text(pro.phoneNumber.text),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_on),
                          const Text("Location:"),
                          Text(
                              "${pro.room.text} ${pro.buildingName.text} ${pro.area.text} ${pro.street.text} ${pro.country}"),
                        ],
                      ),
                      Container(
                        height: 80,
                        width: getWidth(context),
                        color: Colors.grey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Birthday ${pro.dobFormat?.day ?? ''} ${pro.dobFormat != null ? formtr.format(pro.dobFormat!) : ''}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${pro.diffDays} Days Left",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      pro.myPosts.length == 0
                          ? Container(
                              height: 40,
                              color: lightBlue,
                              child: Center(
                                child: Text("Photos"),
                              ),
                            )
                          : Container(),
                      const SizedBox(
                        height: 5,
                      ),
                      GridView.builder(
                        itemCount: pro.myPosts.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 0.6,
                          maxCrossAxisExtent: 100,
                        ),
                        itemBuilder: (ctx, i) {
                          return Image.network(
                            pro.myPosts.toSet().toList()[i],
                            height: 100,
                            fit: BoxFit.fill,
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
