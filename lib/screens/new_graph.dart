//

import 'package:eathlete/misc/useful_functions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

//ignore:must_be_immutable
//class ButtonZooming extends StatefulWidget {
//  ButtonZooming({this.sample, Key key}) : super(key: key);
//  ;
//
//  @override
//  _ButtonZoomingState createState() => _ButtonZoomingState(sample);
//}

//ZoomPanBehavior zoomPan;
//final List<ChartSampleData> zoomData = <ChartSampleData>[
//  ChartSampleData(x: 1.5, y: 21),
//  ChartSampleData(x: 2.2, y: 24),
//  ChartSampleData(x: 3.32, y: 36),
//  ChartSampleData(x: 4.56, y: 38),
//  ChartSampleData(x: 5.87, y: 54),
//  ChartSampleData(x: 6.8, y: 57),
//  ChartSampleData(x: 8.5, y: 70),
//  ChartSampleData(x: 9.5, y: 21),
//  ChartSampleData(x: 10.2, y: 24),
//  ChartSampleData(x: 11.32, y: 36),
//  ChartSampleData(x: 14.56, y: 38),
//  ChartSampleData(x: 15.87, y: 54),
//  ChartSampleData(x: 16.8, y: 57),
//  ChartSampleData(x: 18.5, y: 23),
//  ChartSampleData(x: 21.5, y: 21),
//  ChartSampleData(x: 22.2, y: 24),
//  ChartSampleData(x: 23.32, y: 36),
//  ChartSampleData(x: 24.56, y: 32),
//  ChartSampleData(x: 25.87, y: 54),
//  ChartSampleData(x: 26.8, y: 12),
//  ChartSampleData(x: 28.5, y: 54),
//  ChartSampleData(x: 30.2, y: 24),
//  ChartSampleData(x: 31.32, y: 36),
//  ChartSampleData(x: 34.56, y: 38),
//  ChartSampleData(x: 35.87, y: 14),
//  ChartSampleData(x: 36.8, y: 57),
//  ChartSampleData(x: 38.5, y: 70),
//  ChartSampleData(x: 41.5, y: 21),
//  ChartSampleData(x: 41.2, y: 24),
//  ChartSampleData(x: 43.32, y: 36),
//  ChartSampleData(x: 44.56, y: 21),
//  ChartSampleData(x: 45.87, y: 54),
//  ChartSampleData(x: 46.8, y: 57),
//  ChartSampleData(x: 48.5, y: 54),
//  ChartSampleData(x: 49.56, y: 38),
//  ChartSampleData(x: 49.87, y: 14),
//  ChartSampleData(x: 51.8, y: 57),
//  ChartSampleData(x: 54.5, y: 32),
//  ChartSampleData(x: 55.5, y: 21),
//  ChartSampleData(x: 57.2, y: 24),
//  ChartSampleData(x: 59.32, y: 36),
//  ChartSampleData(x: 60.56, y: 21),
//  ChartSampleData(x: 62.87, y: 54),
//  ChartSampleData(x: 63.8, y: 23),
//  ChartSampleData(x: 65.5, y: 54)
//];

//class _ButtonZoomingState extends State<ButtonZooming> {
//  _ButtonZoomingState(this.sample);
//  final SubItem sample;

//  @override
//  Widget build(BuildContext context) {
//    zoomPan = ZoomPanBehavior(
//      enableDoubleTapZooming: true,
//      enablePanning: true,
//      enablePinching: true,
//      enableSelectionZooming: true,
//    );
//    return getScopedModel(null, sample, ZoomingWithButtonFrontPanel(sample));
//  }
//}

