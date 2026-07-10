// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'master.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Master _$MasterFromJson(Map<String, dynamic> json) {
  return _Master.fromJson(json);
}

/// @nodoc
mixin _$Master {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get university => throw _privateConstructorUsedError;
  String? get faculty => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;

  /// Category id matching `assets/data/specializations.json` (e.g. "ai",
  /// "management"). Null when the heuristic extractor couldn't classify it.
  String? get specialization => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime? get applicationStart => throw _privateConstructorUsedError;
  DateTime? get applicationDeadline => throw _privateConstructorUsedError;
  String? get requiredDegree => throw _privateConstructorUsedError;
  List<String> get requiredDocuments => throw _privateConstructorUsedError;
  String? get registrationLink => throw _privateConstructorUsedError;
  String? get pdfLink => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  MasterSource get source => throw _privateConstructorUsedError;

  /// True when the heuristic field extractor had low confidence — the UI
  /// surfaces this so a user (or a future admin dashboard) knows the
  /// record may need a manual fix rather than silently trusting it.
  bool get needsReview => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Master to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Master
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MasterCopyWith<Master> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MasterCopyWith<$Res> {
  factory $MasterCopyWith(Master value, $Res Function(Master) then) =
      _$MasterCopyWithImpl<$Res, Master>;
  @useResult
  $Res call(
      {String id,
      String title,
      String? university,
      String? faculty,
      String? city,
      String? specialization,
      String description,
      DateTime? applicationStart,
      DateTime? applicationDeadline,
      String? requiredDegree,
      List<String> requiredDocuments,
      String? registrationLink,
      String? pdfLink,
      String? image,
      MasterSource source,
      bool needsReview,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$MasterCopyWithImpl<$Res, $Val extends Master>
    implements $MasterCopyWith<$Res> {
  _$MasterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Master
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? university = freezed,
    Object? faculty = freezed,
    Object? city = freezed,
    Object? specialization = freezed,
    Object? description = null,
    Object? applicationStart = freezed,
    Object? applicationDeadline = freezed,
    Object? requiredDegree = freezed,
    Object? requiredDocuments = null,
    Object? registrationLink = freezed,
    Object? pdfLink = freezed,
    Object? image = freezed,
    Object? source = null,
    Object? needsReview = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      university: freezed == university
          ? _value.university
          : university // ignore: cast_nullable_to_non_nullable
              as String?,
      faculty: freezed == faculty
          ? _value.faculty
          : faculty // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      specialization: freezed == specialization
          ? _value.specialization
          : specialization // ignore: cast_nullable_to_non_nullable
              as String?,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      applicationStart: freezed == applicationStart
          ? _value.applicationStart
          : applicationStart // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      applicationDeadline: freezed == applicationDeadline
          ? _value.applicationDeadline
          : applicationDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      requiredDegree: freezed == requiredDegree
          ? _value.requiredDegree
          : requiredDegree // ignore: cast_nullable_to_non_nullable
              as String?,
      requiredDocuments: null == requiredDocuments
          ? _value.requiredDocuments
          : requiredDocuments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      registrationLink: freezed == registrationLink
          ? _value.registrationLink
          : registrationLink // ignore: cast_nullable_to_non_nullable
              as String?,
      pdfLink: freezed == pdfLink
          ? _value.pdfLink
          : pdfLink // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as MasterSource,
      needsReview: null == needsReview
          ? _value.needsReview
          : needsReview // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MasterImplCopyWith<$Res> implements $MasterCopyWith<$Res> {
  factory _$$MasterImplCopyWith(
          _$MasterImpl value, $Res Function(_$MasterImpl) then) =
      __$$MasterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String? university,
      String? faculty,
      String? city,
      String? specialization,
      String description,
      DateTime? applicationStart,
      DateTime? applicationDeadline,
      String? requiredDegree,
      List<String> requiredDocuments,
      String? registrationLink,
      String? pdfLink,
      String? image,
      MasterSource source,
      bool needsReview,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$MasterImplCopyWithImpl<$Res>
    extends _$MasterCopyWithImpl<$Res, _$MasterImpl>
    implements _$$MasterImplCopyWith<$Res> {
  __$$MasterImplCopyWithImpl(
      _$MasterImpl _value, $Res Function(_$MasterImpl) _then)
      : super(_value, _then);

  /// Create a copy of Master
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? university = freezed,
    Object? faculty = freezed,
    Object? city = freezed,
    Object? specialization = freezed,
    Object? description = null,
    Object? applicationStart = freezed,
    Object? applicationDeadline = freezed,
    Object? requiredDegree = freezed,
    Object? requiredDocuments = null,
    Object? registrationLink = freezed,
    Object? pdfLink = freezed,
    Object? image = freezed,
    Object? source = null,
    Object? needsReview = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$MasterImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      university: freezed == university
          ? _value.university
          : university // ignore: cast_nullable_to_non_nullable
              as String?,
      faculty: freezed == faculty
          ? _value.faculty
          : faculty // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      specialization: freezed == specialization
          ? _value.specialization
          : specialization // ignore: cast_nullable_to_non_nullable
              as String?,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      applicationStart: freezed == applicationStart
          ? _value.applicationStart
          : applicationStart // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      applicationDeadline: freezed == applicationDeadline
          ? _value.applicationDeadline
          : applicationDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      requiredDegree: freezed == requiredDegree
          ? _value.requiredDegree
          : requiredDegree // ignore: cast_nullable_to_non_nullable
              as String?,
      requiredDocuments: null == requiredDocuments
          ? _value._requiredDocuments
          : requiredDocuments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      registrationLink: freezed == registrationLink
          ? _value.registrationLink
          : registrationLink // ignore: cast_nullable_to_non_nullable
              as String?,
      pdfLink: freezed == pdfLink
          ? _value.pdfLink
          : pdfLink // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as MasterSource,
      needsReview: null == needsReview
          ? _value.needsReview
          : needsReview // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MasterImpl extends _Master {
  const _$MasterImpl(
      {required this.id,
      required this.title,
      this.university,
      this.faculty,
      this.city,
      this.specialization,
      required this.description,
      this.applicationStart,
      this.applicationDeadline,
      this.requiredDegree,
      final List<String> requiredDocuments = const <String>[],
      this.registrationLink,
      this.pdfLink,
      this.image,
      required this.source,
      this.needsReview = false,
      required this.createdAt,
      required this.updatedAt})
      : _requiredDocuments = requiredDocuments,
        super._();

  factory _$MasterImpl.fromJson(Map<String, dynamic> json) =>
      _$$MasterImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? university;
  @override
  final String? faculty;
  @override
  final String? city;

  /// Category id matching `assets/data/specializations.json` (e.g. "ai",
  /// "management"). Null when the heuristic extractor couldn't classify it.
  @override
  final String? specialization;
  @override
  final String description;
  @override
  final DateTime? applicationStart;
  @override
  final DateTime? applicationDeadline;
  @override
  final String? requiredDegree;
  final List<String> _requiredDocuments;
  @override
  @JsonKey()
  List<String> get requiredDocuments {
    if (_requiredDocuments is EqualUnmodifiableListView)
      return _requiredDocuments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requiredDocuments);
  }

  @override
  final String? registrationLink;
  @override
  final String? pdfLink;
  @override
  final String? image;
  @override
  final MasterSource source;

  /// True when the heuristic field extractor had low confidence — the UI
  /// surfaces this so a user (or a future admin dashboard) knows the
  /// record may need a manual fix rather than silently trusting it.
  @override
  @JsonKey()
  final bool needsReview;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Master(id: $id, title: $title, university: $university, faculty: $faculty, city: $city, specialization: $specialization, description: $description, applicationStart: $applicationStart, applicationDeadline: $applicationDeadline, requiredDegree: $requiredDegree, requiredDocuments: $requiredDocuments, registrationLink: $registrationLink, pdfLink: $pdfLink, image: $image, source: $source, needsReview: $needsReview, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MasterImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.university, university) ||
                other.university == university) &&
            (identical(other.faculty, faculty) || other.faculty == faculty) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.specialization, specialization) ||
                other.specialization == specialization) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.applicationStart, applicationStart) ||
                other.applicationStart == applicationStart) &&
            (identical(other.applicationDeadline, applicationDeadline) ||
                other.applicationDeadline == applicationDeadline) &&
            (identical(other.requiredDegree, requiredDegree) ||
                other.requiredDegree == requiredDegree) &&
            const DeepCollectionEquality()
                .equals(other._requiredDocuments, _requiredDocuments) &&
            (identical(other.registrationLink, registrationLink) ||
                other.registrationLink == registrationLink) &&
            (identical(other.pdfLink, pdfLink) || other.pdfLink == pdfLink) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.needsReview, needsReview) ||
                other.needsReview == needsReview) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      university,
      faculty,
      city,
      specialization,
      description,
      applicationStart,
      applicationDeadline,
      requiredDegree,
      const DeepCollectionEquality().hash(_requiredDocuments),
      registrationLink,
      pdfLink,
      image,
      source,
      needsReview,
      createdAt,
      updatedAt);

  /// Create a copy of Master
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MasterImplCopyWith<_$MasterImpl> get copyWith =>
      __$$MasterImplCopyWithImpl<_$MasterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MasterImplToJson(
      this,
    );
  }
}

