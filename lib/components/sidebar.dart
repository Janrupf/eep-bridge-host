import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Common sidebar
class Sidebar extends StatelessWidget {
  final List<Widget> children;
  final double opacity;

  Sidebar({Key? key, required this.children, this.opacity = 1.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        width: 305,
        color: Theme.of(context).accentColor.withOpacity(opacity),
        child: Container(
          padding: EdgeInsets.only(top: 80, left: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      );
}

class SidebarSection extends StatelessWidget {
  final String text;

  SidebarSection({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Text(text, style: Theme.of(context).textTheme.headline6));
}

class SidebarEntry extends StatefulWidget {
  final IconData icon;
  final String text;
  final GestureTapCallback onTap;

  const SidebarEntry(
      {Key? key, required this.icon, required this.text, required this.onTap})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SidebarEntryState();
}

class _SidebarEntryState extends State<SidebarEntry> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) => setState(() => _hovered = true),
      onExit: (event) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: ListTile(
          leading: Icon(
            widget.icon,
            size: 30.0,
            color: _color(context),
          ),
          title: Text(
            widget.text,
            style: Theme.of(context).textTheme.headline3?.copyWith(
                color: _color(context),
                fontWeight: _hovered ? FontWeight.w400 : FontWeight.w300),
          ),
        ),
      ),
    );
  }

  Color _color(BuildContext context) =>
      _hovered ? Theme.of(context).highlightColor : Theme.of(context).hintColor;
}
