import 'package:eep_bridge_host/logging/logger.dart';
import 'package:eep_bridge_host/util/extended_math.dart' as ex_math;
import 'package:eep_bridge_host/util/iteratable_extension.dart';
import 'package:eep_bridge_host/views/layout/layout_canvas.dart';
import 'package:flutter/material.dart';

class LayoutCanvasController {
  final List<LayoutNode> _nodes;
  final NoValueChangeNotifier _redrawNotifier;

  double _scale;
  Offset _pan;

  LayoutCanvasController()
      : _nodes = [],
        _redrawNotifier = NoValueChangeNotifier(),
        _scale = 1,
        _pan = Offset(0, 0);

  void addRedrawListener(VoidCallback listener) {
    _redrawNotifier.addListener(listener);
  }

  List<LayoutNode> get nodes => List.unmodifiable(_nodes);

  NoValueChangeNotifier get redrawNotifier => _redrawNotifier;

  bool hasNode(LayoutNode node) => _nodes.contains(node);

  void removeNode(LayoutNode node) {
    if (!hasNode(node)) {
      Logger.warn("Tried to remove nonexistent node $node");
      return;
    }

    _nodes.remove(node);
    _redraw();
  }

  void addNode(LayoutNode node) {
    _nodes.add(node);
    _redraw();
  }

  void addNodes(Iterable<LayoutNode> nodes) {
    if (nodes.isNotEmpty) {
      _nodes.addAll(nodes);
      _redraw();
    }
  }

  void _redraw() => _redrawNotifier.notifyListeners();

  double get scale => _scale;

  set scale(double value) {
    double clamped = ex_math.clamp(value, 0.4, 3);

    if (clamped != _scale) {
      _scale = clamped;
      _redraw();
    }
  }

  Offset get pan => _pan;

  set pan(Offset offset) {
    if(_pan != offset) {
      _pan = offset;
      _redraw();
    }
  }

  void doStartPan(Offset panPosition) {
    _setNodeStateAt(panPosition, LayoutNodeState.dragged);
  }

  void doPan(Offset panPosition, Offset panDelta) {
    final node =
        nodes.firstWhereOrNull((node) => node.state == LayoutNodeState.dragged);
    if (node != null) {
      final realOffset = _translateOffset(panPosition);

      if (node.position != realOffset) {
        node.position = realOffset;
        _redraw();
      }
    }

    if (node == null && panDelta != Offset.zero) {
      final newDX = _pan.dx + (panDelta.dx / _scale);
      final newDY = _pan.dy + (panDelta.dy / _scale);

      _pan = Offset(
        ex_math.clamp(newDX, -2000, 2000),
        ex_math.clamp(newDY, -2000, 2000),
      );

      _redraw();
    }
  }

  void doEndPan() => _resetNodeStates();

  void doHover(Offset offset) {
    if (_updateGhostedNode(offset)) {
      return;
    }

    _setNodeStateAt(offset, LayoutNodeState.hover);
  }

  void doUp(Offset offset) {
    _dropGhostedNode(offset);
  }

  void doExit() {
    _dropGhostedNode(null);
    _resetNodeStates();
  }

  Offset _translateOffset(Offset offset) {
    return Offset(offset.dx / _scale, offset.dy / _scale)
        .translate(-_pan.dx, -_pan.dy);
  }

  LayoutNode? findNodeAt(Offset offset) {
    Offset realOffset = _translateOffset(offset);

    return nodes.firstWhereOrNull(
        (node) => (node.position - realOffset).distance <= 20);
  }

  void _setNodeStateAt(Offset offset, LayoutNodeState newState) {
    final target = findNodeAt(offset);
    if (target == null) {
      _resetNodeStates();
      return;
    }

    bool needsRedraw = nodes.map((node) {
      if (node == target && target.state != newState) {
        target.state = newState;
        return true;
      } else {
        target.state = LayoutNodeState.normal;
        return false;
      }
    }).any((v) => v);

    if (needsRedraw) {
      _redraw();
    }
  }

  void _resetNodeStates() {
    final needsRedraw = nodes.map((node) {
      if (node.state == LayoutNodeState.normal) {
        return false;
      }

      node.state = LayoutNodeState.normal;
      return true;
    }).any((v) => v);

    if (needsRedraw) {
      _redraw();
    }
  }

  bool _updateGhostedNode(Offset offset) {
    final realOffset = _translateOffset(offset);

    final node =
        nodes.firstWhereOrNull((node) => node.state == LayoutNodeState.ghosted);
    if (node == null) {
      return false;
    }

    if (node.position != realOffset) {
      node.position = realOffset;
      _redraw();
    }

    return true;
  }

  void _dropGhostedNode(Offset? offset) {
    final node =
        nodes.firstWhereOrNull((node) => node.state == LayoutNodeState.ghosted);
    if (node == null) {
      return;
    }

    if (offset == null) {
      nodes.remove(node);
    } else {
      node.position = _translateOffset(offset);
      node.state = LayoutNodeState.normal;
    }

    _redraw();
  }
}
