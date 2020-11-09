import 'package:eathlete/blocs/competition/competition_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:provider/provider.dart';

import '../models/class_definitions.dart';
import '../common_widgets/common_widgets.dart';
import '../misc/useful_functions.dart';
import 'main_page.dart';

class CompetitionEntry extends StatefulWidget {
  @override
  _CompetitionEntryState createState() => _CompetitionEntryState();
}

class _CompetitionEntryState extends State<CompetitionEntry> {
  //validation of form fields, 0: title, 1: Competition Date, 2: start time 3: address
  List<bool> conditions = [true, true, true, true];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild.unfocus();
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                height: 10,
                width: 40,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(40)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SingleChildScrollView(
                  child: BlocListener<CompetitionBloc, CompetitionState>(
                    listener: (BuildContext context, CompetitionState state) {
                      if (state is InformationIncomplete) {
                        conditions = state.conditions;
                        setState(() {});
                      }
                      if (state is SubmissionSuccessful) {
                        Provider.of<PageNumber>(context, listen: false)
                            .pageNumber = 2;
                        Future.delayed(Duration(milliseconds: 1)).then((value) {
                          setState(() {});
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainPage(
                                        pageNumber: Provider.of<PageNumber>(
                                                context,
                                                listen: false)
                                            .pageNumber,
                                      )),
                              (route) => false);
                        });
                      }
                    },
                    child: BlocBuilder<CompetitionBloc, CompetitionState>(
                        builder:
                            (BuildContext context, CompetitionState state) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text('*', style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),),
                                Expanded(
                                  child: TextFormField(
                                    initialValue: state.competition.name,
                                    decoration: InputDecoration.collapsed(
                                        hintText: 'Enter competition name here',
                                        hintStyle: TextStyle(
                                            color: conditions[0]
                                                ? Color(0xff828289)
                                                : Colors.red)),
                                    onChanged: (value) {
                                      BlocProvider.of<CompetitionBloc>(context)
                                          .add(UpdateName(value));
                                    },
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: PickerEntryBox(
                                borderColor: conditions[1]
                                    ? Color(0xff828289)
                                    : Colors.red,
                                textColor:
                                    conditions[1] ? Colors.black : Colors.red,
                                name: 'Competition Date',
                                value: state.competition.date == null
                                    ? '-'
                                    : '${state.competition.date}',
                                onPressed: () async {
                                  DateTime newDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2100, 12, 31),
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
                                  conditions[1] = true;
                                  if (newDate != null) {
                                    BlocProvider.of<CompetitionBloc>(context)
                                        .add(UpdateDate(
                                            '${newDate.year}-${timeToString(newDate.month)}-${timeToString(newDate.day)}'));
                                  }
                                  setState(() {

                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: PickerEntryBox(
                                borderColor: conditions[2]
                                    ? Color(0xff828289)
                                    : Colors.red,
                                textColor:
                                    conditions[2] ? Colors.black : Colors.red,
                                name: 'Start Time',
                                value: state.competition.startTime == null
                                    ? '-'
                                    : '${state.competition.startTime}',
                                onPressed: () {
                                  showStartTimeArray(context);
                                  conditions[2] = true;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: AppStyledTextField(
                                fieldName: 'Address',
                                initialValue: state.competition.address,
                                borderColor: conditions[3]
                                    ? Color(0xff828289)
                                    : Colors.red,
                                helpTextColor: conditions[3]
                                    ? Color(0xff828289)
                                    : Colors.red,
                                keyboardType: TextInputType.multiline,
                                onChanged: (value, context) {
                                  BlocProvider.of<CompetitionBloc>(context)
                                      .add(UpdateAddress(value));
                                },
                                minLines: 5,
                                maxLines: 5,
                              ),
                            ),
                            BigBlueButton(
                              text: 'Add',
                              onPressed: () {
                                BlocProvider.of<CompetitionBloc>(context)
                                    .add(Submit());
                              },
                            ),
                            SizedBox(
                              height: 15,
                            )
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showStartTimeArray(BuildContext context) {
    Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: [
            [for (var i = 0; i < 25; i += 1) timeToString(i)],
            [':'],
            [for (var i = 0; i < 360; i += 1) timeToString(i)],
          ],
          isArray: true,
        ),
        hideHeader: true,
        selecteds: [12, 0, 30],
        title: Text("Please Select"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          print(value[0]);
          print(value[2]);
          print('${value[0]}:${value[2]}');
          BlocProvider.of<CompetitionBloc>(context)
              .add(UpdateStartTime('${value[0]}:${value[2]}'));

          setState(() {});
        }).showDialog(context);
  }
}