//SfCartesianChart getButtonZoomingChart(bool isTileView) {
//  return SfCartesianChart(
//    plotAreaBorderWidth: 0,
//    primaryXAxis: NumericAxis(majorGridLines: MajorGridLines(width: 0)),
//    primaryYAxis: NumericAxis(
//        axisLine: AxisLine(width: 0), majorTickLines: MajorTickLines(size: 0)),
//    series: getButtonZoomingSeries(isTileView),
//    zoomPanBehavior: zoomPan,
//  );
//}
//
//List<LineSeries<ChartSampleData, num>> getButtonZoomingSeries(bool isTileView) {
//  return <LineSeries<ChartSampleData, num>>[
//    LineSeries<ChartSampleData, num>(
//        dataSource: zoomData,
//        xValueMapper: (ChartSampleData sales, _) => sales.x,
//        yValueMapper: (ChartSampleData sales, _) => sales.y,
//        width: 2)
//  ];
//}
//
////ignore: must_be_immutable
//class ZoomingWithButtonFrontPanel extends StatefulWidget {
//  //ignore: prefer_const_constructors_in_immutables
//  ZoomingWithButtonFrontPanel([this.sample]);
//  SubItem sample;
//
//  @override
//  _ZoomingWithButtonFrontPanelState createState() =>
//      _ZoomingWithButtonFrontPanelState(sample);
//}
//
//class _ZoomingWithButtonFrontPanelState
//    extends State<ZoomingWithButtonFrontPanel> {
//  _ZoomingWithButtonFrontPanelState(this.sample);
//  final SubItem sample;
//  Widget sampleWidget(SampleModel model) => getButtonZoomingChart(false);
//  @override
//  Widget build(BuildContext context) {
//    return ScopedModelDescendant<SampleModel>(
//        rebuildOnChange: true,
//        builder: (BuildContext context, _, SampleModel model) {
//          return Scaffold(
//              backgroundColor: model.cardThemeColor,
//              body: Padding(
//                padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
//                child: Container(child: getButtonZoomingChart(false)),
//              ),
//              floatingActionButton: Container(
//                child: Stack(children: <Widget>[
//                  Align(
//                    alignment: Alignment.bottomCenter,
//                    child: Container(
//                      height: 50,
//                      child: InkWell(
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            Padding(
//                              padding: const EdgeInsets.fromLTRB(24, 15, 0, 0),
//                              child: Tooltip(
//                                message: 'Zoom In',
//                                child: IconButton(
//                                  icon: Icon(Icons.add,
//                                      color: model.backgroundColor),
//                                  onPressed: () {
//                                    zoomPan.zoomIn();
//                                  },
//                                ),
//                              ),
//                            ),
//                            Padding(
//                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
//                              child: Tooltip(
//                                message: 'Zoom Out',
//                                child: IconButton(
//                                  icon: Icon(Icons.remove,
//                                      color: model.backgroundColor),
//                                  onPressed: () {
//                                    zoomPan.zoomOut();
//                                  },
//                                ),
//                              ),
//                            ),
//                            Padding(
//                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
//                              child: Tooltip(
//                                message: 'Pan Up',
//                                child: IconButton(
//                                  icon: Icon(Icons.keyboard_arrow_up,
//                                      color: model.backgroundColor),
//                                  onPressed: () {
//                                    zoomPan.panToDirection('top');
//                                  },
//                                ),
//                              ),
//                            ),
//                            Padding(
//                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
//                              child: Tooltip(
//                                message: 'Pan Down',
//                                child: IconButton(
//                                  icon: Icon(Icons.keyboard_arrow_down,
//                                      color: model.backgroundColor),
//                                  onPressed: () {
//                                    zoomPan.panToDirection('bottom');
//                                  },
//                                ),
//                              ),
//                            ),
//                            Padding(
//                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
//                              child: Tooltip(
//                                message: 'Pan Left',
//                                child: IconButton(
//                                  icon: Icon(Icons.keyboard_arrow_left,
//                                      color: model.backgroundColor),
//                                  onPressed: () {
//                                    zoomPan.panToDirection('left');
//                                  },
//                                ),
//                              ),
//                            ),
//                            Padding(
//                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
//                              child: Tooltip(
//                                message: 'Pan Right',
//                                child: IconButton(
//                                  icon: Icon(Icons.keyboard_arrow_right,
//                                      color: model.backgroundColor),
//                                  onPressed: () {
//                                    zoomPan.panToDirection('right');
//                                  },
//                                ),
//                              ),
//                            ),
//                            Padding(
//                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
//                              child: Tooltip(
//                                message: 'Reset',
//                                child: IconButton(
//                                  icon: Icon(Icons.refresh,
//                                      color: model.backgroundColor),
//                                  onPressed: () {
//                                    zoomPan.reset();
//                                  },
//                                ),
//                              ),
//                            )
//                          ],
//                        ),
//                      ),
//                    ),
//                  )
//                ]),
//              ));
//        });
//  }
//}

class ChartSampleData {
  final DateTime x;
  final double y;

  ChartSampleData({this.x, this.y});
}

//import 'package:flutter/material.dart';
//import 'package:fl_chart/fl_chart.dart';
//
//class NewGraphTest extends StatefulWidget {
//  @override
//  _NewGraphTestState createState() => _NewGraphTestState();
//}
//
//class _NewGraphTestState extends State<NewGraphTest> {
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//        height: 300,
//        decoration: BoxDecoration(color: Colors.white),
//        child: Column(
//          children: <Widget>[
//            SizedBox(
//              height: 300,
//            ),
//            Expanded(
//              child: LineChart(
//                LineChartData(
//                    borderData: FlBorderData(show: false),
//                    axisTitleData: FlAxisTitleData(
//                        bottomTitle:
//                            AxisTitle(showTitle: true, titleText: 'My Graph'),
//                        show: true,
//                        topTitle: AxisTitle(titleText: 'My lovely Graph')),
//                    backgroundColor: Colors.white,
//                    maxX: 1,
//                    maxY: 1,
//                    minX: 0,
//                    minY: 0,
//                    extraLinesData: ExtraLinesData(horizontalLines:
//                    [
////                      HorizontalLine(y: 0.1, color: Colors.grey, dashArray: [5, 5]),
////                      HorizontalLine(y: 0.2, color: Colors.grey, dashArray: [5, 5]),
////                      HorizontalLine(y: 0.3, color: Colors.grey, dashArray: [5, 5]),
////                      HorizontalLine(y: 0.4, color: Colors.grey, dashArray: [5, 5]),
////                      HorizontalLine(y: 0.5, color: Colors.grey, dashArray: [5, 5]),
////                      HorizontalLine(y: 0.6, color: Colors.grey, dashArray: [5, 5]),
////                      HorizontalLine(y: 0.7, color: Colors.grey, dashArray: [5, 5]),
////                      HorizontalLine(y: 0.8, color: Colors.grey, dashArray: [5, 5]),
////                      HorizontalLine(y: 0.9, color: Colors.grey, dashArray: [5, 5]),
//
//                    ]),
//                    gridData: FlGridData(
//                      horizontalInterval: 0.1,
//                      show: true,
//                      drawHorizontalLine: true,
//                      verticalInterval: 0.1
//                    ),
//                    lineBarsData: [
//                      LineChartBarData(
//                          colors: [Colors.blue],
//                          dotData: FlDotData(show: false),
//                          show: true,
//                          barWidth: 5,
//                          spots: [
//                            FlSpot(0.1, 0.4),
//                            FlSpot(0.2, 0.2),
//                            FlSpot(0.3, 0.9),
//                            FlSpot(0.4, 0.5),
//                            FlSpot(1, 1),
//
//                          ],
//                          isCurved: true,
//                          preventCurveOverShooting: true,
//                          shadow: Shadow(color: Colors.blue, offset: Offset(3, 3), blurRadius: 13))
//                    ],
//                    rangeAnnotations: RangeAnnotations(horizontalRangeAnnotations:[HorizontalRangeAnnotation(y1: 0, y2: 2)]),
//                    titlesData: FlTitlesData(
//                      bottomTitles: SideTitles(
//                        showTitles: true,
//                        reservedSize: 3,
//                        textStyle: const TextStyle(
//                          color: Color(0xff72719b),
//                          fontWeight: FontWeight.bold,
//                          fontSize: 16,
//                        ),
//                      ),
//                    )),
//                swapAnimationDuration: Duration(milliseconds: 400),
//              ),
//            ),
//            SizedBox(
//              height: 200,
//            )
//          ],
//        ));
//  }
//}

class NewAttemptAtGraph extends StatefulWidget {
  @override
  _NewAttemptAtGraphState createState() => _NewAttemptAtGraphState();
}

class _NewAttemptAtGraphState extends State<NewAttemptAtGraph> {
  var xAxis = DateTimeAxis(
      majorGridLines: MajorGridLines(width: 0),
//      visibleMaximum: currentDay,
//      visibleMinimum: currentDay.subtract(Duration(hours: 83))
  );
  ZoomPanBehavior zoomPan;
  final List<ChartSampleData> zoomData = <ChartSampleData>[
    ChartSampleData(x: DateTime(2020, 6, 20), y: 21),
    ChartSampleData(x: DateTime(2020, 6, 19), y: 24),
    ChartSampleData(x: DateTime(2020, 6, 18), y: 36),
//    ChartSampleData(x: DateTime(2020, 6, 17), y: 38),
//    ChartSampleData(x: DateTime(2020, 6, 16), y: 54),
//    ChartSampleData(x: DateTime(2020, 6, 15), y: 57),
//    ChartSampleData(x: DateTime(2020, 6, 14), y: 70),
//    ChartSampleData(x: DateTime(2020, 6, 13), y: 21),
//    ChartSampleData(x: DateTime(2020, 6, 12), y: 24),
//    ChartSampleData(x: DateTime(2020, 6, 11), y: 36),
//    ChartSampleData(x: DateTime(2020, 6, 10), y: 38),
//    ChartSampleData(x: DateTime(2020, 6, 9), y: 54),
//    ChartSampleData(x: DateTime(2020, 6, 8), y: 57),
//    ChartSampleData(x: DateTime(2020, 6, 7), y: 23),
//    ChartSampleData(x: DateTime(2020, 6, 6), y: 21),
//    ChartSampleData(x: DateTime(2020, 6, 5), y: 24),
//    ChartSampleData(x: DateTime(2020, 6, 4), y: 36),
//    ChartSampleData(x: DateTime(2020, 6, 3), y: 32),
//    ChartSampleData(x: DateTime(2020, 6, 2), y: 54),
//    ChartSampleData(x: DateTime(2020, 6, 1), y: 12),
//    ChartSampleData(x: DateTime(2020, 5, 31), y: 54),
//    ChartSampleData(x: DateTime(2020, 5, 30), y: 24),
//    ChartSampleData(x: DateTime(2020, 5, 29), y: 36),
//    ChartSampleData(x: DateTime(2020, 5, 28), y: 38),
//    ChartSampleData(x: DateTime(2020, 5, 27), y: 14),
//    ChartSampleData(x: DateTime(2020, 5, 26), y: 57),
//    ChartSampleData(x: DateTime(2020, 5, 25), y: 70),
//    ChartSampleData(x: DateTime(2020, 5, 24), y: 21),
//    ChartSampleData(x: DateTime(2020, 5, 23), y: 24),
//    ChartSampleData(x: DateTime(2020, 5, 22), y: 36),
//    ChartSampleData(x: DateTime(2020, 5, 21), y: 21),
//    ChartSampleData(x: DateTime(2020, 5, 20), y: 54),
//    ChartSampleData(x: DateTime(2020, 5, 19), y: 57),
//    ChartSampleData(x: DateTime(2020, 5, 18), y: 54),
//    ChartSampleData(x: DateTime(2020, 5, 17), y: 38),
//    ChartSampleData(x: DateTime(2020, 5, 16), y: 14),
//    ChartSampleData(x: DateTime(2020, 5, 15), y: 57),
//    ChartSampleData(x: DateTime(2020, 5, 14), y: 32),
//    ChartSampleData(x: DateTime(2020, 5, 13), y: 21),
//    ChartSampleData(x: DateTime(2020, 5, 12), y: 24),
//    ChartSampleData(x: DateTime(2020, 5, 11), y: 36),
//    ChartSampleData(x: DateTime(2020, 5, 10), y: 21),
//    ChartSampleData(x: DateTime(2020, 5, 9), y: 54),
//    ChartSampleData(x: DateTime(2020, 5, 8), y: 23),
//    ChartSampleData(x: DateTime(2020, 5, 7), y: 54)
  ];

  double zoomPosition;
  double zoomFactor;
  @override
  Widget build(BuildContext context) {
//    Duration difference = zoomData[0].x.difference(zoomData[-1].x);
//    int differenceInDays = difference.inDays;

    zoomPan = ZoomPanBehavior(
        enableDoubleTapZooming: true,
        enablePanning: true,
        enablePinching: true,
        enableSelectionZooming: true,
        maximumZoomLevel: 2,
        zoomMode: ZoomMode.x);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                MaterialButton(
                  child: Text('zoom in'),
                  onPressed: () {
                    zoom();
                  },
                ),
                MaterialButton(
                  child: Text('zoom out'),
                  onPressed: () {
                    zoomOut();
                  },
                ),
                MaterialButton(
                  child: Text('move left'),
                  onPressed: () {
                    zoomPan.panToDirection('left');
                  },
                ),
                MaterialButton(
                  child: Text('move right'),
                  onPressed: () {
                    zoomPan.panToDirection('right');
                  },
                )
              ],
            ),
            Container(
              child: SfCartesianChart(
                zoomPanBehavior: zoomPan,
                plotAreaBorderWidth: 0,
                primaryXAxis: xAxis,
                primaryYAxis: NumericAxis(
                  maximum: 80,
                  minimum: 0,
                ),
                series: <SplineSeries<ChartSampleData, DateTime>>[
                  SplineSeries(
                    splineType: SplineType.monotonic,
                      dataSource: zoomData,
                      xValueMapper: (ChartSampleData sales, _) => sales.x,
                      yValueMapper: (ChartSampleData sales, _) => sales.y,
                      width: 2)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void zoomOut() {
    zoomPosition = 0.5;
    zoomFactor = 1;
    zoomPan.zoomToSingleAxis(xAxis, zoomPosition, zoomFactor);
  }

  void zoom() {
    final double zoomPosition = 0.5;
    final double zoomFactor = 0.4;
    zoomPan.zoomToSingleAxis(xAxis, zoomPosition, zoomFactor);
  }
}
