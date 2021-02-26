import 'package:eep_bridge_host/network/bridge_server.dart';
import 'package:eep_bridge_host/project/controller.dart';
import 'package:eep_bridge_host/util/application_theme.dart';
import 'package:eep_bridge_host/views/main_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => ApplicationTheme(),
    ),
    Provider<BridgeServer>.value(
      value: BridgeServer(),
    ),
    ProxyProvider<BridgeServer, ProjectController>(
        lazy: false,
        update: (context, server, prev) {
          if (server.hasListener) {
            // Hot reloads sometimes calls this multiple times...
            return prev!;
          }

          return ProjectController(server.stream);
        }),
  ], child: EEPBridgeHost()));
}

/// Main application widget, wraps the theme consumer.
class EEPBridgeHost extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<ApplicationTheme>(
      builder: (context, theme, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: "/",
            routes: {"/": (context) => MainView()},
            title: "EEPBridgeHost",
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: theme.currentTheme(),
          ));
}
