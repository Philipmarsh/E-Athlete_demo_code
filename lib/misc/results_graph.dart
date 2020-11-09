import 'package:eathlete/misc/user_repository.dart';
import 'package:eathlete/models/diary_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ResultsGraph extends StatefulWidget {
  @override
  _ResultsGraphState createState() => _ResultsGraphState();
}

class _ResultsGraphState extends State<ResultsGraph> {

  @override
  Widget build(BuildContext context) {
    List graphDataList = getGraphInfo(Provider.of<UserRepository>(context));
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(offset: Offset(0.2, 0.2), color: Colors.grey, spreadRadius: 0, blurRadius: 20 )]
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SfCartesianChart(
            primaryYAxis: NumericAxis(
              isInversed: true,
              minimum: 1,

              majorGridLines: MajorGridLines(
                  dashArray: [20, 10], width: 3),
            ),
            primaryXAxis: DateTimeAxis(
              title: AxisTitle(text: 'Previous Results'),
              majorGridLines: MajorGridLines(
                width: 0
              )
            ),
            series: <ChartSeries>[
              LineSeries<ResultGraphData, DateTime>(

                dataSource: graphDataList,
                xValueMapper: ( ResultGraphData data, _) =>data.xAxis,
                yValueMapper: ( ResultGraphData data, _)=>data.yAxis,
              )
            ],
          ),
        ),
      ),
    );
  }

  List<ResultGraphData> getGraphInfo(UserRepository _userRepository){
    Box diaryBox = Hive.box('diaryBox');
    List<ResultGraphData> graphData = [];
    for(Result result in diaryBox.get('resultList')){
      ResultGraphData newResultGraphData = ResultGraphData();
      newResultGraphData.xAxis = DateTime.parse(result.date);
      newResultGraphData.yAxis = result.position;
      graphData.add(newResultGraphData);
    }
    graphData.sort((a, b)=>a.xAxis.compareTo(b.xAxis));
    return graphData;
  }
}


class ResultGraphData{
  int yAxis;
  DateTime xAxis;

  ResultGraphData({this.yAxis, this.xAxis});
}
