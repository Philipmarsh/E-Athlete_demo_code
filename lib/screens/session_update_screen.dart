import 'package:eathlete/blocs/session/session_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_picker/Picker.dart';


import 'package:provider/provider.dart';

import '../models/class_definitions.dart';
import '../common_widgets/common_widgets.dart';
import '../misc/user_repository.dart';
import 'main_page.dart';

class SessionUpdateScreen extends StatefulWidget {

  SessionUpdateScreen({Key key}) : super(key: key);

  @override
  _SessionUpdateScreenState createState() => _SessionUpdateScreenState();
}

class _SessionUpdateScreenState extends State<SessionUpdateScreen> {
  List<bool> conditions =[true, true, true];
  int dayPointer =0;


  @override
  Widget build(BuildContext context) {
      return GestureDetector(
        onTap: (){
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) { currentFocus.focusedChild.unfocus(); }
        },
        child: Container(
          height: MediaQuery.of(context).size.height*0.9,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 10,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(40)
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
              bottom: MediaQuery.of(context)
                  .viewInsets
                  .bottom),
                  child: SingleChildScrollView(
                    child: BlocListener<SessionBloc, SessionState>(
                    listener: (BuildContext context, SessionState state){


                      if(state is InformationIncomplete){
                        conditions = state.conditions;
                        setState(() {

                        });
                      }
                      if(state is SuccessfullySubmitted){
                          Future.delayed(Duration(milliseconds: 1)).then((value) {
                            Provider.of<PageNumber>(context, listen: false).pageNumber = 1;
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainPage(
                                      pageNumber:
                                      Provider.of<PageNumber>(context, listen: false)
                                          .pageNumber,
                                    )),
                                    (route) => false);
                          });
                        }
                    },
                    child: BlocBuilder<SessionBloc, SessionState>(
                      builder: (BuildContext context, SessionState state) { return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Row(
                              children: <Widget>[
                                Text('*', style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),),
                                Expanded(
                                  child: TextFormField(
                                    initialValue: state.session.title,
                                    decoration: InputDecoration.collapsed(hintText: 'New Session'),
                                    onChanged: (value){
                                      BlocProvider.of<SessionBloc>(context).add(UpdateTitle(value));
                                    },
                                    style: TextStyle(
                                        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.chevron_left),
                                        onPressed: state.last7daysChooser.dayPointer>=6?null:(){
                                          BlocProvider.of<SessionBloc>(context).add(ChangeDateBackwards());
                                          setState(() {

                                          });
                                        },
                                      ),
                                      Text(state.last7daysChooser.displayDate),
                                      IconButton(
                                        icon: Icon(Icons.chevron_right),
                                        onPressed: state.last7daysChooser.dayPointer<=0?null:(){
                                          BlocProvider.of<SessionBloc>(context).add(ChangeDateForwards());
                                          setState(() {

                                          });
                                        },
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            Text(
                              'Intensity',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            GradientSlider(
                              initialValue:state.session.intensity,
                              width:MediaQuery.of(context).size.width*0.8,
                              onChanged: (value) {
                              BlocProvider.of<SessionBloc>(context).add(UpdateIntensity(value));
                              conditions[0] = true;
                              setState(() {});
                            },),

                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              'Performance in the session',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            NumberScale(
                              initialValue: state.session.performance,
                              borderColor: conditions[1]?Colors.grey:Colors.red,
                              onChanged: (value) {
                                BlocProvider.of<SessionBloc>(context)
                                    .add(UpdatePerformance(value));
                                conditions[1] = true;
                                setState(() {});
                              },
                              maxNumber: 5,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              'Feeling',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 12),
                            FeelingPicker(
                              initialValue: state.session.feeling,
                              borderColor: conditions[2]?Colors.transparent:Colors.red,
                              onChanged: (value) {
                                BlocProvider.of<SessionBloc>(context).add(UpdateFeeling(value));
                                conditions[2] = true;
                                setState(() {

                                });
                              },
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric( vertical: 12),
                              child: PickerEntryBox(
                                name: 'Length of Session',
                                value:
                                state.session.lengthOfSession==null?'-':'${state.session.lengthOfSession}',
                                onPressed: () {
                                  showTimeArray(context);
                                },
                              ),
                            ),
                            AppStyledTextField(
                              fieldName: 'Target',
                              initialValue: state.session.target,
                              onChanged: (value, context)=>BlocProvider.of<SessionBloc>(context).add(UpdateTarget(value)),
                            ),
                            SizedBox(height: 12,),
                            AppStyledTextField(
                              fieldName: 'Reflections',
                              onChanged: (value, context)=>BlocProvider.of<SessionBloc>(context).add(UpdateReflections(value)),
                              initialValue: state.session.reflections,
                            ),
                            BigBlueButton(text: 'Add', onPressed: (){BlocProvider.of<SessionBloc>(context).add(Submit());},),
                            SizedBox(height: 20,)

                          ],
                        ),
                      );}
                    ),
            ),
                  ),
                ),
              )],
          ),
        ),
      );

  }

  showTimeArray(BuildContext context) {
    UserRepository userRepository =
    Provider.of<UserRepository>(context, listen: false);
    String sex = userRepository.user.sex;

    Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: [
            [for (var i = 0; i < 600; i += 5) i]
          ],
          isArray: true,
        ),
        hideHeader: true,
        selecteds: [5],
        title: Text("Please Select"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          BlocProvider.of<SessionBloc>(context).add(
              UpdateLengthOfSession(int.parse(picker.getSelectedValues()[0])));
          print(picker.getSelectedValues());
          setState(() {

          });
        }).showDialog(context);
  }
}



