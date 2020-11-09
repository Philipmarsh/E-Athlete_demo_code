
import 'package:eathlete/models/user_model.dart';
import 'package:eathlete/screens/profile_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:provider/provider.dart';

import '../common_widgets/common_widgets.dart';
import '../misc/user_repository.dart';

class ProfilePage extends StatefulWidget {


  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Box userBox = Hive.box('userBox');
  Box diaryBox = Hive.box('diaryBox');
  @override
  Widget build(BuildContext context) {
    UserRepository userRepository =Provider.of<UserRepository>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: ImageIcon(AssetImage('images/menu_icon@3x.png'), color: Color(0xff828289),), onPressed: (){
          Scaffold.of(context).openDrawer();
        },),
        elevation: 1,
        actions: <Widget>[
          NotificationButton()
        ],
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,

          children: <Widget>[
            Container(
                height: 50, child: Image.asset('images/51012169_padded_logo.png', scale: 2,)),
            Text(
              'E-Athlete',
              style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            )
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: ()async{

          await Provider.of<UserRepository>(context, listen: false).user.getUserInfo(await userRepository.refreshIdToken());},
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:30.0, left: 30),
              child: Row(
                children: <Widget>[
                  ProfilePhoto(size: 90, photo: userRepository.user.profilePhoto!=null?NetworkImage(userRepository.user.profilePhoto):AssetImage('images/anon-profile-picture.png'),),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Text('${userRepository.user.firstName} ${userRepository.user.lastName}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25
                    ),),
                  ),

                  MaterialButton(
                    color: Color(0xfff2f2f3),
                    padding: EdgeInsets.all(8),
                    elevation: 0,
                    onPressed: (){
                      Navigator.pushNamed(context, ProfileEditPage.id).then((value){
                        setState(() {

                        });
                      }
                      );
                    },
                    shape: CircleBorder(),
                    child: Icon(Icons.edit, color: Color(0xff828289),),
                  )
                ],
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Divider(),),
            ProfileItem(category: 'Age', value: userRepository.user.dOB!=null?'${userRepository.user.age} years old':'- years old',),
            ProfileItem(category: 'Height', value: userRepository.user.height!=null?'${userRepository.user.height}cm':'-cm',),
            ProfileItem(category: 'Weight', value: userRepository.user.weight!=null?'${userRepository.user.weight}kg':'-kg',),
            ProfileItem(category: 'Sex', value: '${userRepository.user.sex!=null?userRepository.user.sex:'-'}',),
            ProfileItem(category: 'Sport', value: '${userRepository.user.sport!=null?userRepository.user.sport:'-'}',),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Short Term Goal',
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),),
                  SizedBox(height: 8,),
                  Text(diaryBox.get('shortTermGoals').length>0?diaryBox.get('shortTermGoals')[0].content:'No short term goal has been set',
                    style: TextStyle(
                        color: Color(0xff828289)
                    ),),
                  SizedBox(height: 20,),
                  Text('Medium Term Goal',
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),),
                  SizedBox(height: 8,),
                  Text(diaryBox.get('mediumTermGoals').length>0?diaryBox.get('mediumTermGoals')[0].content:'No medium term goal has been set',
                    style: TextStyle(
                        color: Color(0xff828289)
                    ),),
                  SizedBox(height: 20,),
                  Text('Long Term Goal',
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),),
                  SizedBox(height: 8,),
                  Text(diaryBox.get('longTermGoals').length>0?diaryBox.get('longTermGoals')[0].content:'No long term goal has been set',
                    style: TextStyle(
                        color: Color(0xff828289)
                    ),),
                  SizedBox(height: 140,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

