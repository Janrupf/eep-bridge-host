import 'dart:math' as math;

import 'package:eep_bridge_host/project/layout.dart';
import 'package:eep_bridge_host/views/layout/layout_canvas_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LayoutCanvas extends StatefulWidget {
  final LayoutCanvasController controller;

  const LayoutCanvas({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LayoutCanvasState();
}

class _LayoutCanvasState extends State<LayoutCanvas> {
  @override
  Widget build(BuildContext context) {
    final painter = _LayoutCanvasPainter(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        controller: widget.controller);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: MouseRegion(
        onEnter: (e) {
          widget.controller.doHover(e.localPosition);
        },
        onExit: (e) {
          widget.controller.doExit();
        },
        onHover: (e) {
          widget.controller.doHover(e.localPosition);
        },
        child: GestureDetector(
          onPanStart: (e) {
            widget.controller.doStartPan(e.localPosition);
          },
          onPanUpdate: (e) {
            widget.controller.doPan(e.localPosition, e.delta);
          },
          onPanEnd: (e) {
            widget.controller.doEndPan();
          },
          onTapUp: (e) {
            widget.controller.doUp(e.localPosition);
          },
          onSecondaryTapUp: (e) {
            final node = widget.controller.findNodeAt(e.localPosition);
            if (node == null) {
              return;
            }

            _showNodeEditMenu(e.globalPosition, node);
          },
          child: Listener(
            onPointerSignal: (e) {
              if (e is PointerScrollEvent) {
                widget.controller.scale -= (e.scrollDelta.dy / 106.0);
              }
            },
            child: RepaintBoundary(
              child: CustomPaint(
                willChange: true,
                isComplex: true,
                painter: painter,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showNodeEditMenu(Offset globalPosition, VisualLayoutNode node) {
    showMenu(
      color: Theme.of(context).colorScheme.primary,
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      position: RelativeRect.fromLTRB(
        globalPosition.dx,
        globalPosition.dy,
        1000000,
        0,
      ),
      items: [
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.build),
              SizedBox(
                width: 3,
              ),
              Text("Edit"),
            ],
          ),
          height: 30,
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.delete),
              SizedBox(
                width: 3,
              ),
              Text("Delete"),
            ],
          ),
          height: 30,
          onTap: () => _deleteNode(node),
        ),
      ],
    );
  }

  void _deleteNode(VisualLayoutNode node) {
    widget.controller.removeNode(node);
  }
}

class _LayoutCanvasPainter extends CustomPainter {
  final Color backgroundColor;
  final LayoutCanvasController controller;

  final TextStyle _normalTextStyle;
  final Paint _normalPaint;
  final Paint _hoverPaint;
  final Paint _dragPaint;
  final Paint _ghostedPaint;

  static const double GRID_SPACING = 45.0;

  _LayoutCanvasPainter({
    required this.backgroundColor,
    required this.controller,
  })  : _normalTextStyle = TextStyle(color: Colors.white, fontSize: 15),
        _normalPaint = _makePaint(Colors.white),
        _hoverPaint = _makePaint(Colors.orange),
        _dragPaint = _makePaint(Colors.yellow),
        _ghostedPaint = _makePaint(Colors.grey.withAlpha(127)),
        super(repaint: controller.redrawNotifier);

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
    canvas.scale(controller.scale);
    canvas.translate(controller.pan.dx, controller.pan.dy);
    _drawGrid(canvas, size);

    controller.connections
        .forEach((connection) => _drawConnection(canvas, connection));
    controller.nodes.forEach((node) => _drawNode(canvas, node));

    canvas.restore();

    final currentLeftX = -controller.pan.dx;
    final currentRightX =
        (-controller.pan.dx + (size.width / controller.scale));

    final currentTopY = -controller.pan.dy;
    final currentBottomY =
        (-controller.pan.dy + (size.height / controller.scale));

    bool borderWarning = controller.nodes.any((node) =>
        (node.state == VisualLayoutNodeState.ghosted ||
            node.state == VisualLayoutNodeState.dragged) &&
        (node.underlyingNode.position.dx - 20 <= currentLeftX ||
            node.underlyingNode.position.dx + 20 >= currentRightX ||
            node.underlyingNode.position.dy - 20 <= currentTopY ||
            node.underlyingNode.position.dy + 20 >= currentBottomY));

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

    final realWidth = size.width / controller.scale;
    final realHeight = size.height / controller.scale;

    final horizontalOffsettedCellCount = controller.pan.dx ~/ GRID_SPACING;
    final verticalOffsettedCellCount = controller.pan.dy ~/ GRID_SPACING;

