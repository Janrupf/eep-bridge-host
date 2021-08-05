///
//  Generated code. Do not modify.
//  source: project/layout.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class NodeTypeMeta extends $pb.ProtobufEnum {
  static const NodeTypeMeta STATION = NodeTypeMeta._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'STATION');
  static const NodeTypeMeta FREIGHT_YARD = NodeTypeMeta._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'FREIGHT_YARD');
  static const NodeTypeMeta INTERSECTION = NodeTypeMeta._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'INTERSECTION');
  static const NodeTypeMeta TRAIN_STORAGE = NodeTypeMeta._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'TRAIN_STORAGE');

  static const $core.List<NodeTypeMeta> values = <NodeTypeMeta> [
    STATION,
    FREIGHT_YARD,
    INTERSECTION,
    TRAIN_STORAGE,
  ];

  static final $core.Map<$core.int, NodeTypeMeta> _byValue = $pb.ProtobufEnum.initByValue(values);
  static NodeTypeMeta? valueOf($core.int value) => _byValue[value];

  const NodeTypeMeta._($core.int v, $core.String n) : super(v, n);
}

