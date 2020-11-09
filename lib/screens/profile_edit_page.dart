import 'dart:convert';

import 'package:eathlete/blocs/profile_edit/profile_edit_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_picker/flutter_picker.dart';

import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../common_widgets/common_widgets.dart';
import '../misc/useful_functions.dart';
import '../misc/user_repository.dart';


class ProfileEditPage extends StatefulWidget {
  static const String id = 'profile edit page';
  ProfileEditPage({Key key}) : super(key: key);

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {




  @override
  Widget build(BuildContext context) {
    /// returning an extracted widget to allow the BlocProvider to add a bloc that all methods have access to.
    return BlocProvider<ProfileEditBloc>(
      create: (context) =>
          ProfileEditBloc(Provider.of<UserRepository>(context, listen: false)),
      child: ProfileUpdateBody(),
    );
  }
}

class ProfileUpdateBody extends StatefulWidget {
  const ProfileUpdateBody({
    Key key,
  }) : super(key: key);

  @override
  _ProfileUpdateBodyState createState() => _ProfileUpdateBodyState();
}

class _ProfileUpdateBodyState extends State<ProfileUpdateBody> {
  @override
  Widget build(BuildContext context) {
    ProfileEditBloc profileEditBloc = BlocProvider.of<ProfileEditBloc>(context);
    return BlocBuilder(
        bloc: profileEditBloc,
        builder: (context, ProfileEditState state) {
          if(state is SubmittedSuccessfully){
            Future.delayed(Duration(milliseconds: 1)).then((value) =>  Navigator.pop(context));

          }
          return Scaffold(
            appBar: AppBar(
              elevation: 1,
              actions: <Widget>[NotificationButton()],
              backgroundColor: Colors.white,
              title: Row(
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
            body: ListView(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(top: 30.0, left: 30, right: 30),
                  child: Row(
                    children: <Widget>[
                      ProfilePhoto(
                        size: 90,
                        photo: state.user.newPhoto==null?NetworkImage(state.user.profilePhoto):FileImage(state.user.newPhoto),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(child: Container()),
                      MaterialButton(
                        color: Color(0xfff2f2f3),
                        padding: EdgeInsets.all(8),
                        elevation: 0,
                        onPressed: () {
                          showMaterialModalBottomSheet(context: context, builder: (builder, scrollController){
                            return ImagePickerMenu(onPressedPhoto: (image, file){
                              ProfileEditBloc profileEditBloc =
                              BlocProvider.of<ProfileEditBloc>(context);
                              profileEditBloc.add(UpdateProfilePhotoToSend(image, file));
                              Navigator.pop(context);
                              setState(() {

                              });
                            },
                            onPressedGallery: (image, file){
                              ProfileEditBloc profileEditBloc =
                              BlocProvider.of<ProfileEditBloc>(context);
                              profileEditBloc.add(UpdateProfilePhotoToSend(image, file));
                              Navigator.pop(context);
                              setState(() {

                              });

                            },);
                          });
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(200)),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.edit,
                              color: Color(0xff828289),
                            ),
                            Text('Edit Photo'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Divider(),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: AppStyledTextField(
                    onChanged: (value, context) {
                      ProfileEditBloc profileEditBloc =
                          BlocProvider.of<ProfileEditBloc>(context);
                      profileEditBloc.add(UpdateFirstName(value));
                    },
                    fieldName: 'First Name',
                    initialValue: state.user.firstName,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: AppStyledTextField(
                    onChanged: (value, context) {
                      ProfileEditBloc profileEditBloc =
                          BlocProvider.of<ProfileEditBloc>(context);
                      profileEditBloc.add(UpdateLastName(value));
                    },
                    fieldName: 'Last Name',
                    initialValue: state.user.lastName,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: PickerEntryBox(
                    name: 'Age',
                    value:
                        '${state.user.dOB != null ? state.user.age : '-'} years old',
                    onPressed: () async{

          DateTime newDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now().subtract(Duration(days: 365*20)),
          firstDate: DateTime.now().subtract(Duration(days: 103*365)),
          lastDate: DateTime.now().subtract(Duration(days: 13*365)),
          builder:
          (BuildContext context, Widget child) {
          return Theme(
          data: ThemeData.light().copyWith(
          primaryColor: const Color(
          0xFF4A5BF6), //Head background
          accentColor:
          const Color(0xFF4A5BF6)),
          child: child,
          );
          });

          if (newDate != null) {
          BlocProvider.of<ProfileEditBloc>(context)
              .add(UpdateDOB(
          '${newDate.year}-${timeToString(newDate.month)}-${timeToString(newDate.day)}'));
                    }
          setState(() {

          });},
          ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: PickerEntryBox(
                    name: 'Height',
                    value:
                        '${state.user.height != null ? state.user.height : '-'} cm',
                    onPressed: () {
                      showHeightArray(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: PickerEntryBox(
                    name: 'Weight',
                    value:
                        '${state.user.weight != null ? state.user.weight : '-'} kg',
                    onPressed: () {
                      showWeightArray(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: PickerEntryBox(
                    name: 'Sex',
                    value:
                        '${state.user.sex != null ? state.user.sex : '-'}',
                    onPressed: () {
                      showSexArray(context);
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: AppStyledTextField(
                    onChanged: (value, context) {
                      ProfileEditBloc profileEditBloc =
                          BlocProvider.of<ProfileEditBloc>(context);
                      profileEditBloc.add(UpdateSport(value));
                    },
                    fieldName: 'Sport',
                    initialValue: state.user.sport != null
                        ? state.user.sport
                        : null,
                  ),
                ),

                BigBlueButton(onPressed: (){
                                          ProfileEditBloc profileEditBloc =
                        BlocProvider.of<ProfileEditBloc>(context);
                        profileEditBloc.add(SubmitForm());
                        print('user pressed save changes');
                },
                text: 'Update',),
                SizedBox(height: 20,)
              ],
            ),
          );
        });
  }

  ///functions for the different pickers

  

  showWeightArray(BuildContext context) {
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: [
            [for (var i = 0; i < 360; i += 1) i],
            ['kg']
          ],
          isArray: true,
        ),
        hideHeader: true,
        selecteds: [
          userRepository.user.weight != null ? userRepository.user.weight : 70,
          0,
        ],
        title: Text("Please Select"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          ProfileEditBloc profileEditBloc =
              BlocProvider.of<ProfileEditBloc>(context);
          profileEditBloc
              .add(UpdateWeight(int.parse(picker.getSelectedValues()[0])));

          print(picker.getSelectedValues());
          setState(() {

          });
        }).showDialog(context);
  }

  showHeightArray(BuildContext context) {
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: [
            [for (var i = 0; i < 360; i += 1) i],
            ['cm']
          ],
          isArray: true,
        ),
        hideHeader: true,
        selecteds: [
          userRepository.user.height != null ? userRepository.user.height : 160,
          0,
        ],
        title: Text("Please Select"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          ProfileEditBloc profileEditBloc =
              BlocProvider.of<ProfileEditBloc>(context);
          profileEditBloc
              .add(UpdateHeight(int.parse(picker.getSelectedValues()[0])));
          print(picker.getSelectedValues()[0].runtimeType);
          print(picker.getSelectedValues());
          setState(() {

          });
        }).showDialog(context);
  }

  showSexArray(BuildContext context) {
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    String sex = userRepository.user.sex;
    int selecteds = sex == 'Female' ? 1 : 0;
    Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: [
            ['Male', 'Female']
          ],
          isArray: true,
        ),
        hideHeader: true,
        selecteds: [selecteds],
        title: Text("Please Select"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          ProfileEditBloc profileEditBloc =
              BlocProvider.of<ProfileEditBloc>(context);
          profileEditBloc.add(UpdateSex(picker.getSelectedValues()[0]));
          print(picker.getSelectedValues());
          setState(() {
            
          });
        }).showDialog(context);
  }
}



class ImagePickerMenu extends StatelessWidget {

  final Function onPressedPhoto;
  final Function onPressedGallery;

  ImagePickerMenu({this.onPressedGallery, this.onPressedPhoto});

  Future getImageFromCamera () async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {

        var _image = image;

        List<int> fileContent = image.readAsBytesSync();
        String fileContentBase64 = base64.encode(fileContent);
        onPressedPhoto(_image, fileContentBase64);

    }
  }
  Future getImageFromGallery () async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {

      var _image = image;

      List<int> fileContent = image.readAsBytesSync();
      String fileContentBase64 = base64.encode(fileContent);
      onPressedGallery(_image, fileContentBase64);

    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: ()=> getImageFromCamera(),
              child: Container(
                child: Center(
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: ()=> getImageFromGallery(),
              child: Container(
                child: Center(
                  child: Icon(
                      Icons.photo_library,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}