abstract class _Master extends Master {
  const factory _Master(
      {required final String id,
      required final String title,
      final String? university,
      final String? faculty,
      final String? city,
      final String? specialization,
      required final String description,
      final DateTime? applicationStart,
      final DateTime? applicationDeadline,
      final String? requiredDegree,
      final List<String> requiredDocuments,
      final String? registrationLink,
      final String? pdfLink,
      final String? image,
      required final MasterSource source,
      final bool needsReview,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$MasterImpl;
  const _Master._() : super._();

  factory _Master.fromJson(Map<String, dynamic> json) = _$MasterImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get university;
  @override
  String? get faculty;
  @override
  String? get city;

  /// Category id matching `assets/data/specializations.json` (e.g. "ai",
  /// "management"). Null when the heuristic extractor couldn't classify it.
  @override
  String? get specialization;
  @override
  String get description;
  @override
  DateTime? get applicationStart;
  @override
  DateTime? get applicationDeadline;
  @override
  String? get requiredDegree;
  @override
  List<String> get requiredDocuments;
  @override
  String? get registrationLink;
  @override
  String? get pdfLink;
  @override
  String? get image;
  @override
  MasterSource get source;

  /// True when the heuristic field extractor had low confidence — the UI
  /// surfaces this so a user (or a future admin dashboard) knows the
  /// record may need a manual fix rather than silently trusting it.
  @override
  bool get needsReview;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Master
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MasterImplCopyWith<_$MasterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
