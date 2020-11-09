import 'package:eathlete/blocs/authentification/authentification_bloc.dart';
import 'package:eathlete/blocs/log_in/log_in_bloc.dart';
import 'package:eathlete/common_widgets/common_widgets.dart';
import 'package:eathlete/misc/user_repository.dart';
import 'package:eathlete/screens/delete_account_authentification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

import 'log_in_screen.dart';

class Settings extends StatelessWidget {
  static const String id = 'settings';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: Row(
//          mainAxisAlignment: MainAxisAlignment.center,
//          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                height: 50,
                child: Image.asset('images/placeholder_logo.PNG')),
            Text(
              'E-Athlete',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            )
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: InkWell(
              onTap: ()async{
                const url = 'https://elliottgrover.wixsite.com/e-athleteapp/about';
                if (await canLaunch(url)) {
                await launch(url);
                } else {
                throw 'Could not launch $url';
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black12, width: 1.0))
                ),
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Contact us', style: TextStyle(
                    fontSize: 15
                  ),),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: ()async{
              const url = 'https://elliottgrover.wixsite.com/e-athleteapp/about';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black12, width: 1.0))
              ),
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Privacy', style: TextStyle(
                    fontSize: 15
                ),),
              ),
            ),
          ),
          SizedBox(height: 20,),
          InkWell(
            onTap: ()async{
              showAboutDialog(context: context,
              applicationName: 'E-Athlete',
              applicationVersion: '1.0.0',
              applicationIcon: ImageIcon(AssetImage('images/51012169_padded_logo.png'), color: Colors.blue,));
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black12, width: 1.0))
              ),
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Legal', style: TextStyle(
                    fontSize: 15
                ),),
              ),
            ),
          ),
          BigBlueButton(
            color: Colors.red,
            text: 'Delete Account',
            onPressed: (){
              Platform.isAndroid?showDialog
              <void>(
              context: context,
              barrierDismissible: true, // false = user must tap button, true = tap outside dialog
              builder: (BuildContext dialogContext){
              return AlertDialog(
              title: Text('Delete Account'),
              content: Text('Are you sure you want to delete your account? All data associated with this account will be permanently lost'),
              actions: <Widget>[
              FlatButton(
              child: Text('Cancel'),
              onPressed: () {
              Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
              ),
                FlatButton(
                  child: Text('Delete', style: TextStyle(color: Colors.red),),
                  onPressed: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>BlocProvider(
                        create: (context)=>LogInBloc(Provider.of<UserRepository>(context, listen: false)),
                        child: DeleteAccountAuthentication())));
//                    Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                  },
                ),
              ],
              );
              },
              ):showCupertinoDialog(context: context, builder: (BuildContext dialogContext){
                return CupertinoAlertDialog(
                  title: Text('Delete Account'),
                  content: Text('Are you sure you want to delete your account? All data associated with this account will be permanently lost'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                      },
                    ),
                    FlatButton(
                      child: Text('Delete', style: TextStyle(color: Colors.red),),
                      onPressed: () async {

                        Navigator.push(context, MaterialPageRoute(builder: (context)=>BlocProvider(
                            create: (context)=>LogInBloc(Provider.of<UserRepository>(context, listen: false)),
                            child: DeleteAccountAuthentication())));

                      },
                    ),
                  ],
                );
              },);

            },
          )
        ],
      ),
    );
  }
}
