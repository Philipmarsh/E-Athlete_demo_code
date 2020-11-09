import 'package:eathlete/misc/user_repository.dart';
import 'package:eathlete/models/class_definitions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Notifications extends StatelessWidget {
  static const String id = 'notifications';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: Row(
          children: <Widget>[
            Container(
                height: 50,
                child: Image.asset('images/placeholder_logo.PNG')),
            Text(
              'E-Athlete',
              style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            )
          ],
        ),
      ),
body: Container(
  child: Center(
    child: Text('No Notifications to show', style: TextStyle(color: Colors.grey),),
  ),
),
//      body: ListView.builder(
//          itemCount: Provider.of<UserRepository>(context).notifications.length,
//          itemBuilder: (BuildContext context, int index){
//            UserNotification _notification = Provider.of<UserRepository>(context).notifications[index];
//            return NotificationTile(_notification);
//          }),
    );
  }
}

class NotificationTile extends StatefulWidget {
  final UserNotification _notification;


  NotificationTile(this._notification);

  @override
  _NotificationTileState createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          widget._notification.photoURL!=null?Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(widget._notification.photoURL)),
            ),
          ):Container(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[Text(widget._notification.title),
                Text('${widget._notification.timeReceived}')],
              ),
            Text(widget._notification.content)],
          )
        ],
      ),
    );
  }
}

