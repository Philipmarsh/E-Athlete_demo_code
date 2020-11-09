import 'package:eathlete/blocs/general_day/general_day_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../models/class_definitions.dart';
import '../common_widgets/common_widgets.dart';
import 'main_page.dart';

class GeneralDayUpdateBody extends StatefulWidget {
  const GeneralDayUpdateBody({
    Key key,
  }) : super(key: key);

  @override
  _GeneralDayUpdateBodyState createState() => _GeneralDayUpdateBodyState();
}

class _GeneralDayUpdateBodyState extends State<GeneralDayUpdateBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
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
                child: BlocListener<GeneralDayBloc, GeneralDayState>(
                  listener: (BuildContext context, GeneralDayState state) {
                    if (state is SubmissionSuccessful) {
                      Future.delayed(Duration(milliseconds: 1)).then((value) {
                        Provider.of<PageNumber>(context, listen: false)
                            .pageNumber = 1;
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
                  child: BlocBuilder(
                      bloc: BlocProvider.of<GeneralDayBloc>(context),
                      builder: (BuildContext context, GeneralDayState state) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: SingleChildScrollView(
                            reverse: true,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'General Day',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(Icons.chevron_left),
                                            onPressed: state.last7daysChooser
                                                        .dayPointer >=
                                                    6
                                                ? null
                                                : () async{
                                                    BlocProvider.of<
                                                                GeneralDayBloc>(
                                                            context)
                                                        .add(
                                                            ChangeDateBackwards());
                                                    setState(() {});
                                                  },
                                          ),
                                          Text(state
                                              .last7daysChooser.displayDate),
                                          IconButton(
                                            icon: Icon(Icons.chevron_right),
                                            onPressed: state.last7daysChooser
                                                        .dayPointer <=
                                                    0
                                                ? null
                                                : () {
                                                    BlocProvider.of<
                                                                GeneralDayBloc>(
                                                            context)
                                                        .add(
                                                            ChangeDateForwards());
                                                    setState(() {});
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
                                  'I feel well rested',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                NumberScale(
                                  initialValue: state.generalDay.rested,
                                  onChanged: (value) =>
                                      BlocProvider.of<GeneralDayBloc>(context)
                                          .add(UpdateRested(value)),
                                  maxNumber: 5,
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  'I have eaten well today',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                GradientSlider(
                                  gradient: [Colors.red, Colors.yellow, Colors.green],
                                  initialValue: state.generalDay.nutrition,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  onChanged: (value) =>
                                      BlocProvider.of<GeneralDayBloc>(context)
                                          .add(UpdateNutrition(value)),
//                                  gradient: [Colors.red, Colors.yellow, Colors.green],
                                ),
//                            NumberScale(
//                              initialValue: state.generalDay.nutrition,
//                              onChanged: (value)=> BlocProvider.of<GeneralDayBloc>(context).add(UpdateNutrition(value)),
//                              maxNumber: 10,
//                            ),
                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  'I was able to maintain concentration in my tasks today',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                GradientSlider(
                                  gradient: [Colors.red, Colors.yellow, Colors.green],
                                  initialValue: state.generalDay.concentration,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  onChanged: (value) =>
                                      BlocProvider.of<GeneralDayBloc>(context)
                                          .add(UpdateConcentration(value)),
                                ),
//                            NumberScale(
//                              initialValue: state.generalDay.concentration,
//                              onChanged: (value)=> BlocProvider.of<GeneralDayBloc>(context).add(UpdateConcentration(value)),
//                              maxNumber: 10,
//                            ),
                                SizedBox(
                                  height: 12,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: AppStyledTextField(
                                    initialValue:
                                        state.generalDay.reflections == ''
                                            ? null
                                            : state.generalDay.reflections,
                                    minLines: 5,
                                    maxLines: 5,
                                    onChanged: (value, context) =>
                                        BlocProvider.of<GeneralDayBloc>(context)
                                            .add(UpdateReflections(value)),
                                    fieldName: 'Reflections on today',
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                BigBlueButton(
                                  text: 'Add',
                                  onPressed: () {
                                    BlocProvider.of<GeneralDayBloc>(context)
                                        .add(Submit());
//                Navigator.pop(context);
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
