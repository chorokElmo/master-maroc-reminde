// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FavoriteEntry _$FavoriteEntryFromJson(Map<String, dynamic> json) {
  return _FavoriteEntry.fromJson(json);
}

/// @nodoc
mixin _$FavoriteEntry {
  String get masterId => throw _privateConstructorUsedError;
  DateTime get addedAt => throw _privateConstructorUsedError;

  /// Ids of the currently scheduled local notifications for this
  /// Master's deadline, so they can be cancelled/rescheduled cleanly.
  List<int> get notificationIds => throw _privateConstructorUsedError;

  /// Days-before-deadline ladder used to schedule reminders. Defaults to
  /// [defaultReminderDaysBefore] (30/15/7/3/1/0) when null — stored only
  /// when the user picks a custom interval.
  List<int>? get customReminderDaysBefore => throw _privateConstructorUsedError;

  /// Serializes this FavoriteEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FavoriteEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FavoriteEntryCopyWith<FavoriteEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FavoriteEntryCopyWith<$Res> {
  factory $FavoriteEntryCopyWith(
          FavoriteEntry value, $Res Function(FavoriteEntry) then) =
      _$FavoriteEntryCopyWithImpl<$Res, FavoriteEntry>;
  @useResult
  $Res call(
      {String masterId,
      DateTime addedAt,
      List<int> notificationIds,
      List<int>? customReminderDaysBefore});
}

/// @nodoc
class _$FavoriteEntryCopyWithImpl<$Res, $Val extends FavoriteEntry>
    implements $FavoriteEntryCopyWith<$Res> {
  _$FavoriteEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FavoriteEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? masterId = null,
    Object? addedAt = null,
    Object? notificationIds = null,
    Object? customReminderDaysBefore = freezed,
  }) {
    return _then(_value.copyWith(
      masterId: null == masterId
          ? _value.masterId
          : masterId // ignore: cast_nullable_to_non_nullable
              as String,
      addedAt: null == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      notificationIds: null == notificationIds
          ? _value.notificationIds
          : notificationIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      customReminderDaysBefore: freezed == customReminderDaysBefore
          ? _value.customReminderDaysBefore
          : customReminderDaysBefore // ignore: cast_nullable_to_non_nullable
              as List<int>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FavoriteEntryImplCopyWith<$Res>
    implements $FavoriteEntryCopyWith<$Res> {
  factory _$$FavoriteEntryImplCopyWith(
          _$FavoriteEntryImpl value, $Res Function(_$FavoriteEntryImpl) then) =
      __$$FavoriteEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String masterId,
      DateTime addedAt,
      List<int> notificationIds,
      List<int>? customReminderDaysBefore});
}

/// @nodoc
class __$$FavoriteEntryImplCopyWithImpl<$Res>
    extends _$FavoriteEntryCopyWithImpl<$Res, _$FavoriteEntryImpl>
    implements _$$FavoriteEntryImplCopyWith<$Res> {
  __$$FavoriteEntryImplCopyWithImpl(
      _$FavoriteEntryImpl _value, $Res Function(_$FavoriteEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of FavoriteEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? masterId = null,
    Object? addedAt = null,
    Object? notificationIds = null,
    Object? customReminderDaysBefore = freezed,
  }) {
    return _then(_$FavoriteEntryImpl(
      masterId: null == masterId
          ? _value.masterId
          : masterId // ignore: cast_nullable_to_non_nullable
              as String,
      addedAt: null == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      notificationIds: null == notificationIds
          ? _value._notificationIds
          : notificationIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      customReminderDaysBefore: freezed == customReminderDaysBefore
          ? _value._customReminderDaysBefore
          : customReminderDaysBefore // ignore: cast_nullable_to_non_nullable
              as List<int>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FavoriteEntryImpl implements _FavoriteEntry {
  const _$FavoriteEntryImpl(
      {required this.masterId,
      required this.addedAt,
      final List<int> notificationIds = const <int>[],
      final List<int>? customReminderDaysBefore})
      : _notificationIds = notificationIds,
        _customReminderDaysBefore = customReminderDaysBefore;

  factory _$FavoriteEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$FavoriteEntryImplFromJson(json);

  @override
  final String masterId;
  @override
  final DateTime addedAt;

  /// Ids of the currently scheduled local notifications for this
  /// Master's deadline, so they can be cancelled/rescheduled cleanly.
  final List<int> _notificationIds;

  /// Ids of the currently scheduled local notifications for this
  /// Master's deadline, so they can be cancelled/rescheduled cleanly.
  @override
  @JsonKey()
  List<int> get notificationIds {
    if (_notificationIds is EqualUnmodifiableListView) return _notificationIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notificationIds);
  }

  /// Days-before-deadline ladder used to schedule reminders. Defaults to
  /// [defaultReminderDaysBefore] (30/15/7/3/1/0) when null — stored only
  /// when the user picks a custom interval.
  final List<int>? _customReminderDaysBefore;

  /// Days-before-deadline ladder used to schedule reminders. Defaults to
  /// [defaultReminderDaysBefore] (30/15/7/3/1/0) when null — stored only
  /// when the user picks a custom interval.
  @override
  List<int>? get customReminderDaysBefore {
    final value = _customReminderDaysBefore;
    if (value == null) return null;
    if (_customReminderDaysBefore is EqualUnmodifiableListView)
      return _customReminderDaysBefore;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'FavoriteEntry(masterId: $masterId, addedAt: $addedAt, notificationIds: $notificationIds, customReminderDaysBefore: $customReminderDaysBefore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FavoriteEntryImpl &&
            (identical(other.masterId, masterId) ||
                other.masterId == masterId) &&
            (identical(other.addedAt, addedAt) || other.addedAt == addedAt) &&
            const DeepCollectionEquality()
                .equals(other._notificationIds, _notificationIds) &&
            const DeepCollectionEquality().equals(
                other._customReminderDaysBefore, _customReminderDaysBefore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      masterId,
      addedAt,
      const DeepCollectionEquality().hash(_notificationIds),
      const DeepCollectionEquality().hash(_customReminderDaysBefore));

  /// Create a copy of FavoriteEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FavoriteEntryImplCopyWith<_$FavoriteEntryImpl> get copyWith =>
      __$$FavoriteEntryImplCopyWithImpl<_$FavoriteEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FavoriteEntryImplToJson(
      this,
    );
  }
}

abstract class _FavoriteEntry implements FavoriteEntry {
  const factory _FavoriteEntry(
      {required final String masterId,
      required final DateTime addedAt,
      final List<int> notificationIds,
      final List<int>? customReminderDaysBefore}) = _$FavoriteEntryImpl;

  factory _FavoriteEntry.fromJson(Map<String, dynamic> json) =
      _$FavoriteEntryImpl.fromJson;

  @override
  String get masterId;
  @override
  DateTime get addedAt;

  /// Ids of the currently scheduled local notifications for this
  /// Master's deadline, so they can be cancelled/rescheduled cleanly.
  @override
  List<int> get notificationIds;

  /// Days-before-deadline ladder used to schedule reminders. Defaults to
  /// [defaultReminderDaysBefore] (30/15/7/3/1/0) when null — stored only
  /// when the user picks a custom interval.
  @override
  List<int>? get customReminderDaysBefore;

  /// Create a copy of FavoriteEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FavoriteEntryImplCopyWith<_$FavoriteEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
