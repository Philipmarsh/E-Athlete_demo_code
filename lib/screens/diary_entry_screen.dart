import 'package:eathlete/common_widgets/diary_widgets.dart';
import 'package:eathlete/models/diary_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../common_widgets/common_widgets.dart';
import '../misc/database.dart';
import '../misc/user_repository.dart';

class DiaryEntryPage extends StatefulWidget {
  static const String id = 'home page';

  @override
  _DiaryEntryPageState createState() => _DiaryEntryPageState();
}

class _DiaryEntryPageState extends State<DiaryEntryPage>
    with TickerProviderStateMixin {
  List<Widget> _children = [SessionPage(), GeneralDayAnimatedListPage()];
  Box diaryBox = Hive.box('diaryBox');

  int _currentIndex = 0;
  TabController tabController;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      vsync: this,
      length: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                  height: 50,
                  child: Image.asset('images/51012169_padded_logo.png', scale: 2,)),
              Text(
                'E-Athlete',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              )
            ],
          ),
          bottom: TabBar(
            indicatorWeight: 2,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Color(0xff23232f),
            labelStyle: TextStyle(fontSize: 10),
            unselectedLabelColor: Colors.grey,
            controller: tabController,
            onTap: onTabTapped,
            tabs: <Widget>[
              Tab(
                text: 'Session',
              ),
              Tab(
                text: 'General Day',
              ),
            ],
          ),
        ),
        body: TabBarView(
      children: _children,
      controller: tabController,
    ));
  }
}

class SessionPage extends StatefulWidget {
  SessionPage({Key key}) : super(key: key);

  @override
  _SessionPageState createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  Box diaryBox = Hive.box('diaryBox');

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder(
      valueListenable: diaryBox.listenable(),
      builder:(context, box, widget){
        List sessionList = box.get('sessionList');
        List<Session> sessionListReversed = List.from(sessionList.reversed);
        return RefreshIndicator(
        onRefresh: () async {
          diaryBox.put('sessionList',
              await getSessionList(
                  await Provider.of<UserRepository>(context, listen: false).refreshIdToken()));
          setState(() {

          });
          // DBHelper.deleteDataFromTable('Sessions');
          // DBHelper.updateSessionsList(Provider.of<UserRepository>(context, listen: false).diary.sessionList);

        },
        child: AnimatedList(
          padding: EdgeInsets.only(bottom: 100),
            initialItemCount:
                diaryBox.get('sessionList').length,
                // Provider.of<UserRepository>(context, listen: false).diary.sessionList.length,

            itemBuilder: (context, int index, Animation animation) {

              Session _session =
                 sessionListReversed[index];
              return SessionEntry(
                session: _session,
                index: index,
                onDelete: ()async {
                  sessionListReversed.remove(_session);

                  setState(() {

                  });

                },
              );
            }),
      );},
    );
  }
}


class GeneralDayAnimatedListPage extends StatefulWidget {
  @override
  _GeneralDayAnimatedListPageState createState() => _GeneralDayAnimatedListPageState();
}

class _GeneralDayAnimatedListPageState extends State<GeneralDayAnimatedListPage> {
  Box diaryBox = Hive.box('diaryBox');
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: diaryBox.listenable(),
      builder:(context, box, widget){
        List generalDayList = box.get('generalDayList');
        List<GeneralDay> generalDayListReversed = List.from(generalDayList.reversed);
        return RefreshIndicator(
          onRefresh: ()async {
        diaryBox.put('generalDayList',
            await getGeneralDayList(
            await Provider.of<UserRepository>(context, listen: false).refreshIdToken()));
      setState(() {

      });
      // DBHelper.deleteDataFromTable('GeneralDays');
      // DBHelper.updateGeneralDayList(Provider.of<UserRepository>(context, listen: false).diary.generalDayList);
  },
      child: AnimatedList(
        padding: EdgeInsets.only(bottom: 100),
        initialItemCount: diaryBox.get('generalDayList').length,
        itemBuilder: (BuildContext context, index, animation){
          GeneralDay _generalDay =
          generalDayListReversed[index];
          return GeneralDayEntry(
            key: UniqueKey(),
            index: index,
            generalDay: _generalDay,
            onDelete: ()async{
              generalDayListReversed.remove(_generalDay);
              setState(() {

              });
            },
          );
        },
      ));},
    );
  }
}






