//import 'package:flutter/material.dart';
//import 'package:syncfusion_flutter_charts/charts.dart';
//
//
//class SimpleLineChart extends StatelessWidget {
//  final tableData1;
//  final tableData2;
//  final List<charts.TickSpec<DateTime>> days;
//
//  final bool animate;
//
//  SimpleLineChart({this.animate, this.tableData1, this.tableData2, this.days});
//
//  @override
//  Widget build(BuildContext context) {
//    List<charts.Series<GraphObject, DateTime>> myList = [];
//    print(tableData1);
//
//    if (tableData1 != null) {
//      myList.add(charts.Series(
//          data: tableData1,
//          measureFn: (GraphObject linearSales, _) => linearSales.yAxis,
//          domainFn: (GraphObject linearSales, _) => linearSales.xAxis,
//          id: 'Graph 1',
//          displayName: 'Graph 1'));
//    }
//    if (tableData2 != null) {
//      myList.add(charts.Series(
//          data: tableData2,
//          measureFn: (GraphObject linearSales, _) => linearSales.yAxis,
//          domainFn: (GraphObject linearSales, _) => linearSales.xAxis,
//          id: 'Graph 2',
//          displayName: 'Graph 2'));
//    }
//
//    return charts.TimeSeriesChart(
//      myList,
//      animate: true,
//      domainAxis: new charts.DateTimeAxisSpec(
//          tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
//              day: new charts.TimeFormatterSpec(
//                  format: 'd', transitionFormat: 'dd/MMM')),
//          tickProviderSpec: charts.StaticDateTimeTickProviderSpec(
//            days,
//          )),
//      animationDuration: Duration(seconds: 1),
//    );
//  }
//}


///old way of getting graph data

//    for (var i = 0; i < numberOfDays; i++) {
//      DateTime _currentDay =
//          DateTime(lastDay.year, lastDay.month, lastDay.day - i);
//      List _currentDayEvents = generalDayMap[_currentDay];
//      if (_currentDayEvents != null) {
//        lastSevenDaysSessions.add([_currentDay, _currentDayEvents]);
//      }
//    }

///old graph controls
//                      Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: <Widget>[
//                          Row(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: <Widget>[
//                              IconButton(
//                                icon: Icon(
//                                  Icons.chevron_left,
//                                ),
//                                onPressed: () {
////                                  BlocProvider.of<GraphBloc>(context).add(ChangeTimeViewBack());
////                                  zoomPan.panToDirection('left');
//                                },
//                              ),
//                              Text(state.lengthOfTime),
//                              IconButton(
//                                icon: Icon(Icons.chevron_right),
//                                onPressed: () {
////                                  BlocProvider.of<GraphBloc>(context).add(ChangeTimeViewForward());
////                                  zoomPan.panToDirection('right');
//                                },
//                              ),
//                            ],
//                          ),
//                          Padding(
//                            padding: const EdgeInsets.symmetric(horizontal: 10),
//                            child: MaterialButton(
//                              textColor: Colors.blue,
//                              shape: RoundedRectangleBorder(
//                                  borderRadius: BorderRadius.circular(30.0),
//                                  side: BorderSide(color: Colors.blue)),
//                              child: Text('${state.timePeriodName}'),
//                              onPressed: () {
//                                BlocProvider.of<GraphBloc>(context)
//                                    .add(ChangeTimeViewTimeFrame());
//                                //need to allow to zoom out to month
////                                if (zoomDouble == 0.3) {
////                                  zoomDouble = 0.7;
////                                } else {
////                                  zoomDouble = 0.3;
////                                }
////                                zoomPan.zoomToSingleAxis(
////                                    xAxis, 0.9, zoomDouble);
//                              },
//                            ),
//                          ),
//                        ],
//                      ),


//SizedBox(
//height: 350,
//child: AnimatedList(
//initialItemCount: state.currentDayList.length,
//itemBuilder: (BuildContext context, int index, Animation animation){
//DiaryModel event = state.currentDayList[index];
//if(event is Competition){
//return CompetitionDiaryEntry(event,
//onDelete: () {
//print('Deleting Competition');
//},);
//}else if(event is GeneralDay){
//return GeneralDayEntry(
//generalDay: event,
//onDelete: () {
//print('deleting general Day');
//},
//);
//}else if(event is Session){
//return SessionEntry(
//session: event,
//onDelete: (){print('Deleting Session');},
//);
//}else if(event is Result){
//return ResultEntry(
//result: event,
//onDelete: (){print('deleting Result');},
//);
//}else{
//return Container();
//}
//},
//),
//)