import 'package:eep_bridge_host/components/auto_unfocus.dart';
import 'package:eep_bridge_host/logging/logger.dart';
import 'package:eep_bridge_host/network/bridge_server.dart';
import 'package:eep_bridge_host/project/controller.dart';
import 'package:eep_bridge_host/util/application_theme.dart';
import 'package:eep_bridge_host/views/viewport_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
class EEPBridgeHost extends StatefulWidget {
  @override
  State<EEPBridgeHost> createState() => _EEPBridgeHostState();
}

class _EEPBridgeHostState extends State<EEPBridgeHost> {
  final windowCloseChannel = MethodChannel("eep_bridge/window_events");

  @override
  void initState() {
    super.initState();
    windowCloseChannel.setMethodCallHandler(_onWindowEvent);
  }

  @override
  Widget build(BuildContext context) => Consumer<ApplicationTheme>(
      builder: (context, theme, child) => AutoUnfocus(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: "/",
              routes: {"/": (context) => ViewportWrapper()},
              title: "EEPBridgeHost",
              theme: ApplicationTheme.light(),
              darkTheme: ApplicationTheme.dark(),
              themeMode: theme.currentTheme(),
            ),
          ));

  Future<void> _onWindowEvent(MethodCall call) async {
    if(call.method == "Window.close") {
      try {
        Logger.debug("Saving projects...");
        await Provider.of<ProjectController>(context, listen: false).saveAll();
        Logger.info("Window closed, saved projects, exiting...");
      } catch(e, stackTrace) {
        Logger.error("Failed to save projects", e, stackTrace);
      }
    }
  }
}
