import 'dart:math';
import 'dart:typed_data';

import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/config/destination.dart';
import 'package:bono_gifts/models/feeds_models.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/services/feeds_services.dart';
import 'package:bono_gifts/views/camera/camera_view.dart';
import 'package:bono_gifts/views/camera/video_view.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FeedsProvider extends ChangeNotifier{
  XFile? image;
  Uint8List? bytesImage;
  String title = '';
  String description = '';
  TextEditingController commnetController = TextEditingController();

  late CameraController _cameraController;
  late Future<void> cameraValue;
  bool isRecoring = false;
  bool flash = false;
  bool iscamerafront = true;
  double transform = 0;
  late List<CameraDescription> camera;
  CameraController get cameraController => _cameraController;

  static int index = 0;

  setIndex(int ind){
    index = ind;
    print(index);
    notifyListeners();
  }

   List<AllDestinations> allDestinations = [
    AllDestinations(name: 'Chat', icon: index == 0 ? chatIconBlue :chatIconGrey),
    AllDestinations(name: 'Buy', icon:index == 1 ? giftIconBlue : giftIConGrey),
    AllDestinations(name: 'Feeds', icon:index == 2 ? feedIconBlue:feedIConGrey),
    AllDestinations(name: 'Camera', icon:index == 3 ? cameraIconBlue:cameraIconGrey),
    AllDestinations(name: 'Profile', icon: index == 4 ? profileIconBlue : profileIconGrey),
  ];
  
  final colRef = FirebaseFirestore.instance.collection('userPosts');


  dispostCameraController(){
    _cameraController.dispose();
  }

  onOFfFlash(){
    flash = !flash;
    flash
        ? _cameraController
        .setFlashMode(FlashMode.torch)
        : _cameraController.setFlashMode(FlashMode.off);
    notifyListeners();
  }

  recordVideo()async{
    await _cameraController.startVideoRecording();
    isRecoring = true;
    notifyListeners();
  }

  stopRecordVideo(BuildContext context)async{
    XFile videopath =
        await _cameraController.stopVideoRecording();

      isRecoring = false;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => VideoViewPage(
              path: videopath.path,
            ),),
    );
    notifyListeners();
  }

  void takePhoto(BuildContext context) async {
    XFile file = await _cameraController.takePicture();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => CameraViewPage(
              path: file.path,
            )));
  }

  flipCamera(){
      iscamerafront = !iscamerafront;
      transform = transform + pi;
    int cameraPos = iscamerafront ? 0 : 1;
    _cameraController = CameraController(
        camera[cameraPos], ResolutionPreset.high);
    cameraValue = _cameraController.initialize();
    notifyListeners();
  }

  takePhotoProvider(BuildContext context){
    if (!isRecoring) takePhoto(context);
  }

  getImage()async{
    XFile? tempImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    image = tempImage;
    bytesImage = await image!.readAsBytes();
    notifyListeners();
  }

  getCamera()async{
    await availableCameras().then((value) {
        camera = value;
      _cameraController = CameraController(camera[0], ResolutionPreset.high);
      cameraValue = _cameraController.initialize();
      notifyListeners();
    });
  }

  setDescription(String des){
    description = des;
  }
  setTitle(String titl){
    title = titl;
  }

  final service = FeedsService();

  List<FeedsModels> feeds = [];

  uploadPost(BuildContext context){
    final pro = Provider.of<SignUpProvider>(context,listen: false);
    Map<String,dynamic> data = {
      'title':title,
      'des':description,
      'image':bytesImage,
      'phone':pro.phone,
      'profileImage': pro.userImage,
      'profileName':pro.name,
    };
    service.savePost(data).then((value) {
      if(value){

        Navigator.pop(context);
      }
    });

  }

  getFeedsPosts(){
    service.getFeedsPosts().then((value){
      for(var fed in value.docs){
        feeds.add(FeedsModels(image: fed['image url'], description: fed['des'],
            title: fed['title'], date: fed['timestamp'].toDate(),
            profileImage: fed['profileImage'],profileName: fed['profileName'],
          isDesOpen: false,phone: fed['phone'],docid: fed.id,
         ),
        );
        notifyListeners();
      }
    });
  }

  addComment(String docRed,BuildContext context){
    service.addComments(docRed, context, commnetController.text);
    commnetController.clear();
  }


  setCommentText(String val){
    commnetController = TextEditingController(text: val);
  }


}