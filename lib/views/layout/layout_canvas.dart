import 'dart:ui';

import 'package:eep_bridge_host/icons/eep_bridge_icons.dart';
import 'package:eep_bridge_host/project/layout.dart';
import 'package:eep_bridge_host/util/simple_vector.dart';
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

  void _showNodeEditMenu(Offset globalPosition, LayoutNode node) {
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

  void _deleteNode(LayoutNode node) {
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
        (controller.getNodeState(node) == LayoutNodeVisualState.ghosted ||
            controller.getNodeState(node) == LayoutNodeVisualState.dragged) &&
        (node.position.dx - 20 <= currentLeftX ||
            node.position.dx + 20 >= currentRightX ||
            node.position.dy - 20 <= currentTopY ||
            node.position.dy + 20 >= currentBottomY));

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

  void _drawConnection(Canvas canvas, LayoutNodeConnection connection) {
    final vector = SimpleVector.between(
        connection.firstNode.position, connection.secondNode.position);

    _drawLineBetweenNodes(
        canvas, connection.firstNode, connection.secondNode, vector);
    // _drawPointOnLine(canvas, connection.firstNode, vector, vector.length / 2);
    _drawArrowOnLine(
        canvas, connection.firstNode, vector, (vector.length / 2) + 20);
  }

  void _drawLineBetweenNodes(
      Canvas canvas, LayoutNode first, LayoutNode second, SimpleVector vector) {
    final connectionLine = vector.shrink(20);

    final start = connectionLine.apply(first.position);
    final end = connectionLine.applyInverted(second.position);
    canvas.drawLine(start, end, _paintFor(first, second));
  }

  void _drawPointOnLine(
      Canvas canvas, LayoutNode node, SimpleVector vector, double offset) {
    final SimpleVector drawVector;

    if (vector.length <= offset) {
      drawVector = SimpleVector(0, 0);
    } else {
      drawVector = vector.shrink(offset);
    }

    final target = drawVector.apply(node.position);
    canvas.drawCircle(target, 20, _normalPaint);
  }

  void _drawArrowOnLine(
      Canvas canvas, LayoutNode node, SimpleVector vector, double offset) {
    final SimpleVector drawVector;

    if (vector.length <= offset) {
      drawVector = SimpleVector(0, 0);
    } else {
      drawVector = vector.shrink(offset);
    }

    final drawPoint = drawVector.apply(node.position);

    canvas.save();
    canvas.translate(drawPoint.dx, drawPoint.dy);
    canvas.rotate(drawVector.rotate(RotationValue.degree(90)).rotation.radians);

    _drawIcon(canvas, EEPBridgeIcons.signal, Offset(15, -2), Colors.white, fontSize: 12);

    canvas.drawPath(
      Path()..moveTo(0, 0)
      ..lineTo(8, 15)
      ..lineTo(-8, 15)
      ..lineTo(0, 0),
      Paint()..color = Colors.white,
    );

    canvas.restore();
  }

  void _drawNode(Canvas canvas, LayoutNode node) {
    final paint = _paintFor(node);

    _drawIcon(canvas, node.type.toIcon(), node.position, paint.color);
    canvas.drawCircle(node.position, 20, paint);
    _drawText(canvas, node.name, node.position.translate(30, 0), paint.color);
  }

  Paint _paintFor(LayoutNode first, [LayoutNode? second]) {
    final firstState = controller.getNodeState(first);
    final secondState = second == null ? null : controller.getNodeState(second);

    final important = secondState == null
        ? firstState
        : firstState.toPriority() > secondState.toPriority()
            ? firstState
            : secondState;

    switch (important) {
      case LayoutNodeVisualState.normal:
        return _normalPaint;

      case LayoutNodeVisualState.hover:
        return _hoverPaint;

      case LayoutNodeVisualState.dragged:
        return _dragPaint;

      case LayoutNodeVisualState.ghosted:
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
    Color color, {
        Alignment alignment = Alignment.topLeft,
        double fontSize = 25,
      }) {
    final span = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: _normalTextStyle.copyWith(
          fontSize: fontSize, fontFamily: icon.fontFamily, color: color),
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
