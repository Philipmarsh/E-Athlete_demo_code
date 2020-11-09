import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:eathlete/misc/user_repository.dart';
import 'package:flutter/material.dart';

import 'package:eathlete/misc/useful_functions.dart';
import 'package:provider/provider.dart';

class NetworkHandler extends StatefulWidget {
  final Widget child;
  NetworkHandler({Key key, this.child}) : super(key: key);

  @override
  _NetworkHandlerState createState() => _NetworkHandlerState();
}

class _NetworkHandlerState extends State<NetworkHandler> {
  StreamSubscription connectivityListener;
  @override
  void initState() {
    super.initState();
    connectivityListener = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        processSendQueue(Provider.of<UserRepository>(context, listen: false));
        processDeleteQueue(Provider.of<UserRepository>(context, listen: false));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    super.dispose();
    connectivityListener.cancel();
  }
}
