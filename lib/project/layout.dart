import 'package:eep_bridge_host/protogen/project/layout.pb.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

enum NodeType { station, freight_yard, intersection, train_storage }

extension NodeTypeMethods on NodeType {
  IconData toIcon() {
    switch (this) {
      case NodeType.station:
        return Icons.train;

      case NodeType.freight_yard:
        return Icons.local_shipping;

      case NodeType.intersection:
        return Icons.switch_right;

      case NodeType.train_storage:
        return Icons.bedtime;
    }
  }

  static NodeType fromMeta(NodeTypeMeta meta) {
    switch (meta) {
      case NodeTypeMeta.STATION:
        return NodeType.station;

      case NodeTypeMeta.FREIGHT_YARD:
        return NodeType.freight_yard;

      case NodeTypeMeta.INTERSECTION:
        return NodeType.intersection;

      case NodeTypeMeta.TRAIN_STORAGE:
        return NodeType.train_storage;

      default:
        throw ArgumentError("Unknown node type $meta");
    }
  }

  NodeTypeMeta toMeta() {
    switch (this) {
      case NodeType.station:
        return NodeTypeMeta.STATION;

      case NodeType.freight_yard:
        return NodeTypeMeta.FREIGHT_YARD;

      case NodeType.intersection:
        return NodeTypeMeta.INTERSECTION;

      case NodeType.train_storage:
        return NodeTypeMeta.TRAIN_STORAGE;
    }
  }
}

class Layout {
  List<LayoutNode> nodes;

  Layout._({required this.nodes});

  factory Layout(LayoutMeta meta) {
    final nodes = <LayoutNode>[];

    for (final node in meta.nodes) {
      nodes.add(LayoutNode.fromMeta(node));
    }

    return Layout._(nodes: nodes);
  }

  LayoutNode makeNewNode(NodeType type, String name) {
    final uuid = Uuid().v4obj();

    final node =
        LayoutNode(position: Offset(0, 0), type: type, uuid: uuid, name: name);

    nodes.add(node);

    return node;
  }

  LayoutMeta toMeta() => LayoutMeta(nodes: nodes.map((node) => node.toMeta()));
}

class LayoutNode {
  Offset position;
  NodeType type;
  UuidValue uuid;
  String name;

  LayoutNode(
      {required this.position,
      required this.type,
      required this.uuid,
      required this.name});

  factory LayoutNode.fromMeta(LayoutNodeMeta meta) {
    return LayoutNode(
        position: Offset(meta.position.x, meta.position.y),
        type: NodeTypeMethods.fromMeta(meta.type),
        uuid: UuidValue(meta.uuid),
        name: meta.name);
  }

  LayoutNodeMeta toMeta() => LayoutNodeMeta(
        position: NodePositionMeta(x: position.dx, y: position.dy),
        type: type.toMeta(),
        uuid: uuid.uuid,
        name: name,
      );
}
