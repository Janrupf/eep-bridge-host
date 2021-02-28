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
    _isOk = _checkOk(_nameController.value.text);
  }

  @override
  Widget build(BuildContext context) => Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: EdgeInsets.all(23),
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor.withOpacity(0.7),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
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
              Container(
                  width: 450,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Material(
                          color: Colors.transparent,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: TextField(
                              controller: _nameController,
                              onChanged: (value) =>
                                  setState(() => _isOk = _checkOk(value)),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(fontWeight: FontWeight.w200),
                              decoration: InputDecoration(
                                  isCollapsed: true,
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).hintColor)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .highlightColor)),
                                  contentPadding: EdgeInsets.only(bottom: 5),
                                  hintText: Intl.message("Project name")),
                            ),
                          )),
                      Wrap(
                        spacing: 10,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 30),
                                textStyle:
                                    Theme.of(context).textTheme.headline5,
                                primary: Theme.of(context).errorColor),
                            child: Text(Intl.message("CANCEL")),
                            onPressed: () => _reply(context, null),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 30),
                                textStyle:
                                    Theme.of(context).textTheme.headline5,
                                primary: Theme.of(context).buttonColor),
                            child: Text(Intl.message("CREATE")),
                            onPressed: _isOk
                                ? () => _reply(context, _nameController.text)
                                : null,
                          )
                        ],
                      )
                    ],
                  )),
            ]),
      ));

  bool _checkOk(String? value) {
    return value != null ? value.trim().isNotEmpty : false;
  }

  void _reply(BuildContext context, String? name) {
    Navigator.pop(context);
    widget.event.reply(name);
  }
}
