import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WaitingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/dioramas/01.png"),
                  fit: BoxFit.cover)),
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(bottom: 20),
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
      );
}
