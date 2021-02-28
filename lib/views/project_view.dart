import 'dart:ui';

import 'package:eep_bridge_host/components/sidebar.dart';
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
          child: Container(
        padding: EdgeInsets.all(40),
        child: Column(
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
                  "11:00:23",
                  style: Theme.of(context).textTheme.headline1,
                )
              ],
            ),
            Text(Intl.message("Statistics"),
                style: Theme.of(context).textTheme.headline1)
          ],
        ),
      ));
}
