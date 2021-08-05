///
//  Generated code. Do not modify.
//  source: project/layout.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'layout.pbenum.dart';

export 'layout.pbenum.dart';

class NodePositionMeta extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'NodePositionMeta', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'net.janrupf.eep.project'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'x', $pb.PbFieldType.OD)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'y', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  NodePositionMeta._() : super();
  factory NodePositionMeta({
    $core.double? x,
    $core.double? y,
  }) {
    final _result = create();
    if (x != null) {
      _result.x = x;
    }
    if (y != null) {
      _result.y = y;
    }
    return _result;
  }
  factory NodePositionMeta.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NodePositionMeta.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  NodePositionMeta clone() => NodePositionMeta()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  NodePositionMeta copyWith(void Function(NodePositionMeta) updates) => super.copyWith((message) => updates(message as NodePositionMeta)) as NodePositionMeta; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NodePositionMeta create() => NodePositionMeta._();
  NodePositionMeta createEmptyInstance() => create();
  static $pb.PbList<NodePositionMeta> createRepeated() => $pb.PbList<NodePositionMeta>();
  @$core.pragma('dart2js:noInline')
  static NodePositionMeta getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NodePositionMeta>(create);
  static NodePositionMeta? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get x => $_getN(0);
  @$pb.TagNumber(1)
  set x($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get y => $_getN(1);
  @$pb.TagNumber(2)
  set y($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => clearField(2);
}

class LayoutNodeMeta extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LayoutNodeMeta', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'net.janrupf.eep.project'), createEmptyInstance: create)
    ..aOM<NodePositionMeta>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'position', subBuilder: NodePositionMeta.create)
    ..e<NodeTypeMeta>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: NodeTypeMeta.STATION, valueOf: NodeTypeMeta.valueOf, enumValues: NodeTypeMeta.values)
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..hasRequiredFields = false
  ;

  LayoutNodeMeta._() : super();
  factory LayoutNodeMeta({
    NodePositionMeta? position,
    NodeTypeMeta? type,
    $core.String? uuid,
    $core.String? name,
  }) {
    final _result = create();
    if (position != null) {
      _result.position = position;
    }
    if (type != null) {
      _result.type = type;
    }
    if (uuid != null) {
      _result.uuid = uuid;
    }
    if (name != null) {
      _result.name = name;
    }
    return _result;
  }
  factory LayoutNodeMeta.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LayoutNodeMeta.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LayoutNodeMeta clone() => LayoutNodeMeta()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LayoutNodeMeta copyWith(void Function(LayoutNodeMeta) updates) => super.copyWith((message) => updates(message as LayoutNodeMeta)) as LayoutNodeMeta; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LayoutNodeMeta create() => LayoutNodeMeta._();
  LayoutNodeMeta createEmptyInstance() => create();
  static $pb.PbList<LayoutNodeMeta> createRepeated() => $pb.PbList<LayoutNodeMeta>();
  @$core.pragma('dart2js:noInline')
  static LayoutNodeMeta getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LayoutNodeMeta>(create);
  static LayoutNodeMeta? _defaultInstance;

  @$pb.TagNumber(1)
  NodePositionMeta get position => $_getN(0);
  @$pb.TagNumber(1)
  set position(NodePositionMeta v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPosition() => $_has(0);
  @$pb.TagNumber(1)
  void clearPosition() => clearField(1);
  @$pb.TagNumber(1)
  NodePositionMeta ensurePosition() => $_ensure(0);

  @$pb.TagNumber(2)
  NodeTypeMeta get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(NodeTypeMeta v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get uuid => $_getSZ(2);
  @$pb.TagNumber(3)
  set uuid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUuid() => $_has(2);
  @$pb.TagNumber(3)
  void clearUuid() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => clearField(4);
}

class LayoutMeta extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LayoutMeta', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'net.janrupf.eep.project'), createEmptyInstance: create)
    ..pc<LayoutNodeMeta>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nodes', $pb.PbFieldType.PM, subBuilder: LayoutNodeMeta.create)
    ..hasRequiredFields = false
  ;

  LayoutMeta._() : super();
  factory LayoutMeta({
    $core.Iterable<LayoutNodeMeta>? nodes,
  }) {
    final _result = create();
    if (nodes != null) {
      _result.nodes.addAll(nodes);
    }
    return _result;
  }
  factory LayoutMeta.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LayoutMeta.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LayoutMeta clone() => LayoutMeta()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LayoutMeta copyWith(void Function(LayoutMeta) updates) => super.copyWith((message) => updates(message as LayoutMeta)) as LayoutMeta; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LayoutMeta create() => LayoutMeta._();
  LayoutMeta createEmptyInstance() => create();
  static $pb.PbList<LayoutMeta> createRepeated() => $pb.PbList<LayoutMeta>();
  @$core.pragma('dart2js:noInline')
  static LayoutMeta getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LayoutMeta>(create);
  static LayoutMeta? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<LayoutNodeMeta> get nodes => $_getList(0);
}

