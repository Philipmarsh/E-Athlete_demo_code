import 'dart:io';

import 'package:eathlete/blocs/authentification/authentification_bloc.dart';
import 'package:eathlete/blocs/log_in/log_in_bloc.dart';
import 'package:eathlete/misc/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../common_widgets/common_widgets.dart';
import 'log_in_screen.dart';




class DeleteAccountAuthentication extends StatefulWidget {
  @override
  _DeleteAccountAuthenticationState createState() => _DeleteAccountAuthenticationState();
}

class _DeleteAccountAuthenticationState extends State<DeleteAccountAuthentication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocListener<LogInBloc, LogInState>(
        listener: (BuildContext context, LogInState state)async{
            if(state is SuccessfulLogin){
              print(await Provider.of<UserRepository>(context, listen: false).isSignedIn());
             await  Provider.of<UserRepository>(context, listen: false).deleteUser();
              print('problem is here');
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
              await Future.delayed(Duration(milliseconds: 1));
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginPage.id, (Route<dynamic> route) => false);


            }
        },
        child: GestureDetector(
          onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild.unfocus();
        }},
          child: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height-100,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Spacer(flex: 3,),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text('To Delete your account, Please',
                            textAlign:TextAlign.center,
                            style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),),
                          Text('Re-authenticate',
                            textAlign:TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),),
                        ],
                      ),
                    ),
                  Spacer(flex: 3,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppStyledTextField(
                        onChanged: (value, context) {
                          BlocProvider.of<LogInBloc>(context).add(EmailChanged(value));
                        },
                        icon: Icon(Icons.alternate_email, color: Color(0xff828289)),
                        fieldName: 'Email Address',
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppStyledTextField(
                        onChanged: (value, context){
                          BlocProvider.of<LogInBloc>(context).add(PasswordChanged(value));
                        },
                        icon: Icon(
                          Icons.lock_outline,
                          color: Color(0xff828289),
                        ),
                        fieldName: 'Password',
                        obscured: true,
                      ),
                    ),
                    Spacer(flex: 1,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 499,
                        height: 60,
                        child: MaterialButton(
                          color: Color(0xff0088ff),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            BlocProvider.of<LogInBloc>(context).add(Submitted(true));
                          },
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(0.0),
                          child:
                          const Text('Submit', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ),
                    Spacer(flex: 2,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: SocialMediaButton(
                              image: Image.asset('images/facebook_logo.png'),
                              text: 'Facebook',
                      onPressed: (context) => BlocProvider.of<LogInBloc>(context).add(FacebookLoginAttempt(true)),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: SocialMediaButton(
                              image: Image.asset('images/google_logo.png'),
                              text: 'Google',
                      onPressed: (context) => BlocProvider.of<LogInBloc>(context).add(GoogleLogin(true)),
                            ),
                          )
                        ],
                      ),
                    ),
                    Platform.isIOS?Center(
                      child: Row(
                        children: <Widget>[
                          Spacer(),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SocialMediaButton(
                                image: Image.asset('images/pngfuel.com.png'),
                                text: 'Apple',
                                onPressed: (context) => BlocProvider.of<LogInBloc>(context).add(AppleLogin(true)),
                              ),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ):Container(),
                    Spacer(flex: 3,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
