import 'package:eathlete/blocs/result/result_bloc.dart';
import 'package:eathlete/common_widgets/common_widgets.dart';
import 'package:eathlete/common_widgets/diary_widgets.dart';
import 'package:eathlete/misc/results_graph.dart';
import 'package:eathlete/misc/user_repository.dart';
import 'package:eathlete/models/diary_model.dart';
import 'package:eathlete/screens/Result_update_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class Results extends StatefulWidget {
  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  Box diaryBox = Hive.box('diaryBox');
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: (){
          showModalBottomSheet(context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (builder){
                return BlocProvider(
                  create: (context) => ResultBloc(
                      Provider.of<UserRepository>(context,
                          listen: false)),
                  child: ResultUpdateBody(),
                );
              });
        },
        child: Icon(Icons.add, color: Colors.white,),
      ),
      key: GlobalKey(),
      drawer: EAthleteDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {return IconButton(
            icon: ImageIcon(AssetImage('images/menu_icon@3x.png'), color: Color(0xff828289),),
            onPressed: (){Scaffold.of(context).openDrawer();},
          );},
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
              style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            )
          ],
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('diaryBox').listenable(),
        builder: (context, box, widget){
          List resultList = box.get('resultList');
          List<Result> resultListReversed = List.from(resultList.reversed);
          return Container(
          child: Column(
            children: <Widget>[
              ResultsGraph(),
              Expanded(
                // TODO: add valueListener
                child: RefreshIndicator(
                  onRefresh: () async {
                    diaryBox.put('resultList',
                    await getResultList(
                        await Provider.of<UserRepository>(context, listen: false).refreshIdToken()));
                    setState(() {

                    });


                  },
                  child: AnimatedList(
                      padding: EdgeInsets.only(bottom: 100),
                      initialItemCount:
                      box.get('resultList').length,

                      itemBuilder: (context, int index, Animation animation) {

                        Result _result = resultListReversed[index];
                        return ResultEntry(
                          index: index,
                          result: _result,
                          onDelete: ()async {
                            resultListReversed.remove(_result);
                            setState(() {
                            });

                          },
                        );
                      }),
                ),
              ),
            ],
          ),
        );}
      ),
    );
  }
}
