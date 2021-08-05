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
            _nodeAddButton(
              Icons.train,
              Intl.message("Add station"),
              Intl.message("New station"),
            ),
            SizedBox(height: 10),
            _nodeAddButton(
              Icons.local_shipping,
              Intl.message("Add freight yard"),
              Intl.message("New freight yard"),
            ),
            SizedBox(height: 10),
            _nodeAddButton(
              Icons.switch_right,
              Intl.message("Add intersection"),
              Intl.message("New intersection"),
            ),
            SizedBox(height: 10),
            _nodeAddButton(
              Icons.bedtime,
              Intl.message("Add train storage"),
              Intl.message("New train storage"),
            ),
            Spacer(),
            SlimIconButton(
              icon: Icons.control_camera,
              label: Intl.message("Center view"),
              onPressed: () => _controller.pan = Offset(0, 0),
            )
          ],
        ),
      );

  Widget _nodeAddButton(IconData icon, String label, String newNodeName) =>
      SlimIconButton(
        icon: icon,
        label: label,
        onPressed: () => _addGhostedNode(icon, newNodeName),
      );

  void _addGhostedNode(IconData icon, String name) {
    _controller.addNode(LayoutNode.ghosted(
        position: Offset(-4000, -4000), icon: icon, label: name));
  }
}
