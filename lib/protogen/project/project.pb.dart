///
//  Generated code. Do not modify.
//  source: project/project.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'layout.pb.dart' as $0;

class ProjectMeta extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ProjectMeta', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'net.janrupf.eep.project'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOM<$0.LayoutMeta>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'layout', subBuilder: $0.LayoutMeta.create)
    ..hasRequiredFields = false
  ;

  ProjectMeta._() : super();
  factory ProjectMeta({
    $core.String? name,
    $0.LayoutMeta? layout,
  }) {
    final _result = create();
    if (name != null) {
      _result.name = name;
    }
    if (layout != null) {
      _result.layout = layout;
    }
    return _result;
  }
  factory ProjectMeta.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProjectMeta.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ProjectMeta clone() => ProjectMeta()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ProjectMeta copyWith(void Function(ProjectMeta) updates) => super.copyWith((message) => updates(message as ProjectMeta)) as ProjectMeta; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ProjectMeta create() => ProjectMeta._();
  ProjectMeta createEmptyInstance() => create();
  static $pb.PbList<ProjectMeta> createRepeated() => $pb.PbList<ProjectMeta>();
  @$core.pragma('dart2js:noInline')
  static ProjectMeta getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProjectMeta>(create);
  static ProjectMeta? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $0.LayoutMeta get layout => $_getN(1);
  @$pb.TagNumber(2)
  set layout($0.LayoutMeta v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasLayout() => $_has(1);
  @$pb.TagNumber(2)
  void clearLayout() => clearField(2);
  @$pb.TagNumber(2)
  $0.LayoutMeta ensureLayout() => $_ensure(1);
}

