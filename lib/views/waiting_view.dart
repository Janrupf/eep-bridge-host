import 'dart:ui';

import 'package:eep_bridge_host/components/animated_multi_switcher.dart';
import 'package:eep_bridge_host/components/sidebar.dart';
import 'package:eep_bridge_host/logging/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WaitingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            FittedBox(
                child: AnimatedMultiSwitcher(
                  transitionDuration: Duration(seconds: 1),
                  displayDuration: Duration(seconds: 30),
                  children: [
                    Image.asset("assets/dioramas/Diorama_01.png",
                        key: ValueKey(1)),
                    Image.asset("assets/dioramas/Diorama_02.png",
                        key: ValueKey(2)),
                    Image.asset(
                      "assets/dioramas/Diorama_03.png",
                      key: ValueKey(3),
                    ),
                    Image.asset(
                      "assets/dioramas/Diorama_04.png",
                      key: ValueKey(4),
                    ),
                  ],
                ),
                fit: BoxFit.cover),
            Row(
              children: [
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Sidebar(opacity: 0.7, children: [
                      SidebarSection(text: Intl.message("MAIN MENU")),
                      SidebarEntry(
                        icon: Icons.help_outline,
                        text: "Help",
                        onTap: () {
                          Logger.warn("Unimplemented: open help", null,
                              StackTrace.current);
                        },
                      ),
                      SidebarEntry(
                        icon: Icons.open_in_browser,
                        text: "Open",
                        onTap: () {
                          Logger.warn("Unimplemented: open existing", null,
                              StackTrace.current);
                        },
                      ),
                      Spacer(),
                      SidebarSection(text: Intl.message("RECENT")),
                      Spacer(),
                    ]),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          Intl.message("Waiting for EEP connection..."),
                          style: TextStyle(fontSize: 40, shadows: [
                            Shadow(color: Colors.black, blurRadius: 8)
                          ]),
                        ),
                        Text(
                          Intl.message(
                              "Load up a layout which uses EEPBridge!"),
                          style: TextStyle(fontSize: 20, shadows: [
                            Shadow(color: Colors.black, blurRadius: 8)
                          ]),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      );
}
