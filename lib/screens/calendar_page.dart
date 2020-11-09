import 'package:eathlete/blocs/calendar/calendar_bloc.dart';
import 'package:eathlete/blocs/competition/competition_bloc.dart';
import 'package:eathlete/common_widgets/diary_widgets.dart';
import 'package:eathlete/misc/useful_functions.dart';
import 'package:eathlete/models/diary_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/class_definitions.dart';
import '../common_widgets/common_widgets.dart';
import '../misc/user_repository.dart';
import 'competition_entry.dart';

class CalendarPage extends StatelessWidget {
  CalendarPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CalendarBloc(
          userRepository: Provider.of<UserRepository>(context, listen: false)),
      child: CalendarPageContent(),
    );
  }
}

class CalendarPageContent extends StatefulWidget {
  @override
  _CalendarPageContentState createState() => _CalendarPageContentState();
}

class _CalendarPageContentState extends State<CalendarPageContent> {
  List<Widget> currentDayWidgetList = <Widget>[];
  Box diaryBox = Hive.box('diaryBox');
  @override
  Widget build(BuildContext context) {

    return BlocBuilder(
        bloc: BlocProvider.of<CalendarBloc>(context),
        builder: (context, CalendarState state) {
          void convertListToWidgets(List events) {
            currentDayWidgetList = <Widget>[];
            int index = 0;
            for (var entry in events) {
              if (entry is Competition) {
// TODO: check what is happening here, and make sure things are being deleted correctly
                print(entry.name);
                currentDayWidgetList.add(CompetitionDiaryEntry(
                  entry,
                  index: index,
                  onDelete: () {
                    final thisIndex = index;
                    state.currentDayList.removeWhere((element) => element is Competition && element.id == entry.id);
                    print('Deleting Competition');
                    List competitionList = diaryBox.get('competitionList');
                    competitionList.removeWhere((element) => element.id == entry.id);
                    diaryBox.put('competitionList', competitionList);
                    setState(() {});
                  },
                ));
                index++;
              } else if (entry is Session) {
                currentDayWidgetList.add(SessionEntry(
                  index: index,
                  session: entry,
                  onDelete: (){print('Deleting Session');
                  state.currentDayList.removeWhere((element) => element is Session && element.id == entry.id);
                  List sessionList = diaryBox.get('sessionList');
                  sessionList.removeWhere((element) => element.id == entry.id);
                  diaryBox.put('sessionList', sessionList);
                  setState(() {});
                  },
                ));
                index++;
              } else if (entry is GeneralDay) {
                currentDayWidgetList.add(GeneralDayEntry(
                  index: index,
                  generalDay: entry,
                  onDelete: () {
                    print('deleting general Day');
                    state.currentDayList.removeWhere((element) => element is GeneralDay && element.id == entry.id);
                    List generalDayList = diaryBox.get('generalDayList');
                    generalDayList.removeWhere((element) => element.id == entry.id);
                    diaryBox.put('generalDayList', generalDayList);
                    setState(() {});

                  },
                ));
                index++;
              } else if (entry is Result) {
                currentDayWidgetList.add(ResultEntry(
                  index: index,
                  result: entry,
                  onDelete: (){print('deleting Result');
                  state.currentDayList.removeWhere((element) => element is Result && element.id == entry.id);
                  //TODO: remove 1 from the competition map here.
                  List resultList = diaryBox.get('resultList');
                  resultList.removeWhere((element) => element.id == entry.id);
                  diaryBox.put('resultList', resultList);
                  setState(() {});},
                ));
                index++;
              }

            }

          }

          convertListToWidgets(state.currentDayList);
          print(currentDayWidgetList);

          return Column(
            children: <Widget>[
              AppBar(
                leading: IconButton(
                  icon: ImageIcon(
                    AssetImage('images/menu_icon@3x.png'),
                    color: Color(0xff828289),
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
                elevation: 1,
                actions: <Widget>[NotificationButton()],
                backgroundColor: Colors.white,
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        height: 50,
                        child: Image.asset('images/51012169_padded_logo.png', scale: 2,)),
                    Text(
                      'E-Athlete',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    )
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    diaryBox.put('competitionList',
                        await getCompetitionList(
                            await Provider.of<UserRepository>(context,
                                    listen: false)
                                .refreshIdToken()));
                    setState(() {});
                    // TODO: add a value listener widget here
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        TableCalendar(
                          calendarActionButton: CalendarActionButton(
                              child: Row(
                                children: <Widget>[
//              Icon(Icons.add, color: Colors.white,),
                                  Text(
                                    'Add Event',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (builder) {
                                      return Container(
                                        child: BlocProvider(
                                            create: (context) =>
                                                CompetitionBloc(
                                                    Provider.of<UserRepository>(
                                                        context,
                                                        listen: false)),
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom),
                                                child: SingleChildScrollView(
                                                    child: CompetitionEntry()),
                                              ),
                                            )),
                                      );
                                    });
                              }),
                          headerStyle: HeaderStyle(
                            rightChevronPadding:
                                EdgeInsets.symmetric(horizontal: 0),
                            leftChevronPadding:
                                EdgeInsets.symmetric(horizontal: 0),
                            formatButtonVisible: false,
                          ),
                          events: state.competitionMap,
                          onDaySelected: (DateTime datetime, List events) {
                            BlocProvider.of<CalendarBloc>(context).add(
                                ChangeDay(
                                    currentDay: DateTime(datetime.year,
                                        datetime.month, datetime.day)));
                          },
                          onDayLongPressed: (datetime, newList) {
                            print(datetime);
                            showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (builder) {
                                  return BlocProvider(
                                      create: (context) => CompetitionBloc(
                                          Provider.of<UserRepository>(context,
                                              listen: false),
                                          competition: Competition(
                                              date:
                                                  '${datetime.year}-${timeToString(datetime.month)}-${timeToString(datetime.day)}')),
                                      child: CompetitionEntry());
                                });
                          },
                          availableCalendarFormats: {
                            CalendarFormat.month: 'month'
                          },
                          daysOfWeekStyle: DaysOfWeekStyle(
                            weekendStyle: TextStyle(color: Colors.grey),
                          ),
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          calendarStyle: CalendarStyle(
                            contentPadding: EdgeInsets.all(0),
                            outsideDaysVisible: false,
                            todayColor: Colors.blueGrey,
                            selectedColor: Colors.blue,
                            weekendStyle: TextStyle(color: Colors.grey),
                          ),
                          calendarController: Provider.of<PageNumber>(context)
                              .calendarController,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 8, bottom: 8),
                          child: Divider(
//            color: Colors.grey,
                              ),
                        ),
                        Column(
                          children: <Widget>[] + currentDayWidgetList + <Widget>[SizedBox(height: 80,)],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

}


