import 'dart:io';
import 'package:eathlete/misc/constants.dart';
import 'package:eathlete/misc/user_repository.dart';
import 'package:eathlete/models/class_definitions.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyMessageHandler extends StatefulWidget {
  final Widget child;
  MyMessageHandler({Key key, this.child}) : super(key: key);

  @override
  _MyMessageHandlerState createState() => _MyMessageHandlerState();
}

class _MyMessageHandlerState extends State<MyMessageHandler> {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  void _saveDeviceToken()async{
    String fcmToken = await _fcm.getToken();
    if(fcmToken != null){
      var response = await http.post(kAPIAddress +'/api/fcm-token/', headers: {'Authorization': 'JWT ' + await Provider.of<UserRepository>(context, listen: false).refreshIdToken()},
          body: {'token': fcmToken});
    }else{
      print('no token!');
    }
  }

  @override
  void initState() {
    super.initState();
    if(Platform.isIOS){
      _fcm.onIosSettingsRegistered.listen((event) {
        _saveDeviceToken();
      });

      _fcm.requestNotificationPermissions(
        IosNotificationSettings()
      );
    }else{
      _saveDeviceToken();
    }
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        UserNotification newNotification = UserNotification()
        ..photoURL =message['']
        ..timeReceived=message['timereceived']
        ..content = message['content']
        ..title = message['title'];
        print(newNotification);


      },
//      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}