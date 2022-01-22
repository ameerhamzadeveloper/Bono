import 'package:bono_gifts/config/destination.dart';
import 'package:bono_gifts/views/buy/buy.dart';
import 'package:bono_gifts/views/camera/camera.dart';
import 'package:bono_gifts/views/chat/chat.dart';
import 'package:bono_gifts/views/feeds/feeds.dart';
import 'package:bono_gifts/views/profile/profile.dart';
import 'package:flutter/material.dart';
class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int index = 2;
  List<Widget> allPages = [
    Chat(),
    BuyPage(),
    Feeds(),
    CameraScreen(),
    const ProfilePage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: index,
          children: allPages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedItemColor: Colors.black,
        currentIndex: index,
        onTap: (val){
          setState(() {
            index = val;
          });
        },
        items: AllDestinations.allDestinations.map((e){
          return BottomNavigationBarItem(icon: Image.asset(e.icon,height: 20,width: 20,),label: e.name);
        }).toList(),
      ),
    );
  }
}
