import 'package:eep_bridge_host/components/slim_icon_button.dart';
import 'package:eep_bridge_host/project/controller.dart';
import 'package:eep_bridge_host/project/layout.dart';
import 'package:eep_bridge_host/project/project.dart';
import 'package:eep_bridge_host/views/layout/layout_canvas.dart';
import 'package:eep_bridge_host/views/layout/layout_canvas_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LayoutEditor extends StatefulWidget {
  final LayoutCanvasController _controller;
  final Project project;

  LayoutEditor({Key? key, required this.project})
      : _controller = LayoutCanvasController(project.layout),
        super(key: key);

  @override
  State<LayoutEditor> createState() => _LayoutEditorState();
}

class _LayoutEditorState extends State<LayoutEditor> {
  @override
  void deactivate() {
    Provider.of<ProjectController>(context, listen: false)
        .saveProject(widget.project);
    super.deactivate();
  }

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
                    controller: widget._controller,
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
              NodeType.station,
              Intl.message("Add station"),
              Intl.message("New station"),
            ),
            SizedBox(height: 10),
            _nodeAddButton(
              NodeType.freight_yard,
              Intl.message("Add freight yard"),
              Intl.message("New freight yard"),
            ),
            SizedBox(height: 10),
            _nodeAddButton(
              NodeType.intersection,
              Intl.message("Add intersection"),
              Intl.message("New intersection"),
            ),
            SizedBox(height: 10),
            _nodeAddButton(
              NodeType.train_storage,
              Intl.message("Add train storage"),
              Intl.message("New train storage"),
            ),
            Spacer(),
            SlimIconButton(
              icon: Icons.control_camera,
              label: Intl.message("Center view"),
              onPressed: () => widget._controller.pan = Offset(0, 0),
            )
          ],
        ),
      );

  Widget _nodeAddButton(NodeType type, String label, String newNodeName) =>
      SlimIconButton(
        icon: type.toIcon(),
        label: label,
        onPressed: () => _addGhostedNode(type, newNodeName),
      );

  void _addGhostedNode(NodeType type, String name) {
    final realNode = widget.project.layout.makeNewNode(type, name);

    widget._controller.addNode(realNode);
    widget._controller.setNodeState(realNode, LayoutNodeVisualState.ghosted);
  }
}
