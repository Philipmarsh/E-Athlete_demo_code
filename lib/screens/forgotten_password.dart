import 'package:eathlete/common_widgets/common_widgets.dart';
import 'package:eathlete/misc/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PasswordReset extends StatefulWidget {
  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0,),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text('Enter Your email here, and you will receive a password reset email',
            style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:12.0),
            child: AppStyledTextField(
              fieldName: 'Email Address',
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value, context){
                email = value;
              },
            ),
          ),
          BigBlueButton(
            text: 'Reset Email',
            onPressed: (){
              Provider.of<UserRepository>(context, listen: false).resetPassword(email);
            },
          )
        ],
      ),
    );
  }
}
