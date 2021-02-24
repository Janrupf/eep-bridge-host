import 'package:eep_bridge_host/network/bridge_server.dart';
import 'package:eep_bridge_host/util/application_theme.dart';
import 'package:eep_bridge_host/views/main_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => ApplicationTheme(),
    ),
    Provider(create: (context) => BridgeServer()),
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
