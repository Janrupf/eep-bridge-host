import 'package:flutter/material.dart';

/// Helper widget to automatically unfocus focusable widgets when the user
/// taps somewhere else.
class AutoUnfocus extends StatelessWidget {
  final Widget child;

  const AutoUnfocus({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          final currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.focusedChild!.unfocus();
          }
        },
        child: child,
      );
}
