import 'package:eep_bridge_host/network/bridge_server.dart';
import 'package:eep_bridge_host/views/view_base.dart';
import 'package:eep_bridge_host/views/waiting_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Overview for each project
class MainView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) => Consumer<BridgeServer>(
      builder: (context, server, child) => StreamBuilder(
            stream: server.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return WaitingView();
              }

              return FullScreenView(child: Text("ACB!"));
            },
          ));
}
