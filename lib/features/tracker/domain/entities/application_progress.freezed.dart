// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'application_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ApplicationProgress _$ApplicationProgressFromJson(Map<String, dynamic> json) {
  return _ApplicationProgress.fromJson(json);
}

/// @nodoc
mixin _$ApplicationProgress {
  String get masterId => throw _privateConstructorUsedError;
  ApplicationStatus get status => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ApplicationProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApplicationProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApplicationProgressCopyWith<ApplicationProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApplicationProgressCopyWith<$Res> {
  factory $ApplicationProgressCopyWith(
          ApplicationProgress value, $Res Function(ApplicationProgress) then) =
      _$ApplicationProgressCopyWithImpl<$Res, ApplicationProgress>;
  @useResult
  $Res call(
      {String masterId,
      ApplicationStatus status,
      String? notes,
      DateTime updatedAt});
}

/// @nodoc
class _$ApplicationProgressCopyWithImpl<$Res, $Val extends ApplicationProgress>
    implements $ApplicationProgressCopyWith<$Res> {
  _$ApplicationProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApplicationProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? masterId = null,
    Object? status = null,
    Object? notes = freezed,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      masterId: null == masterId
          ? _value.masterId
          : masterId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ApplicationStatus,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApplicationProgressImplCopyWith<$Res>
    implements $ApplicationProgressCopyWith<$Res> {
  factory _$$ApplicationProgressImplCopyWith(_$ApplicationProgressImpl value,
          $Res Function(_$ApplicationProgressImpl) then) =
      __$$ApplicationProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String masterId,
      ApplicationStatus status,
      String? notes,
      DateTime updatedAt});
}

/// @nodoc
class __$$ApplicationProgressImplCopyWithImpl<$Res>
    extends _$ApplicationProgressCopyWithImpl<$Res, _$ApplicationProgressImpl>
    implements _$$ApplicationProgressImplCopyWith<$Res> {
  __$$ApplicationProgressImplCopyWithImpl(_$ApplicationProgressImpl _value,
      $Res Function(_$ApplicationProgressImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApplicationProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? masterId = null,
    Object? status = null,
    Object? notes = freezed,
    Object? updatedAt = null,
  }) {
    return _then(_$ApplicationProgressImpl(
      masterId: null == masterId
          ? _value.masterId
          : masterId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ApplicationStatus,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApplicationProgressImpl implements _ApplicationProgress {
  const _$ApplicationProgressImpl(
      {required this.masterId,
      required this.status,
      this.notes,
      required this.updatedAt});

  factory _$ApplicationProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApplicationProgressImplFromJson(json);

  @override
  final String masterId;
  @override
  final ApplicationStatus status;
  @override
  final String? notes;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ApplicationProgress(masterId: $masterId, status: $status, notes: $notes, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplicationProgressImpl &&
            (identical(other.masterId, masterId) ||
                other.masterId == masterId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, masterId, status, notes, updatedAt);

  /// Create a copy of ApplicationProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplicationProgressImplCopyWith<_$ApplicationProgressImpl> get copyWith =>
      __$$ApplicationProgressImplCopyWithImpl<_$ApplicationProgressImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApplicationProgressImplToJson(
      this,
    );
  }
}

abstract class _ApplicationProgress implements ApplicationProgress {
  const factory _ApplicationProgress(
      {required final String masterId,
      required final ApplicationStatus status,
      final String? notes,
      required final DateTime updatedAt}) = _$ApplicationProgressImpl;

  factory _ApplicationProgress.fromJson(Map<String, dynamic> json) =
      _$ApplicationProgressImpl.fromJson;

  @override
  String get masterId;
  @override
  ApplicationStatus get status;
  @override
  String? get notes;
  @override
  DateTime get updatedAt;

  /// Create a copy of ApplicationProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApplicationProgressImplCopyWith<_$ApplicationProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
