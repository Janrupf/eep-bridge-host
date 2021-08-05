import 'package:flutter/material.dart';
import 'package:eep_bridge_host/protogen/project/layout.pb.dart';
import 'package:uuid/uuid.dart';

enum NodeType {
  station,
  freight_yard,
  intersection,
  train_storage
}

extension NodeTypeMethods on NodeType {
  IconData toIcon() {
    switch(this) {
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
}

class Layout {
  List<LayoutNode> nodes;

  Layout._({required this.nodes});

  factory Layout(LayoutMeta meta) {
    final nodes = <LayoutNode>[];

    for(final node in meta.nodes) {
      nodes.add(LayoutNode.fromMeta(node));
    }

    return Layout._(nodes: nodes);
  }

  LayoutNode makeNewNode(NodeType type, String name) {
    final uuid = Uuid().v4obj();

    final node = LayoutNode(
      position: Offset(0, 0),
      type: type,
      uuid: uuid,
      name: name
    );

    nodes.add(node);

    return node;
  }
}

class LayoutNode {
  Offset position;
  NodeType type;
  UuidValue uuid;
  String name;

  LayoutNode({required this.position, required this.type, required this.uuid, required this.name});

  factory LayoutNode.fromMeta(LayoutNodeMeta meta) {
    final NodeType type;

    switch(meta.type) {
      case NodeTypeMeta.STATION:
        type = NodeType.station;
        break;

      case NodeTypeMeta.FREIGHT_YARD:
        type = NodeType.freight_yard;
        break;

      case NodeTypeMeta.INTERSECTION:
        type = NodeType.intersection;
        break;

      case NodeTypeMeta.TRAIN_STORAGE:
        type = NodeType.train_storage;
        break;

      default:
        throw ArgumentError("Unknown node type ${meta.type}");
    }

    return LayoutNode(
      position: Offset(meta.position.x, meta.position.y),
      type: type,
      uuid: UuidValue(meta.uuid),
      name: meta.name
    );
  }
}
