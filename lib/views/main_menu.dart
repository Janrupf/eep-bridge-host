import 'dart:ui';

import 'package:eep_bridge_host/components/animated_multi_switcher.dart';
import 'package:eep_bridge_host/components/dialogs/unimplemented_dialog.dart';
import 'package:eep_bridge_host/components/sidebar.dart';
import 'package:eep_bridge_host/logging/logger.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);

    _offsetAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.decelerate))
          ..addListener(() {
            setState(() {});
          });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                SlideTransition(
                  position: _offsetAnimation,
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: RepaintBoundary(
                        child: Sidebar(opacity: 0.7, children: [
                          SidebarSection(text: Intl.message("MAIN MENU")),
                          SidebarEntry(
                            icon: Icons.open_in_browser,
                            text: "Open",
                            onTap: () {
                              Logger.warn("Unimplemented: open existing", null,
                                  StackTrace.current);
                              showUnimplementedDialog(context: context);
                            },
                          ),
                          SidebarEntry(
                            icon: Icons.help_outline,
                            text: "Help",
                            onTap: () {
                              Logger.warn("Unimplemented: open help", null,
                                  StackTrace.current);
                              showUnimplementedDialog(context: context);
                            },
                          ),
                          SidebarEntry(
                            icon: Icons.text_snippet_outlined,
                            text: "About",
                            onTap: () {
                              Logger.warn("Unimplemented: open about", null,
                                  StackTrace.current);
                              showUnimplementedDialog(context: context);
                            },
                          ),
                          Spacer(),
                          SidebarSection(text: Intl.message("RECENT")),
                          Spacer(),
                        ]),
                      ),
                    ),
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
                          style: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              shadows: [
                                Shadow(color: Colors.black, blurRadius: 8)
                              ]),
                        ),
                        Text(
                          Intl.message(
                              "Load up a layout which uses EEPBridge!"),
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              shadows: [
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
