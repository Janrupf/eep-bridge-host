import 'package:flutter/material.dart';
import 'package:eep_bridge_host/protogen/project/layout.pb.dart';
import 'package:uuid/uuid.dart';

enum NodeType {
  station,
  freight_yard,
  intersection,
  train_storage
}

class Layout {
  List<LayoutNode> nodes;

  Layout._({required this.nodes});

  factory Layout(LayoutMeta meta) {
    final nodes = <LayoutNode>[];

    for(final node in meta.nodes) {
      nodes.add(LayoutNode(node));
    }

    return Layout._(nodes: nodes);
  }
}

class LayoutNode {
  Offset position;
  NodeType type;
  UuidValue uuid;

  LayoutNode._({required this.position, required this.type, required this.uuid});

  factory LayoutNode(LayoutNodeMeta meta) {
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

    return LayoutNode._(
      position: Offset(meta.position.x, meta.position.y),
      type: type,
      uuid: UuidValue(meta.uuid)
    );
  }
}
