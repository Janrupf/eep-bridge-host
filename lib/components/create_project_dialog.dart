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
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.event.payload.suggestedName);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(Intl.message("Create new project")),
        content: Form(
          key: _formKey,
          child: Wrap(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                    icon: Icon(Icons.label),
                    hintText: Intl.message("The name of your project"),
                    labelText: Intl.message("Project name")),
                validator: (value) => value != null && value.isNotEmpty
                    ? null
                    : Intl.message("Please enter a name"),
              )
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text(Intl.message("Cancel")),
            onPressed: () => _reply(context, null),
          ),
          TextButton(
            child: Text(Intl.message("Ok")),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _reply(context, _nameController.text);
              }
            },
          )
        ],
      );

  void _reply(BuildContext context, String? name) {
    Navigator.pop(context);
    widget.event.reply(name);
  }
}
