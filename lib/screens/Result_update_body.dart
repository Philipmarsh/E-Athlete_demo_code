import 'package:eathlete/blocs/result/result_bloc.dart';
import 'package:eathlete/common_widgets/common_widgets.dart';
import 'package:eathlete/misc/useful_functions.dart';
import 'package:eathlete/models/class_definitions.dart';
import 'package:eathlete/screens/results.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:provider/provider.dart';

import 'main_page.dart';

class ResultUpdateBody extends StatefulWidget {
  ResultUpdateBody({Key key}) : super(key: key);

  @override
  _ResultUpdateBodyState createState() => _ResultUpdateBodyState();
}

class _ResultUpdateBodyState extends State<ResultUpdateBody> {
  List<bool> conditions = [true, true];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResultBloc, ResultState>(
      builder: (BuildContext context, ResultState state){
        if(state is IncompleteInformation){
          conditions = state.conditions;
        }
        return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                height: 10,
                width: 40,
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(40)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SingleChildScrollView(
                  child: BlocListener<ResultBloc, ResultState>(
                    listener: (BuildContext context, ResultState state) {
                      if (state is SubmissionSuccessful) {
                        Future.delayed(Duration(milliseconds: 1)).then((value) {
                          Provider.of<PageNumber>(context, listen: false)
                              .pageNumber = 4;
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Results()),
                                  (route) => false);
                        });
                      }
                    },
                    child: BlocBuilder<ResultBloc, ResultState>(
                      builder: (BuildContext context, ResultState state){
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text('*', style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),),
                                    Expanded(
                                      child: TextFormField(
                                        initialValue: state.result.name,
                                        decoration: InputDecoration.collapsed(hintText: 'Enter competition name here', hintStyle: TextStyle(color: conditions[0]?Color(0xff828289):Colors.red)),
                                        onChanged: (value){
                                          BlocProvider.of<ResultBloc>(context).add(AddTitle(value));
                                        },
                                        style: TextStyle(
                                            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric( vertical: 12),
                                  child: PickerEntryBox(
                                    borderColor: conditions[1]?Color(0xff828289):Colors.red,
                                    textColor: conditions[1]?Colors.black:Colors.red,
                                    name: 'Competition Date',
                                    value:
                                    state.result.date==null?'-':'${state.result.date}',
                                    onPressed: () {
                                      showPickerDate(context);
                                      conditions[1]=true;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 30),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Position',
                                        style: TextStyle(color: Color(0xff828289)),
                                      ),
                                      NumberPicker(minimum: 1, maximum: 999, startValue: 1,
                                      onBackPressed: (value){
                                        BlocProvider.of<ResultBloc>(context).add(AddPosition(value));
                                      },
                                      onForwardPressed: (value){
                                        BlocProvider.of<ResultBloc>(context).add(AddPosition(value));
                                      },),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                  child: AppStyledTextField(
                                    initialValue: state.result.reflections==''?null:state.result.reflections,
                                    minLines: 5,
                                    maxLines: 5,
                                    onChanged: (value, context) => BlocProvider.of<ResultBloc>(context).add(AddReflections(value)),
                                    fieldName: 'Reflections on today',
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                BigBlueButton(text: 'Add',
                                  onPressed: (){BlocProvider.of<ResultBloc>(context).add(Submit());
//                Navigator.pop(context);
                                  },),
                                SizedBox(height: 20,)
                              ],
                            ),
                          );
                      },
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );}
    );
  }
  showPickerDate(BuildContext context) {
    Picker(
        hideHeader: true,
        adapter: DateTimePickerAdapter(),
        title: Text("Date of Competition"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          String date = '${timeToString((picker.adapter as
          DateTimePickerAdapter).value.year)}-${timeToString((picker.adapter as
          DateTimePickerAdapter).value.month)}'
              '-${timeToString((picker.adapter as DateTimePickerAdapter).value.day)}';
          BlocProvider.of<ResultBloc>(context).add(ChangeDate(date));
          setState(() {

          });
        }).showDialog(context);
  }
}
