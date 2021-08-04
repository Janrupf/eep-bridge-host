import 'package:eep_bridge_host/project/project.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DebugView extends StatelessWidget {
  final Project project;
  final TextEditingController _objectIdController;
  final TextEditingController _objectStateController;

  DebugView({Key? key, required this.project})
      : _objectIdController = TextEditingController(),
        _objectStateController = TextEditingController(),
        super(key: key);

  @override
  Widget build(BuildContext context) => Form(
          child: Wrap(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: TextFormField(
                  controller: _objectIdController,
                  decoration:
                      InputDecoration(isDense: true, hintText: "Object ID"),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                flex: 2,
              ),
              Flexible(
                child: TextFormField(
                  controller: _objectStateController,
                  decoration: InputDecoration(isDense: true, hintText: "State"),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                flex: 2,
              ),
              Flexible(
                flex: 0,
                child: ElevatedButton(
                  child: Text("Set Signal"),
                  onPressed: _setSignal,
                ),
              ),
              Flexible(
                flex: 0,
                child: ElevatedButton(
                  child: Text("Set Switch"),
                  onPressed: _setSwitch,
                ),
              )
            ],
          )
        ],
      ));

  int _parseNum(TextEditingController controller) => int.parse(controller.text);

  void _setSignal() {
    int signalId = _parseNum(_objectIdController);
    int state = _parseNum(_objectStateController);

    project.setSignal(signalId, state);
  }

  void _setSwitch() {
    int sw = _parseNum(_objectIdController);
    int state = _parseNum(_objectStateController);

    project.setSwitch(sw, state);
  }
}
