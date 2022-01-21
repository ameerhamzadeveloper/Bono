import 'package:bono_gifts/config/constants.dart';

class AllDestinations{

  String name;
  String icon;

  AllDestinations({required this.name,required this.icon});

  static List<AllDestinations> allDestinations = [
    AllDestinations(name: 'Chat', icon: chatIcon),
    AllDestinations(name: 'Buy', icon: buyIcon),
    AllDestinations(name: 'Feeds', icon: butteryFly),
    AllDestinations(name: 'Camera', icon: cameraICon),
    AllDestinations(name: 'Profile', icon: profieIcon),
  ];

}