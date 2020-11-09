
import 'dart:io';

import 'package:eathlete/blocs/authentification/authentification_bloc.dart';
import 'package:eathlete/blocs/log_in/log_in_bloc.dart';
import 'package:eathlete/screens/profile_edit_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common_widgets/common_widgets.dart';
import '../misc/user_repository.dart';

import 'main_page.dart';

class SignUpPage extends StatefulWidget {
  static const String id = 'signup page';
  SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogInBloc(Provider.of<UserRepository>(context, listen: false)),
      child: SignUpPageContent(),
    );

  }
}

class SignUpPageContent extends StatelessWidget {
  const SignUpPageContent({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Builder(
          builder: (context)=> BlocListener<LogInBloc, LogInState>(
            listener: (BuildContext context, LogInState state){
              if(state is SuccessfulLogin){
                AuthenticationBloc _authentificationBloc = AuthenticationBloc(userRepository: Provider.of<UserRepository>(context, listen: false));
                _authentificationBloc.add(LoggedIn());
                Navigator.pop(context);
                Navigator.popAndPushNamed(context, MainPage.id);
                Navigator.pushNamed(context, ProfileEditPage.id);
              }
              if(state is LoginFailure){
                Scaffold.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.error),
                          SizedBox(width: 8,),
                          Text(state.message),
                        ],
                      )));
              }
            },
            child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: height),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(child: Container()),
                        Image.asset('images/51012169_padded_logo.png', scale: 2,),
                        Text(
                          'Welcome to E-Athlete',
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          'Create your account',
                          style: TextStyle(color: Color(0xffc6c6c6), fontSize: 17),
                        ),
                        Spacer(flex: 2,),
                        AppStyledTextField(
                          onChanged: (value, context){
                            LogInBloc loginBloc = BlocProvider.of<LogInBloc>(context);
                            loginBloc.add(EmailChanged(value));
                          },
                          icon: Icon(Icons.alternate_email, color: Color(0xff828289)),
                          fieldName: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                        ),
                        Spacer(flex: 1,),
                        AppStyledTextField(
                          onChanged: (value, context){
                            LogInBloc loginBloc = BlocProvider.of<LogInBloc>(context);
                            loginBloc.add(PasswordChanged(value));
                          },
                          icon: Icon(
                            Icons.lock_outline,
                            color: Color(0xff828289),
                          ),
                          fieldName: 'Password',
                          obscured: true,
                        ),
                        Spacer(flex: 1,),
                        AppStyledTextField(
                          onChanged: (value, context){
                            LogInBloc loginBloc = BlocProvider.of<LogInBloc>(context);
                            loginBloc.add(Password2Changed(value));
                          },
                          icon: Icon(
                            Icons.lock_outline,
                            color: Color(0xff828289),
                          ),
                          fieldName: 'Password',
                          obscured: true,
                        ),
                        Spacer(flex: 1,),
                        Container(
                          width: 499,
                          height: 60,
                          child: MaterialButton(
                            color: Color(0xff0088ff),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onPressed: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              LogInBloc loginBloc = BlocProvider.of<LogInBloc>(context);
                              loginBloc.add(SignUp());
                            },
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(0.0),
                            child: const Text('Sign Up', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                        Spacer(flex: 2,),
                        Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                              child: Divider(
                                thickness: 2,
                                color: Color(0xffeeeeef),
                              ),
                            ),
                            Center(
                                child: Container(
                              width: 30,
                              color: Colors.white,
                              child: Center(
                                child: Text(
                                  'OR',
                                  style: TextStyle(
                                      color: Color(0xffc0c0c4),
                                      backgroundColor: Colors.white),
                                ),
                              ),
                            ))
                          ],
                        ),
                        Spacer(flex: 2,),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: SocialMediaButton(
                                image: Image.asset('images/facebook_logo.png'),
                                text: 'Facebook',
                                onPressed: (context) {
                                  LogInBloc loginBloc = BlocProvider.of<LogInBloc>(context);
                                  loginBloc.add(FacebookLoginAttempt(false));
                                },
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: SocialMediaButton(
                                image: Image.asset('images/google_logo.png'),
                                text: 'Google',
                                onPressed: (context){
                                  print('Google');
                                  LogInBloc loginBloc = BlocProvider.of<LogInBloc>(context);
                                  loginBloc.add(GoogleLogin(false));
                                },
                              ),
                            )
                          ],
                        ),
                        Center(
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
                                    onPressed: (context)=>BlocProvider.of<LogInBloc>(context).add(AppleLogin(false)),
                                  ),
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Spacer(flex: 2,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Already have an account?  '),
                            GestureDetector(
                              onTap: () {
                                print('User pressed sign in');
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, color: Colors.blue),
                              ),
                            )
                          ],
                        ),
                        Spacer(flex: 2,),
                        Center(
                          child: GestureDetector(
                            onTap: ()async{
                              const url = 'https://elliottgrover.wixsite.com/e-athleteapp/about';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[Spacer(),Icon(Icons.info_outline, color: Colors.grey,),
                                Text(' Privacy Policy', style: TextStyle(color: Colors.grey),), Spacer()],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ),
          ),

      );
  }
}

