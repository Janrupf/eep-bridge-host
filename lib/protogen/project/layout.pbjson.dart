///
//  Generated code. Do not modify.
//  source: project/layout.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use nodeTypeMetaDescriptor instead')
const NodeTypeMeta$json = const {
  '1': 'NodeTypeMeta',
  '2': const [
    const {'1': 'STATION', '2': 0},
    const {'1': 'FREIGHT_YARD', '2': 1},
    const {'1': 'INTERSECTION', '2': 2},
    const {'1': 'TRAIN_STORAGE', '2': 3},
  ],
};

/// Descriptor for `NodeTypeMeta`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List nodeTypeMetaDescriptor = $convert.base64Decode('CgxOb2RlVHlwZU1ldGESCwoHU1RBVElPThAAEhAKDEZSRUlHSFRfWUFSRBABEhAKDElOVEVSU0VDVElPThACEhEKDVRSQUlOX1NUT1JBR0UQAw==');
@$core.Deprecated('Use nodePositionMetaDescriptor instead')
const NodePositionMeta$json = const {
  '1': 'NodePositionMeta',
  '2': const [
    const {'1': 'x', '3': 1, '4': 1, '5': 1, '10': 'x'},
    const {'1': 'y', '3': 2, '4': 1, '5': 1, '10': 'y'},
  ],
};

/// Descriptor for `NodePositionMeta`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nodePositionMetaDescriptor = $convert.base64Decode('ChBOb2RlUG9zaXRpb25NZXRhEgwKAXgYASABKAFSAXgSDAoBeRgCIAEoAVIBeQ==');
@$core.Deprecated('Use layoutNodeMetaDescriptor instead')
const LayoutNodeMeta$json = const {
  '1': 'LayoutNodeMeta',
  '2': const [
    const {'1': 'position', '3': 1, '4': 1, '5': 11, '6': '.net.janrupf.eep.project.NodePositionMeta', '10': 'position'},
    const {'1': 'type', '3': 2, '4': 1, '5': 14, '6': '.net.janrupf.eep.project.NodeTypeMeta', '10': 'type'},
    const {'1': 'uuid', '3': 3, '4': 1, '5': 9, '10': 'uuid'},
  ],
};

/// Descriptor for `LayoutNodeMeta`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List layoutNodeMetaDescriptor = $convert.base64Decode('Cg5MYXlvdXROb2RlTWV0YRJFCghwb3NpdGlvbhgBIAEoCzIpLm5ldC5qYW5ydXBmLmVlcC5wcm9qZWN0Lk5vZGVQb3NpdGlvbk1ldGFSCHBvc2l0aW9uEjkKBHR5cGUYAiABKA4yJS5uZXQuamFucnVwZi5lZXAucHJvamVjdC5Ob2RlVHlwZU1ldGFSBHR5cGUSEgoEdXVpZBgDIAEoCVIEdXVpZA==');
@$core.Deprecated('Use layoutMetaDescriptor instead')
const LayoutMeta$json = const {
  '1': 'LayoutMeta',
  '2': const [
    const {'1': 'nodes', '3': 1, '4': 3, '5': 11, '6': '.net.janrupf.eep.project.LayoutNodeMeta', '10': 'nodes'},
  ],
};

/// Descriptor for `LayoutMeta`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List layoutMetaDescriptor = $convert.base64Decode('CgpMYXlvdXRNZXRhEj0KBW5vZGVzGAEgAygLMicubmV0LmphbnJ1cGYuZWVwLnByb2plY3QuTGF5b3V0Tm9kZU1ldGFSBW5vZGVz');
