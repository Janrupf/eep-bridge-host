import 'package:eep_bridge_host/components/control_button.dart';
import 'package:eep_bridge_host/components/dialogs/base_dialog.dart';
import 'package:eep_bridge_host/project/controller.dart';
import 'package:eep_bridge_host/util/ui_messenger.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateProjectDialog extends StatefulWidget {
  final UIMessageEvent<CreateProjectRequest, String?> event;

  CreateProjectDialog(this.event);

  @override
  _CreateProjectDialogState createState() => _CreateProjectDialogState();
}

class _CreateProjectDialogState extends State<CreateProjectDialog> {
  late final TextEditingController _nameController;
  late bool _isOk;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.event.payload.suggestedName);
    _isOk = _isValidProjectName(_nameController.value.text);
  }

  @override
  Widget build(BuildContext context) => BaseDialog(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Intl.message("A client has connected!"),
                  style: Theme.of(context).textTheme.headline2),
              SizedBox(height: 3),
              Text(
                  Intl.message(
                      "Enter a new project name the client should use:"),
                  style: Theme.of(context).textTheme.bodyText2),
              SizedBox(height: 3),
              _inputArea(context)
            ]),
      );

  /// Builds the input area used by this dialog
  Widget _inputArea(BuildContext context) => Container(
      width: 450,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _textField(context),
          Wrap(
            spacing: 10,
            children: [
              ControlButton(
                warn: true,
                child: Text(Intl.message("CANCEL")),
                onPressed: () => _reply(context, null),
              ),
              ControlButton(
                child: Text(Intl.message("CREATE")),
                onPressed:
                    _isOk ? () => _reply(context, _nameController.text) : null,
              )
            ],
          )
        ],
      ));

  /// Builds the text field used by this dialog
  Widget _textField(BuildContext context) => Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(top: 10, bottom: 20),
        child: TextField(
          controller: _nameController,
          onChanged: (value) =>
              setState(() => _isOk = _isValidProjectName(value)),
          style: Theme.of(context)
              .textTheme
              .headline3!
              .copyWith(fontWeight: FontWeight.w200),
          decoration: InputDecoration(
              isCollapsed: true,
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).hintColor)),
              focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).highlightColor)),
              contentPadding: EdgeInsets.only(bottom: 5),
              hintText: Intl.message("Project name")),
        ),
      ));

  /// Determines whether [value] is a valid project name.
  bool _isValidProjectName(String? value) {
    return value != null ? value.trim().isNotEmpty : false;
  }

  /// Replies to the event and pops the dialog
  void _reply(BuildContext context, String? name) {
    Navigator.pop(context);
    widget.event.reply(name);
  }
}
