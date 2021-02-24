import 'package:eep_bridge_host/components/animated_multi_switcher.dart';
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
                    Image.asset("assets/dioramas/01.png", key: ValueKey(1),),
                    Image.asset("assets/dioramas/02.png", key: ValueKey(2))
                  ],
                ),
                fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    Intl.message("Waiting for clients..."),
                    style: TextStyle(fontSize: 40),
                  ),
                  Text(
                    Intl.message("Load up a layout which uses EEPBridge!"),
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
          ],
        ),
      );
}
