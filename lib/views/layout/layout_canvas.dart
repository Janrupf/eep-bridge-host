import 'dart:math' as math;

import 'package:eep_bridge_host/logging/logger.dart';
import 'package:eep_bridge_host/util/iteratable_extension.dart';
import 'package:flutter/material.dart';

class LayoutCanvas extends StatefulWidget {
  final List<LayoutNode> nodes;
  final NoValueChangeNotifier changeNotifier;

  const LayoutCanvas({
    Key? key,
    required this.nodes,
    required this.changeNotifier,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LayoutCanvasState();
}

class _LayoutCanvasState extends State<LayoutCanvas> {
  @override
  void initState() {
    super.initState();

    widget.nodes.addAll([
      LayoutNode(
          icon: Icons.train, label: "Station 0", position: Offset(100, 100)),
      LayoutNode(
          icon: Icons.train, label: "Station 1", position: Offset(90, 180)),
      LayoutNode(
          icon: Icons.train, label: "Station 2", position: Offset(300, 90))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final painter = _LayoutCanvasPainter(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      repaint: widget.changeNotifier,
      nodes: widget.nodes,
    );

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: MouseRegion(
        onEnter: (e) {
          if (_updateGhostedNode(e.localPosition)) {
            return;
          }

          _setNodeStateAt(e.localPosition, _LayoutNodeState.hover);
        },
        onExit: (e) {
          _dropGhostedNode(null);
          _resetNodeStates();
        },
        onHover: (e) {
          if (_updateGhostedNode(e.localPosition)) {
            return;
          }

          _setNodeStateAt(e.localPosition, _LayoutNodeState.hover);
        },
        child: GestureDetector(
          onPanStart: (e) {
            _setNodeStateAt(e.localPosition, _LayoutNodeState.dragged);
          },
          onPanUpdate: (e) {
            final node = widget.nodes.firstWhereOrNull(
                (node) => node.state == _LayoutNodeState.dragged);
            if (node != null && node.position != e.localPosition) {
              node.position = e.localPosition;
              _scheduleRedraw();
            }
          },
          onPanEnd: (e) {
            _resetNodeStates();
          },
          onTapUp: (e) {
            _dropGhostedNode(e.localPosition);
          },
          onSecondaryTapUp: (e) {
            final node = _findNodeAt(e.localPosition);
            if (node == null) {
              return;
            }

            _showNodeEditMenu(e.globalPosition, node);
          },
          child: RepaintBoundary(
            child: CustomPaint(
              willChange: true,
              painter: painter,
            ),
          ),
        ),
      ),
    );
  }

  LayoutNode? _findNodeAt(Offset offset) {
    return widget.nodes
        .firstWhereOrNull((node) => (node.position - offset).distance <= 20);
  }

  void _setNodeStateAt(Offset offset, _LayoutNodeState newState) {
    final target = _findNodeAt(offset);
    if (target == null) {
      _resetNodeStates();
      return;
    }

    bool needsRedraw = widget.nodes.map((node) {
      if (node == target && target.state != newState) {
        target.state = newState;
        return true;
      } else {
        target.state = _LayoutNodeState.normal;
        return false;
      }
    }).any((v) => v);

    if (needsRedraw) {
      _scheduleRedraw();
    }
  }

  void _resetNodeStates() {
    final needsRedraw = widget.nodes.map((node) {
      if (node.state == _LayoutNodeState.normal) {
        return false;
      }

      node.state = _LayoutNodeState.normal;
      return true;
    }).any((v) => v);

    if (needsRedraw) {
      _scheduleRedraw();
    }
  }

  void _scheduleRedraw() {
    widget.changeNotifier.notifyListeners();
  }

  bool _updateGhostedNode(Offset offset) {
    final node = widget.nodes
        .firstWhereOrNull((node) => node.state == _LayoutNodeState.ghosted);
    if (node == null) {
      return false;
    }

    if (node.position != offset) {
      node.position = offset;
      _scheduleRedraw();
    }

    return true;
  }

  void _dropGhostedNode(Offset? offset) {
    final node = widget.nodes
        .firstWhereOrNull((node) => node.state == _LayoutNodeState.ghosted);
    if (node == null) {
      return;
    }

    if (offset == null) {
      widget.nodes.remove(node);
    } else {
      node.position = offset;
      node.state = _LayoutNodeState.normal;
    }

    _scheduleRedraw();
  }

  void _showNodeEditMenu(Offset globalPosition, LayoutNode node) {
    showMenu(
      color: Theme.of(context).colorScheme.primary,
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      position: RelativeRect.fromLTRB(
        globalPosition.dx,
        globalPosition.dy,
        1000000,
        0,
      ),
      items: [
        PopupMenuItem(child: Row(
          children: [
            Icon(Icons.build),
            SizedBox(width: 3,),
            Text("Edit"),
          ],
        ), height: 30,),
        PopupMenuItem(child: Row(
          children: [
            Icon(Icons.delete),
            SizedBox(width: 3,),
            Text("Delete"),
          ],
        ), height: 30, onTap: () => _deleteNode(node),),
      ],
    );
  }

  void _deleteNode(LayoutNode node) {
    if(!widget.nodes.contains(node)) {
      Logger.warn("Tried to delete a nonexistent layout node");
      return;
    }

    widget.nodes.remove(node);
    _scheduleRedraw();
  }
}

class _LayoutCanvasPainter extends CustomPainter {
  final Color backgroundColor;
  final TextStyle _normalTextStyle;
  final Paint _normalPaint;
  final Paint _hoverPaint;
  final Paint _dragPaint;
  final Paint _ghostedPaint;

  static const double GRID_SPACING = 45.0;

  final List<LayoutNode> nodes;

  _LayoutCanvasPainter({
    Listenable? repaint,
    required this.backgroundColor,
    required this.nodes,
  })  : _normalTextStyle = TextStyle(color: Colors.white, fontSize: 15),
        _normalPaint = _makePaint(Colors.white),
        _hoverPaint = _makePaint(Colors.orange),
        _dragPaint = _makePaint(Colors.yellow),
        _ghostedPaint = _makePaint(Colors.grey.withAlpha(127)),
        super(repaint: repaint);

  static Paint _makePaint(Color color) => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.4
    ..color = color;

  @override
  void paint(Canvas canvas, Size size) {
    final areaRRect = RRect.fromLTRBAndCorners(
      0,
      0,
      size.width,
      size.height,
      topLeft: Radius.circular(10.0),
      topRight: Radius.circular(10.0),
      bottomLeft: Radius.circular(10.0),
      bottomRight: Radius.circular(10.0),
    );

    canvas.save();

    canvas.clipRRect(areaRRect);

    _drawGrid(canvas, size);
    // _drawLineBetweenNodes(canvas, nodes[0], nodes[1]);
    nodes.forEach((node) => _drawNode(canvas, node));

    canvas.restore();

    bool borderWarning = nodes.any((node) =>
        node.position.dx <= 20 ||
        node.position.dy <= 20 ||
        size.width - node.position.dx <= 20 ||
        size.height - node.position.dy <= 20);

    final borderPaint = Paint()
      ..color = borderWarning ? Colors.red : Colors.white.withAlpha(100)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(
      areaRRect.inflate(2.0),
      borderPaint,
    );
  }

  void _drawGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()..color = Colors.grey.shade700;

    int horizontalCellCount = size.width ~/ GRID_SPACING;
    double startX = (size.width / 2) -
        (GRID_SPACING / 2) -
        (((horizontalCellCount - 1) / 2) * GRID_SPACING);

    for (double x = startX; x < size.width; x += GRID_SPACING) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    int verticalCellCount = size.height ~/ GRID_SPACING;
    double startY = (size.height / 2) -
        (GRID_SPACING / 2) -
        (((verticalCellCount - 1) / 2) * GRID_SPACING);

    for (double y = startY; y < size.height; y += GRID_SPACING) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  void _drawLineBetweenNodes(
      Canvas canvas, LayoutNode first, LayoutNode second) {
    var adjustedX = second.position.dx - first.position.dx;
    var adjustedY = second.position.dy - first.position.dy;
    final distance = math.sqrt(adjustedX * adjustedX + adjustedY * adjustedY);

    if (distance > 0) {
      adjustedX /= distance;
      adjustedY /= distance;
    }

    adjustedX *= distance - 20;
    adjustedY *= distance - 20;

    final firstAdjusted = first.position.translate(adjustedX, adjustedY);
    final secondAdjusted = second.position.translate(-adjustedX, -adjustedY);
    canvas.drawLine(secondAdjusted, firstAdjusted, _paintFor(first, second));
  }

  void _drawNode(Canvas canvas, LayoutNode node) {
    final paint = _paintFor(node);

    _drawIcon(canvas, node.icon, node.position, paint.color);
    canvas.drawCircle(node.position, 20, paint);
    _drawText(canvas, node.label, node.position.translate(30, 0), paint.color);
  }

  Paint _paintFor(LayoutNode a, [LayoutNode? b]) {
    final important = b == null
        ? a
        : a.state.toPriority() > b.state.toPriority()
            ? a
            : b;

    switch (important.state) {
      case _LayoutNodeState.normal:
        return _normalPaint;

      case _LayoutNodeState.hover:
        return _hoverPaint;

      case _LayoutNodeState.dragged:
        return _dragPaint;

      case _LayoutNodeState.ghosted:
        return _ghostedPaint;
    }
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset offset,
    Color color, [
    Alignment alignment = Alignment.topLeft,
  ]) {
    final span =
        TextSpan(text: text, style: _normalTextStyle.copyWith(color: color));
    final painter = TextPainter(text: span, textDirection: TextDirection.ltr);

    painter.layout();
    final rect =
        Rect.fromLTWH(offset.dx, offset.dy, painter.width, painter.height);
    final alignedOffset =
        alignment.withinRect(rect).translate(0, -(painter.height / 2));
    final backgroundRect = Rect.fromLTWH(
      alignedOffset.dx,
      alignedOffset.dy,
      painter.width,
      painter.height,
    ).inflate(3);

    canvas.drawRect(backgroundRect, Paint()..color = backgroundColor);
    painter.paint(canvas, alignedOffset);
  }

  void _drawIcon(
    Canvas canvas,
    IconData icon,
    Offset offset,
    Color color, [
    Alignment alignment = Alignment.topLeft,
  ]) {
    final span = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: _normalTextStyle.copyWith(
          fontSize: 25, fontFamily: icon.fontFamily, color: color),
    );
    final painter = TextPainter(text: span, textDirection: TextDirection.ltr);

    painter.layout();
    final rect =
        Rect.fromLTWH(offset.dx, offset.dy, painter.width, painter.height);
    final targetPaintOffset = alignment.withinRect(rect);

    painter.paint(
        canvas,
        targetPaintOffset.translate(
            -(painter.width / 2), -(painter.height / 2)));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NoValueChangeNotifier extends ChangeNotifier {
  void notifyListeners() {
    super.notifyListeners();
  }
}

enum _LayoutNodeState { normal, hover, dragged, ghosted }

extension _LayoutNodeStateExtension on _LayoutNodeState {
  int toPriority() {
    switch (this) {
      case _LayoutNodeState.normal:
        return 1;

      case _LayoutNodeState.hover:
        return 2;

      case _LayoutNodeState.dragged:
        return 3;

      case _LayoutNodeState.ghosted:
        return -1;
    }
  }
}

class LayoutNode {
  Offset position;
  IconData icon;
  String label;
  _LayoutNodeState state;

  LayoutNode({
    required this.position,
    required this.icon,
    required this.label,
  }) : state = _LayoutNodeState.normal;

  LayoutNode.ghosted({
    required this.position,
    required this.icon,
    required this.label,
  }) : state = _LayoutNodeState.ghosted;
}
