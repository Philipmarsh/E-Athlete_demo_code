
import 'package:eathlete/blocs/goal_update/goal_update_bloc.dart';
import 'package:eathlete/blocs/goals/goals_bloc.dart';
import 'package:eathlete/common_widgets/common_widgets.dart';
import 'package:eathlete/misc/useful_functions.dart';
import 'package:eathlete/misc/user_repository.dart';
import 'package:eathlete/screens/goals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class GoalUpdateBody extends StatefulWidget {
  GoalUpdateBody({Key key}) : super(key: key);

  @override
  _GoalUpdateBodyState createState() => _GoalUpdateBodyState();
}

class _GoalUpdateBodyState extends State<GoalUpdateBody> {
  DateTime myDateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) { currentFocus.focusedChild.unfocus(); }
      },
      child: Container(
        height: MediaQuery.of(context).size.height*0.7,
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
                  child: BlocListener<GoalUpdateBloc, GoalUpdateState>(
                    listener: (BuildContext context, GoalUpdateState state) {
                      if (state is InformationSubmitted) {
                        Future.delayed(Duration(milliseconds: 1)).then((value) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => BlocProvider(
                                  create: (context) => GoalsBloc(userRepository: Provider.of<UserRepository>(context, listen: false)),
                                  child: Goals())),
                              (route) => false);
                        });
                      }
                    },
                    child: BlocBuilder<GoalUpdateBloc, GoalUpdateState>(
                        builder: (BuildContext context, GoalUpdateState state) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'New ${state.goalType} Goal',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PickerEntryBox(
                              name: 'Deadline Date',
                              value:myDateTime==null?'${timeToString(currentDay.day)}-${timeToString(currentDay.month)}-${currentDay.year}':
                                  '${timeToString(myDateTime.day)}-${timeToString(myDateTime.month)}-${myDateTime.year}',
                              onPressed: () async {
                                myDateTime = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100, 12, 31),
                                    builder: (BuildContext context, Widget child) {
                                      return Theme(
                                        data: ThemeData.light().copyWith(
                                            primaryColor:
                                                const Color(0xFF4A5BF6), //Head background
                                            accentColor: const Color(0xFF4A5BF6)),
                                        child: child,
                                      );
                                    });
                                if(myDateTime!=null){
                                BlocProvider.of<GoalUpdateBloc>(context)
                                    .add(UpdateGoalDate(myDateTime));
                                print(myDateTime);
                                setState(() {});}
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppStyledTextField(
                              maxLines: 5,
                              minLines: 5,
                              fieldName: 'Goal Content',
                              onChanged: (value, context) {
                                print(value);
                                BlocProvider.of<GoalUpdateBloc>(context)
                                    .add(UpdateGoalContent(value));
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          BigBlueButton(
                            text: ('Add'),
                            onPressed: () {
                              BlocProvider.of<GoalUpdateBloc>(context).add(Submit());
                            },
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
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
}
