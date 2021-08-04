import 'dart:math' as math;

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

    return MouseRegion(
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
        child: RepaintBoundary(
          child: CustomPaint(
            willChange: true,
            painter: painter,
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
    print("X");
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
  }
}

class _LayoutCanvasPainter extends CustomPainter {
  final Color backgroundColor;
  final TextStyle _normalTextStyle;
  final Paint _normalPaint;
  final Paint _hoverPaint;
  final Paint _dragPaint;
  final Paint _ghostedPaint;

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
    _drawLineBetweenNodes(canvas, nodes[0].position, nodes[1].position);

    nodes.forEach((node) => _drawNode(canvas, node));
  }

  void _drawLineBetweenNodes(Canvas canvas, Offset first, Offset second) {
    var adjustedX = second.dx - first.dx;
    var adjustedY = second.dy - first.dy;
    final distance = math.sqrt(adjustedX * adjustedX + adjustedY * adjustedY);

    if (distance > 0) {
      adjustedX /= distance;
      adjustedY /= distance;
    }

    adjustedX *= distance - 20;
    adjustedY *= distance - 20;

    final firstAdjusted = first.translate(adjustedX, adjustedY);
    final secondAdjusted = second.translate(-adjustedX, -adjustedY);
    canvas.drawLine(secondAdjusted, firstAdjusted, _normalPaint);
  }

  void _drawNode(Canvas canvas, LayoutNode node) {
    final circlePaint;

    switch (node.state) {
      case _LayoutNodeState.normal:
        circlePaint = _normalPaint;
        break;

      case _LayoutNodeState.hover:
        circlePaint = _hoverPaint;
        break;

      case _LayoutNodeState.dragged:
        circlePaint = _dragPaint;
        break;

      case _LayoutNodeState.ghosted:
        circlePaint = _ghostedPaint;
        break;
    }

    _drawIcon(canvas, node.icon, node.position, circlePaint.color);
    canvas.drawCircle(node.position, 20, circlePaint);
    _drawText(
        canvas, node.label, node.position.translate(30, 0), circlePaint.color);
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
