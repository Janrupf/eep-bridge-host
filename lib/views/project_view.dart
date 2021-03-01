import 'dart:ui';

import 'package:eep_bridge_host/components/sidebar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProjectView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage("assets/dioramas/Diorama_02.png"),
                    fit: BoxFit.cover),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
                child: Container(
                  decoration:
                      BoxDecoration(color: Color(0x171717).withOpacity(0.7)),
                ),
              ),
            ),
            Row(
              children: [_sidebar(context), _content(context)],
            )
          ],
        ),
      );

  Widget _sidebar(BuildContext context) => Sidebar(children: [
        SidebarSection(text: Intl.message("MENU")),
        SidebarEntry(
            active: true,
            icon: Icons.poll_outlined,
            text: Intl.message("Dashboard"),
            onTap: () {}),
        SidebarEntry(
            icon: Icons.engineering,
            text: Intl.message("Control"),
            onTap: () {}),
        SidebarEntry(
            icon: Icons.departure_board_outlined,
            text: Intl.message("Schedule"),
            onTap: () {}),
        Spacer(),
        Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Theme.of(context).errorColor.withOpacity(0.3),
                blurRadius: 50,
                spreadRadius: 5)
          ]),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  textStyle: Theme.of(context).textTheme.headline5,
                  primary: Theme.of(context).errorColor),
              child: Text(Intl.message("EMERGENCY STOP")),
              onPressed: () {}),
        ),
        SizedBox(
          height: 40,
        )
      ]);

  Widget _content(BuildContext context) => Expanded(
          child: Scrollbar(
            child: Container(
              height: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 80),
        child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.query_builder,
                      size: 40,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "--:--:--",
                      style: Theme.of(context).textTheme.headline1,
                    )
                  ],
                ),
                Text(Intl.message("Statistics"),
                    style: Theme.of(context).textTheme.headline1),
                SizedBox(height: 10),
                _statistics(context)
              ],
            ),
        ),
      ),
          ));

  Widget _statistics(BuildContext context) => Row(
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
                        left: true,
                        right: true,
                        bottom: true,
                        top: true
                      ),
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
