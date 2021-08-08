import 'package:eep_bridge_host/logging/logger.dart';
import 'package:eep_bridge_host/project/layout.dart';
import 'package:eep_bridge_host/util/extended_math.dart' as ex_math;
import 'package:eep_bridge_host/util/iteratable_extension.dart';
import 'package:eep_bridge_host/views/layout/layout_canvas.dart';
import 'package:flutter/material.dart';

enum LayoutNodeVisualState { normal, hover, dragged, ghosted }

enum VisualLayoutNodeState { normal, hover, dragged, ghosted }

extension LayoutNodeVisualStateExtension on LayoutNodeVisualState {
  int toPriority() {
    switch (this) {
      case LayoutNodeVisualState.normal:
        return 1;

      case LayoutNodeVisualState.hover:
        return 2;

      case LayoutNodeVisualState.dragged:
        return 3;

      case LayoutNodeVisualState.ghosted:
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

class LayoutCanvasController {
  final Layout layout;
  final NoValueChangeNotifier _redrawNotifier;
  final Expando<LayoutNodeVisualState> _nodeStates;

  double _scale;
  Offset _pan;

  LayoutCanvasController(this.layout)
      : _redrawNotifier = NoValueChangeNotifier(),
        _nodeStates = Expando(),
        _scale = 1,
        _pan = Offset(0, 0) {

    final connection = getOrCreateConnection(layout.nodes[0], layout.nodes[1]);
    connection.attachments.clear();

    connection.attachments.add(LayoutNodeConnectionAttachment(distance: 5.0));
  }

  void addRedrawListener(VoidCallback listener) {
    _redrawNotifier.addListener(listener);
  }

  List<LayoutNode> get nodes => List.unmodifiable(layout.nodes);

  List<LayoutNodeConnection> get connections =>
      List.unmodifiable(layout.connections);

  NoValueChangeNotifier get redrawNotifier => _redrawNotifier;

  bool hasNode(LayoutNode node) => layout.nodes.contains(node);

  void removeNode(LayoutNode node) {
    if (!hasNode(node)) {
      Logger.warn("Tried to remove nonexistent node $node");
      return;
    }

    layout.connections
        .where((connection) => connection.connectsTo(node))
        .forEach(removeConnection);

    layout.nodes.remove(node);
    _redraw();
  }

  void addNode(LayoutNode node) {
    layout.nodes.add(node);
    _redraw();
  }

  void addNodes(Iterable<LayoutNode> nodes) {
    if (nodes.isNotEmpty) {
      layout.nodes.addAll(nodes);
      _redraw();
    }
  }

  bool hasConnection(LayoutNodeConnection connection) =>
      layout.connections.contains(connection);

  void removeConnection(LayoutNodeConnection connection) {
    if (!hasConnection(connection)) {
      Logger.warn("Tried to remove nonexistent connection $connection");
    }

    layout.connections.remove(connection);
    _redraw();
  }

  LayoutNodeConnection? findConnection(LayoutNode first, LayoutNode second) {
    if (!hasNode(first) || !hasNode(second)) {
      Logger.warn("Tried to find a connection between unknown nodes");
      return null;
    }

    return layout.connections
        .firstWhereOrNull((connection) => connection.connectsTo(first, second));
  }

  LayoutNodeConnection getOrCreateConnection(
      LayoutNode first, LayoutNode second) {
    if (!hasNode(first) || !hasNode(second)) {
      throw ArgumentError("Not all nodes are part of this layout");
    }

    var connection = findConnection(first, second);
    if (connection != null) {
      return connection;
    }

    connection = LayoutNodeConnection(
        firstNode: first, secondNode: second, attachments: []);
    layout.connections.add(connection);
    return connection;
  }

  LayoutNodeVisualState getNodeState(LayoutNode node) {
    return _nodeStates[node] ?? LayoutNodeVisualState.normal;
  }

  void setNodeState(LayoutNode node, LayoutNodeVisualState state) {
    _nodeStates[node] = state;
  }

  void clearNodeState(LayoutNode node) {
    _nodeStates[node] = null;
  }

  void _redraw() => _redrawNotifier.notifyListeners();

  double get scale => _scale;

  set scale(double value) {
    double clamped = ex_math.clamp(value, 0.2, 3);

    if (clamped != _scale) {
      _scale = clamped;
      _redraw();
    }
  }

  Offset get pan => _pan;

  set pan(Offset offset) {
    if (_pan != offset) {
      _pan = offset;
      _redraw();
    }
  }

  void doStartPan(Offset panPosition) {
    _setNodeStateAt(panPosition, LayoutNodeVisualState.dragged);
  }

  void doPan(Offset panPosition, Offset panDelta) {
    final node = nodes.firstWhereOrNull(
        (node) => getNodeState(node) == LayoutNodeVisualState.dragged);
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

    _setNodeStateAt(offset, LayoutNodeVisualState.hover);
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

  void _setNodeStateAt(Offset offset, LayoutNodeVisualState newState) {
    final target = findNodeAt(offset);
    if (target == null) {
      _resetNodeStates();
      return;
    }

    bool needsRedraw = nodes.map((node) {
      if (node == target && getNodeState(target) != newState) {
        setNodeState(target, newState);
        return true;
      } else {
        clearNodeState(target);
        return false;
      }
    }).any((v) => v);

    if (needsRedraw) {
      _redraw();
    }
  }

  void _resetNodeStates() {
    final needsRedraw = nodes.map((node) {
      if (getNodeState(node) == LayoutNodeVisualState.normal) {
        return false;
      }

      clearNodeState(node);
      return true;
    }).any((v) => v);

    if (needsRedraw) {
      _redraw();
    }
  }

  bool _updateGhostedNode(Offset offset) {
    final realOffset = _translateOffset(offset);

    final node = nodes.firstWhereOrNull(
        (node) => getNodeState(node) == LayoutNodeVisualState.ghosted);
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
    final node = nodes.firstWhereOrNull(
        (node) => getNodeState(node) == LayoutNodeVisualState.ghosted);
    if (node == null) {
      return;
    }

    if (offset == null) {
      nodes.remove(node);
    } else {
      node.position = _translateOffset(offset);
      clearNodeState(node);
    }

    _redraw();
  }
}
