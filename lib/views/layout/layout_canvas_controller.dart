import 'package:eep_bridge_host/logging/logger.dart';
import 'package:eep_bridge_host/project/layout.dart';
import 'package:eep_bridge_host/util/extended_math.dart' as ex_math;
import 'package:eep_bridge_host/util/iteratable_extension.dart';
import 'package:eep_bridge_host/views/layout/layout_canvas.dart';
import 'package:flutter/material.dart';

class LayoutCanvasController {
  final Layout layout;
  final List<VisualLayoutNode> _nodes;
  final List<VisualLayoutConnection> _connections;
  final NoValueChangeNotifier _redrawNotifier;

  double _scale;
  Offset _pan;

  LayoutCanvasController(this.layout)
      : _nodes = [],
        _connections = [],
        _redrawNotifier = NoValueChangeNotifier(),
        _scale = 1,
        _pan = Offset(0, 0) {
    _nodes.clear(); // Hot reload fix
    _connections.clear(); // Hot reload fix
    _nodes.addAll(
        layout.nodes.map((node) => VisualLayoutNode(underlyingNode: node)));

    getOrCreateConnection(_nodes[0], _nodes[1]);
  }

  void addRedrawListener(VoidCallback listener) {
    _redrawNotifier.addListener(listener);
  }

  List<VisualLayoutNode> get nodes => List.unmodifiable(_nodes);

  List<VisualLayoutConnection> get connections =>
      List.unmodifiable(_connections);

  NoValueChangeNotifier get redrawNotifier => _redrawNotifier;

  bool hasNode(VisualLayoutNode node) => _nodes.contains(node);

  void removeNode(VisualLayoutNode node) {
    if (!hasNode(node)) {
      Logger.warn("Tried to remove nonexistent node $node");
      return;
    }

    _connections
        .where((connection) => connection.connectsTo(node))
        .forEach(removeConnection);

    layout.nodes.remove(node.underlyingNode);
    _nodes.remove(node);
    _redraw();
  }

  void addNode(VisualLayoutNode node) {
    layout.nodes.add(node.underlyingNode);

    _nodes.add(node);
    _redraw();
  }

  void addNodes(Iterable<VisualLayoutNode> nodes) {
    if (nodes.isNotEmpty) {
      _nodes.addAll(nodes);
      _redraw();
    }
  }

  bool hasConnection(VisualLayoutConnection connection) =>
      _connections.contains(connection);

  void removeConnection(VisualLayoutConnection connection) {
    if (!hasConnection(connection)) {
      Logger.warn("Tried to remove nonexistent connection $connection");
    }

    _connections.remove(connection);
    _redraw();
  }

  VisualLayoutConnection? findConnection(
      VisualLayoutNode first, VisualLayoutNode second) {
    if(!hasNode(first) || !hasNode(second)) {
      Logger.warn("Tried to find a connection between unknown nodes");
      return null;
    }

    return connections
        .firstWhereOrNull((connection) => connection.connectsTo(first, second));
  }

  VisualLayoutConnection getOrCreateConnection(VisualLayoutNode first, VisualLayoutNode second) {
    if(!hasNode(first) || !hasNode(second)) {
      throw ArgumentError("Not all nodes are part of this layout");
    }

    var connection = findConnection(first, second);
    if(connection != null) {
      return connection;
    }

    connection = VisualLayoutConnection(firstNode: first, secondNode: second);
    _connections.add(connection);
    return connection;
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
    _setNodeStateAt(panPosition, VisualLayoutNodeState.dragged);
  }

  void doPan(Offset panPosition, Offset panDelta) {
    final node = nodes.firstWhereOrNull(
        (node) => node.state == VisualLayoutNodeState.dragged);
    if (node != null) {
      final realOffset = _translateOffset(panPosition);

      if (node.underlyingNode.position != realOffset) {
        node.underlyingNode.position = realOffset;
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

    _setNodeStateAt(offset, VisualLayoutNodeState.hover);
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

  VisualLayoutNode? findNodeAt(Offset offset) {
    Offset realOffset = _translateOffset(offset);

    return nodes.firstWhereOrNull(
        (node) => (node.underlyingNode.position - realOffset).distance <= 20);
  }

  void _setNodeStateAt(Offset offset, VisualLayoutNodeState newState) {
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
        target.state = VisualLayoutNodeState.normal;
        return false;
      }
    }).any((v) => v);

    if (needsRedraw) {
      _redraw();
    }
  }

  void _resetNodeStates() {
    final needsRedraw = nodes.map((node) {
      if (node.state == VisualLayoutNodeState.normal) {
        return false;
      }

      node.state = VisualLayoutNodeState.normal;
      return true;
    }).any((v) => v);

    if (needsRedraw) {
      _redraw();
    }
  }

  bool _updateGhostedNode(Offset offset) {
    final realOffset = _translateOffset(offset);

    final node = nodes.firstWhereOrNull(
        (node) => node.state == VisualLayoutNodeState.ghosted);
    if (node == null) {
      return false;
    }

    if (node.underlyingNode.position != realOffset) {
      node.underlyingNode.position = realOffset;
      _redraw();
    }

    return true;
  }

  void _dropGhostedNode(Offset? offset) {
    final node = nodes.firstWhereOrNull(
        (node) => node.state == VisualLayoutNodeState.ghosted);
    if (node == null) {
      return;
    }

    if (offset == null) {
      nodes.remove(node);
    } else {
      node.underlyingNode.position = _translateOffset(offset);
      node.state = VisualLayoutNodeState.normal;
    }

    _redraw();
  }
}