class FeelingPicker extends StatefulWidget {
  final String initialValue;
  final Function onChanged;
  final Color borderColor;
  const FeelingPicker({Key key, this.onChanged, this.borderColor = Colors.transparent, this.initialValue}) : super(key: key);

  @override
  _FeelingPickerState createState() => _FeelingPickerState();
}

class _FeelingPickerState extends State<FeelingPicker> {

  String feeling;

  @override
  void initState() {
    super.initState();
    if(widget.initialValue != null){
      feeling = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: widget.borderColor,)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    setState(() {
                      feeling = 'Frustrated';
                    });
                    widget.onChanged(feeling);
                  },
                  child: Image(
                    image: feeling == 'Frustrated'
                        ? AssetImage('images/1f621.png')
                        : AssetImage('images/1f621bnw.png'),
                    height: feeling == 'Frustrated' ? 50 : 45,
                  )),
              SizedBox(
                height: 4,
              ),
              feeling == 'Frustrated' ? Text('Fed up') : Text(''),
            ],
          ),
          Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    feeling = 'Bad';
                  });
                  widget.onChanged(feeling);
                },
                child: Image(
                  image: AssetImage(feeling == 'Bad'
                      ? 'images/1f622.png'
                      : 'images/1f622bnw.png'),
                  height: feeling == 'Bad' ? 50 : 45,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Text(feeling == 'Bad' ? 'Bad' : '')
            ],
          ),
          Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    feeling = 'Neutral';
                  });
                  widget.onChanged(feeling);
                },
                child: Image(
                  image: AssetImage(feeling == 'Neutral'
                      ? 'images/1f610.png'
                      : 'images/1f610bnw.png'),
                  height: feeling == 'Neutral' ? 50 : 45,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Text(feeling == 'Neutral' ? 'Neutral' : '')
            ],
          ),
          Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    feeling = 'Happy';
                  });
                  widget.onChanged(feeling);
                },
                child: Image(
                  image: AssetImage(feeling == 'Happy'
                      ? 'images/1f604.png'
                      : 'images/1f604bnw.png'),
                  height: feeling == 'Happy' ? 50 : 45,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Text(feeling == 'Happy' ? 'Happy' : '')
            ],
          ),
          Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    feeling = 'Buzzing';
                  });
                  widget.onChanged(feeling);
                },
                child: Image(
                  image: feeling=='Buzzing'? AssetImage('images/1f973.png'):AssetImage('images/1f973bnw.png'),
                  height: feeling == 'Buzzing' ? 50 : 45,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Text(feeling == 'Buzzing' ? 'Buzzing' : '')
            ],
          ),
        ],
      ),
    );
  }
}

