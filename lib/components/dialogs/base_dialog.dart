import 'dart:ui';

import 'package:flutter/material.dart';

/// Wrapper for all dialogs to reduce code duplication
class BaseDialog extends StatelessWidget {
  final Widget child;
  final bool error;

  /// Constructs a new dialog using [child] as its content.
  BaseDialog({required this.child, this.error = false});

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topCenter,
        child: Container(
          padding: EdgeInsets.all(23),
          decoration: BoxDecoration(
              color: error
                  ? Theme.of(context).errorColor.withOpacity(0.5)
                  : Theme.of(context).accentColor.withOpacity(0.7),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          child: child,
        ),
      );
}

/// Creates a new dialog and uses the application wide transition and display
/// settings for dialogs.
Future<T?> showBaseDialog<T extends Object?>({
  required BuildContext context,
  required Widget dialog,
  bool barrierDismissible = false,
  String? barrierLabel,
  Duration transitionDuration = const Duration(milliseconds: 200),
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
}) {
  assert(!barrierDismissible || barrierLabel != null);
  return Navigator.of(context, rootNavigator: useRootNavigator)
      .push<T>(RawDialogRoute<T>(
    pageBuilder: (context, animation1, animation2) => dialog,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    barrierColor: Color(0x0A000000),
    transitionDuration: transitionDuration,
    transitionBuilder: (context, animation1, animation2, child) =>
        BackdropFilter(
      filter: ImageFilter.blur(
          sigmaX: 10 * animation1.value, sigmaY: 10 * animation1.value),
      child: FadeTransition(
        child: child,
        opacity: animation1,
      ),
    ),
    settings: routeSettings,
  ));
}
