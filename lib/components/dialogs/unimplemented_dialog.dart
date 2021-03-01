import 'package:eep_bridge_host/components/control_button.dart';
import 'package:eep_bridge_host/components/dialogs/base_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UnimplementedDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BaseDialog(
      error: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              Intl.message(
                  "Sorry, but this functionality is not implemented yet!"),
              style: Theme.of(context).textTheme.bodyText1),
          SizedBox(
            height: 10,
          ),
          ControlButton(
            child: Text(Intl.message("OK")),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ));
}

Future showUnimplementedDialog({
  required BuildContext context,
  Duration transitionDuration = const Duration(milliseconds: 200),
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
}) =>
    showBaseDialog(
        context: context,
        dialog: UnimplementedDialog(),
        barrierDismissible: true,
        barrierLabel: "unimplemented");
