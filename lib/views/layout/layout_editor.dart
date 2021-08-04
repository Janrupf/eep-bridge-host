import 'package:eep_bridge_host/views/layout/layout_canvas.dart';
import 'package:flutter/material.dart';

class LayoutEditor extends StatelessWidget {
  final NoValueChangeNotifier _changeNotifier;
  final List<LayoutNode> _nodes;

  LayoutEditor({Key? key})
      : _changeNotifier = NoValueChangeNotifier(),
        _nodes = [],
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
                padding: EdgeInsets.all(10),
                child: _buildControlColumn(context),
              ),
              Flexible(
                  fit: FlexFit.tight,
                  child: LayoutCanvas(
                    changeNotifier: _changeNotifier,
                    nodes: _nodes,
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
            ElevatedButton(
              child: Text("Add station"),
              onPressed: () {
                _nodes.add(
                  LayoutNode.ghosted(
                    position: Offset(20, 20),
                    icon: Icons.train,
                    label: "Station 3",
                  ),
                );

                _changeNotifier.notifyListeners();
              },
            ),
            ElevatedButton(
              child: Text("Add intersection"),
              onPressed: () {},
            ),
          ],
        ),
      );
}
