import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProjectStatistics extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                  color: Color(0x38F8F8F8),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                    child: Text(
                      "Trains enroute",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  LineChart(LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: SideTitles(
                              showTitles: true,
                              getTextStyles: (value) =>
                                  Theme.of(context).textTheme.subtitle1!,
                              getTitles: (value) {
                                switch (value.toInt()) {
                                  case 0:
                                    return "10:00";
                                  case 1:
                                    return "10:05";
                                  case 2:
                                    return "10:10";
                                  case 3:
                                    return "10:15";
                                  case 4:
                                    return "10:20";
                                  case 5:
                                    return "10:25";
                                  case 6:
                                    return "10:30";
                                  case 7:
                                    return "10:35";
                                  case 8:
                                    return "10:40";
                                }

                                return "";
                              },
                              margin: 20),
                          leftTitles: SideTitles(
                              showTitles: true,
                              getTextStyles: (value) =>
                                  Theme.of(context).textTheme.subtitle1!,
                              getTitles: (value) {
                                final i = value.toInt();
                                return i % 20 == 0 ? i.toString() : "";
                              })),
                      borderData: FlBorderData(
                          border: Border(
                              bottom: BorderSide(
                                  color: Theme.of(context).highlightColor),
                              left: BorderSide(
                                  color: Theme.of(context).highlightColor))),
                      minX: 3,
                      minY: 0,
                      maxX: 9,
                      maxY: 50,
                      clipData: FlClipData(
                          left: true, right: true, bottom: true, top: true),
                      lineBarsData: [
                        LineChartBarData(spots: [
                          FlSpot(0, 0),
                          FlSpot(1, 3),
                          FlSpot(2, 3),
                          FlSpot(3, 4),
                          FlSpot(4, 6),
                          FlSpot(5, 7),
                          FlSpot(6, 9),
                          FlSpot(7, 15),
                        ], dotData: FlDotData(show: false))
                      ]))
                ],
              ),
            ),
          )
        ],
      );
}
