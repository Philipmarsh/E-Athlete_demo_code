
import 'package:eathlete/misc/user_repository.dart';
import 'package:eathlete/models/goal_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_charts/charts.dart';



class GoalsAchievedGraph extends StatefulWidget {
  final UserRepository userRepository;
  List<ChartData> chartData = [
    ChartData(xAxis: 'Ongoing', yAxis: 4),


  ];
  List<ChartData> chartData1 = [
    ChartData(xAxis: 'Achieved', yAxis: 3),
  ];
  List<ChartData> chartData2 = [
    ChartData(xAxis: 'Not Achieved', yAxis: 2)
  ];


  GoalsAchievedGraph(this.userRepository);

  @override
  _GoalsAchievedGraphState createState() => _GoalsAchievedGraphState();
}

class _GoalsAchievedGraphState extends State<GoalsAchievedGraph> {

  List<ChartData> goalsAchieved=[];
  List<ChartData> goalsNotAchieved=[];
  List<ChartData> ongoingGoals=[];



  @override
  Widget build(BuildContext context) {
    getGraphInfo();
    return Container(
      child:SfCartesianChart(

primaryXAxis: CategoryAxis(
  majorGridLines: MajorGridLines(
    width: 0
  )
),
        primaryYAxis: NumericAxis(
          majorGridLines: MajorGridLines(
              dashArray: [20, 10], width: 3),
        ),
        series: <ChartSeries>[
          ColumnSeries<ChartData, String>(
            dataSource:goalsAchieved,
            xValueMapper: ( ChartData data, _) =>data.xAxis,
            yValueMapper: (ChartData data, _) =>data.yAxis,
            borderRadius: BorderRadius.all(Radius.circular(140)),

            color: Colors.green
          ),
          ColumnSeries<ChartData, String>(
              dataSource: goalsNotAchieved,
              xValueMapper: ( ChartData data, _) =>data.xAxis,
              yValueMapper: (ChartData data, _) =>data.yAxis,
              borderRadius: BorderRadius.all(Radius.circular(140)),
              color: Colors.red
          ),
          ColumnSeries<ChartData, String>(
              dataSource: ongoingGoals,
              xValueMapper: ( ChartData data, _) =>data.xAxis,
              yValueMapper: (ChartData data, _) =>data.yAxis,
              borderRadius: BorderRadius.all(Radius.circular(140)),
              color: Colors.blue
          ),
        ],
      ),
    );
  }
  void getGraphInfo(){
    int numberOfAchieved = 0;
    int numberOfNotAchieved = 0;
    int numberOfOngoing = 0;
    var diaryBox = Hive.box('diaryBox');
    for(Goal goal in diaryBox.get('finishedGoals')){
      if(goal.achieved == 'true')numberOfAchieved += 1;
      else numberOfNotAchieved +=1;
    }
    for(Goal goal in diaryBox.get('shortTermGoals')){
      numberOfOngoing +=1;
    }
    for(Goal goal in diaryBox.get('mediumTermGoals')){
      numberOfOngoing +=1;
    }
    for(Goal goal in diaryBox.get('longTermGoals')){
      numberOfOngoing +=1;
    }

    goalsAchieved=[ChartData(xAxis: 'Achieved', yAxis: numberOfAchieved)];
    goalsNotAchieved = [ChartData(xAxis: 'Not Achieved', yAxis: numberOfNotAchieved)];
    ongoingGoals = [ChartData(xAxis: 'Ongoing', yAxis: numberOfOngoing)];
  }
}


class ChartData{
  int yAxis;
  String xAxis;

  ChartData({this.yAxis, this.xAxis});
}