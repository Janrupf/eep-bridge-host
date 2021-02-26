///
//  Generated code. Do not modify.
//  source: network/packets.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'definitions.pb.dart' as $0;

class Handshake extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Handshake', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'net.janrupf.eep.network.protocol'), createEmptyInstance: create)
    ..aOM<$0.Version>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'clientVersion', subBuilder: $0.Version.create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'clientIdentifier')
    ..aOM<$0.Version>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'protocolVersion', subBuilder: $0.Version.create)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'projectIdentifier')
    ..hasRequiredFields = false
  ;

  Handshake._() : super();
  factory Handshake({
    $0.Version? clientVersion,
    $core.String? clientIdentifier,
    $0.Version? protocolVersion,
    $core.String? projectIdentifier,
  }) {
    final _result = create();
    if (clientVersion != null) {
      _result.clientVersion = clientVersion;
    }
    if (clientIdentifier != null) {
      _result.clientIdentifier = clientIdentifier;
    }
    if (protocolVersion != null) {
      _result.protocolVersion = protocolVersion;
    }
    if (projectIdentifier != null) {
      _result.projectIdentifier = projectIdentifier;
    }
    return _result;
  }
  factory Handshake.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Handshake.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Handshake clone() => Handshake()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Handshake copyWith(void Function(Handshake) updates) => super.copyWith((message) => updates(message as Handshake)) as Handshake; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Handshake create() => Handshake._();
  Handshake createEmptyInstance() => create();
  static $pb.PbList<Handshake> createRepeated() => $pb.PbList<Handshake>();
  @$core.pragma('dart2js:noInline')
  static Handshake getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Handshake>(create);
  static Handshake? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Version get clientVersion => $_getN(0);
  @$pb.TagNumber(1)
  set clientVersion($0.Version v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasClientVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientVersion() => clearField(1);
  @$pb.TagNumber(1)
  $0.Version ensureClientVersion() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get clientIdentifier => $_getSZ(1);
  @$pb.TagNumber(2)
  set clientIdentifier($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasClientIdentifier() => $_has(1);
  @$pb.TagNumber(2)
  void clearClientIdentifier() => clearField(2);

  @$pb.TagNumber(3)
  $0.Version get protocolVersion => $_getN(2);
  @$pb.TagNumber(3)
  set protocolVersion($0.Version v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasProtocolVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearProtocolVersion() => clearField(3);
  @$pb.TagNumber(3)
  $0.Version ensureProtocolVersion() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get projectIdentifier => $_getSZ(3);
  @$pb.TagNumber(4)
  set projectIdentifier($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasProjectIdentifier() => $_has(3);
  @$pb.TagNumber(4)
  void clearProjectIdentifier() => clearField(4);
}

class HandshakeSuccessful extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'HandshakeSuccessful', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'net.janrupf.eep.network.protocol'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'unpause')
    ..hasRequiredFields = false
  ;

  HandshakeSuccessful._() : super();
  factory HandshakeSuccessful({
    $core.bool? unpause,
  }) {
    final _result = create();
    if (unpause != null) {
      _result.unpause = unpause;
    }
    return _result;
  }
  factory HandshakeSuccessful.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HandshakeSuccessful.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HandshakeSuccessful clone() => HandshakeSuccessful()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HandshakeSuccessful copyWith(void Function(HandshakeSuccessful) updates) => super.copyWith((message) => updates(message as HandshakeSuccessful)) as HandshakeSuccessful; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HandshakeSuccessful create() => HandshakeSuccessful._();
  HandshakeSuccessful createEmptyInstance() => create();
  static $pb.PbList<HandshakeSuccessful> createRepeated() => $pb.PbList<HandshakeSuccessful>();
  @$core.pragma('dart2js:noInline')
  static HandshakeSuccessful getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HandshakeSuccessful>(create);
  static HandshakeSuccessful? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get unpause => $_getBF(0);
  @$pb.TagNumber(1)
  set unpause($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUnpause() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnpause() => clearField(1);
}

class HandshakeFailure extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'HandshakeFailure', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'net.janrupf.eep.network.protocol'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'reason')
    ..hasRequiredFields = false
  ;

  HandshakeFailure._() : super();
  factory HandshakeFailure({
    $core.String? reason,
  }) {
    final _result = create();
    if (reason != null) {
      _result.reason = reason;
    }
    return _result;
  }
  factory HandshakeFailure.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HandshakeFailure.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HandshakeFailure clone() => HandshakeFailure()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HandshakeFailure copyWith(void Function(HandshakeFailure) updates) => super.copyWith((message) => updates(message as HandshakeFailure)) as HandshakeFailure; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HandshakeFailure create() => HandshakeFailure._();
  HandshakeFailure createEmptyInstance() => create();
  static $pb.PbList<HandshakeFailure> createRepeated() => $pb.PbList<HandshakeFailure>();
  @$core.pragma('dart2js:noInline')
  static HandshakeFailure getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HandshakeFailure>(create);
  static HandshakeFailure? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reason => $_getSZ(0);
  @$pb.TagNumber(1)
  set reason($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasReason() => $_has(0);
  @$pb.TagNumber(1)
  void clearReason() => clearField(1);
}

enum HandshakeResponse_Result {
  success, 
  failure, 
  notSet
}

class HandshakeResponse extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, HandshakeResponse_Result> _HandshakeResponse_ResultByTag = {
    1 : HandshakeResponse_Result.success,
    2 : HandshakeResponse_Result.failure,
    0 : HandshakeResponse_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'HandshakeResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'net.janrupf.eep.network.protocol'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<HandshakeSuccessful>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'success', subBuilder: HandshakeSuccessful.create)
    ..aOM<HandshakeFailure>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'failure', subBuilder: HandshakeFailure.create)
    ..hasRequiredFields = false
  ;

  HandshakeResponse._() : super();
  factory HandshakeResponse({
    HandshakeSuccessful? success,
    HandshakeFailure? failure,
  }) {
    final _result = create();
    if (success != null) {
      _result.success = success;
    }
    if (failure != null) {
      _result.failure = failure;
    }
    return _result;
  }
  factory HandshakeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HandshakeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HandshakeResponse clone() => HandshakeResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HandshakeResponse copyWith(void Function(HandshakeResponse) updates) => super.copyWith((message) => updates(message as HandshakeResponse)) as HandshakeResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HandshakeResponse create() => HandshakeResponse._();
  HandshakeResponse createEmptyInstance() => create();
  static $pb.PbList<HandshakeResponse> createRepeated() => $pb.PbList<HandshakeResponse>();
  @$core.pragma('dart2js:noInline')
  static HandshakeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HandshakeResponse>(create);
  static HandshakeResponse? _defaultInstance;

  HandshakeResponse_Result whichResult() => _HandshakeResponse_ResultByTag[$_whichOneof(0)]!;
  void clearResult() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  HandshakeSuccessful get success => $_getN(0);
  @$pb.TagNumber(1)
  set success(HandshakeSuccessful v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => clearField(1);
  @$pb.TagNumber(1)
  HandshakeSuccessful ensureSuccess() => $_ensure(0);

  @$pb.TagNumber(2)
  HandshakeFailure get failure => $_getN(1);
  @$pb.TagNumber(2)
  set failure(HandshakeFailure v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasFailure() => $_has(1);
  @$pb.TagNumber(2)
  void clearFailure() => clearField(2);
  @$pb.TagNumber(2)
  HandshakeFailure ensureFailure() => $_ensure(1);
}

class Heartbeat extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Heartbeat', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'net.janrupf.eep.network.protocol'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  Heartbeat._() : super();
  factory Heartbeat() => create();
  factory Heartbeat.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Heartbeat.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Heartbeat clone() => Heartbeat()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Heartbeat copyWith(void Function(Heartbeat) updates) => super.copyWith((message) => updates(message as Heartbeat)) as Heartbeat; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Heartbeat create() => Heartbeat._();
  Heartbeat createEmptyInstance() => create();
  static $pb.PbList<Heartbeat> createRepeated() => $pb.PbList<Heartbeat>();
  @$core.pragma('dart2js:noInline')
  static Heartbeat getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Heartbeat>(create);
  static Heartbeat? _defaultInstance;
}

