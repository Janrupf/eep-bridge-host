///
//  Generated code. Do not modify.
//  source: network/packets.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class ObjectType extends $pb.ProtobufEnum {
  static const ObjectType SWITCH = ObjectType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SWITCH');
  static const ObjectType SIGNAL = ObjectType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SIGNAL');

  static const $core.List<ObjectType> values = <ObjectType> [
    SWITCH,
    SIGNAL,
  ];

  static final $core.Map<$core.int, ObjectType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ObjectType? valueOf($core.int value) => _byValue[value];

  const ObjectType._($core.int v, $core.String n) : super(v, n);
}

