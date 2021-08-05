import 'package:eep_bridge_host/components/slim_icon_button.dart';
import 'package:eep_bridge_host/views/layout/layout_canvas.dart';
import 'package:eep_bridge_host/views/layout/layout_canvas_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LayoutEditor extends StatelessWidget {
  final LayoutCanvasController _controller;

  LayoutEditor({Key? key})
      : _controller = LayoutCanvasController(),
        super(key: key);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
                child: _buildControlColumn(context),
              ),
              Flexible(
                  fit: FlexFit.tight,
                  child: LayoutCanvas(
                    controller: _controller,
                  ))
            ],
          ),
        ),
      );

  Widget _buildControlColumn(BuildContext context) => IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            SlimIconButton(
              icon: Icons.train,
              label: Intl.message("Add passenger station"),
              onPressed: () {
                _controller.addNode(
                  LayoutNode.ghosted(
                    position: Offset(20, 20),
                    icon: Icons.train,
                    label: "Station 3",
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            SlimIconButton(
              icon: Icons.local_shipping,
              label: Intl.message("Add cargo station"),
              onPressed: () {},
            ),
            SizedBox(height: 10),
            SlimIconButton(
              icon: Icons.switch_right,
              label: Intl.message("Add intersection"),
              onPressed: () {},
            ),
            SizedBox(height: 10),
            SlimIconButton(
              icon: Icons.bedtime,
              label: Intl.message("Add train storage"),
              onPressed: () {},
            ),
            Spacer(),
            SlimIconButton(
              icon: Icons.control_camera,
              label: Intl.message("Center"),
              onPressed: () => _controller.pan = Offset(0, 0),
            )
          ],
        ),
      );
}