    int horizontalCellCount = realWidth ~/ GRID_SPACING;
    double startX = (realWidth / 2) -
        (GRID_SPACING / 2) -
        (((horizontalCellCount + 1) / 2) * GRID_SPACING) -
        (horizontalOffsettedCellCount * GRID_SPACING) -
        GRID_SPACING;

    int verticalCellCount = realHeight ~/ GRID_SPACING;
    double startY = (realHeight / 2) -
        (GRID_SPACING / 2) -
        (((verticalCellCount + 1) / 2) * GRID_SPACING) -
        (verticalOffsettedCellCount * GRID_SPACING) -
        GRID_SPACING;

    for (double x = startX;
        x < startX + realWidth + GRID_SPACING * 2;
        x += GRID_SPACING) {
      canvas.drawLine(Offset(x, startY),
          Offset(x, startY + realHeight + GRID_SPACING * 3), gridPaint);
    }

    for (double y = startY;
        y < startY + realHeight + GRID_SPACING * 2;
        y += GRID_SPACING) {
      canvas.drawLine(Offset(startX, y),
          Offset(startX + realWidth + GRID_SPACING * 3, y), gridPaint);
    }
  }

  void _drawConnection(Canvas canvas, VisualLayoutConnection connection) {
    _drawLineBetweenNodes(canvas, connection.firstNode, connection.secondNode);
  }

  void _drawLineBetweenNodes(
      Canvas canvas, VisualLayoutNode first, VisualLayoutNode second) {
    var adjustedX =
        second.underlyingNode.position.dx - first.underlyingNode.position.dx;
    var adjustedY =
        second.underlyingNode.position.dy - first.underlyingNode.position.dy;
    final distance = math.sqrt(adjustedX * adjustedX + adjustedY * adjustedY);

    if (distance > 0) {
      adjustedX /= distance;
      adjustedY /= distance;
    }

    adjustedX *= distance - 20;
    adjustedY *= distance - 20;

    final firstAdjusted =
        first.underlyingNode.position.translate(adjustedX, adjustedY);
    final secondAdjusted =
        second.underlyingNode.position.translate(-adjustedX, -adjustedY);
    canvas.drawLine(secondAdjusted, firstAdjusted, _paintFor(first, second));
  }

  void _drawNode(Canvas canvas, VisualLayoutNode node) {
    final paint = _paintFor(node);

    _drawIcon(canvas, node.underlyingNode.type.toIcon(),
        node.underlyingNode.position, paint.color);
    canvas.drawCircle(node.underlyingNode.position, 20, paint);
    _drawText(canvas, node.underlyingNode.name,
        node.underlyingNode.position.translate(30, 0), paint.color);
  }

  Paint _paintFor(VisualLayoutNode a, [VisualLayoutNode? b]) {
    final important = b == null
        ? a
        : a.state.toPriority() > b.state.toPriority()
            ? a
            : b;

    switch (important.state) {
      case VisualLayoutNodeState.normal:
        return _normalPaint;

      case VisualLayoutNodeState.hover:
        return _hoverPaint;

      case VisualLayoutNodeState.dragged:
        return _dragPaint;

      case VisualLayoutNodeState.ghosted:
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

enum VisualLayoutNodeState { normal, hover, dragged, ghosted }

extension _LayoutNodeStateExtension on VisualLayoutNodeState {
  int toPriority() {
    switch (this) {
      case VisualLayoutNodeState.normal:
        return 1;

      case VisualLayoutNodeState.hover:
        return 2;

      case VisualLayoutNodeState.dragged:
        return 3;

      case VisualLayoutNodeState.ghosted:
        return -1;
    }
  }
}

class VisualLayoutNode {
  VisualLayoutNodeState state;

  LayoutNode underlyingNode;

  VisualLayoutNode({
    required this.underlyingNode,
  }) : state = VisualLayoutNodeState.normal;

  VisualLayoutNode.ghosted({
    required this.underlyingNode,
  }) : state = VisualLayoutNodeState.ghosted;
}

class VisualLayoutConnection {
  VisualLayoutNode firstNode;
  VisualLayoutNode secondNode;

  LayoutNodeConnection underlyingConnection;

  VisualLayoutConnection(
      {required this.firstNode,
      required this.secondNode,
      required this.underlyingConnection});

  bool connectsTo(VisualLayoutNode first, [VisualLayoutNode? second]) {
    if (second == null) {
      return first == firstNode || second == secondNode;
    }

    return (first == firstNode && second == secondNode) ||
        (second == firstNode && first == secondNode);
  }
}
