// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stored_document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StoredDocument _$StoredDocumentFromJson(Map<String, dynamic> json) {
  return _StoredDocument.fromJson(json);
}

/// @nodoc
mixin _$StoredDocument {
  DocumentType get type => throw _privateConstructorUsedError;
  String get filePath => throw _privateConstructorUsedError;
  String get fileName => throw _privateConstructorUsedError;
  DateTime get uploadedAt => throw _privateConstructorUsedError;

  /// Serializes this StoredDocument to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoredDocument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoredDocumentCopyWith<StoredDocument> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoredDocumentCopyWith<$Res> {
  factory $StoredDocumentCopyWith(
          StoredDocument value, $Res Function(StoredDocument) then) =
      _$StoredDocumentCopyWithImpl<$Res, StoredDocument>;
  @useResult
  $Res call(
      {DocumentType type,
      String filePath,
      String fileName,
      DateTime uploadedAt});
}

/// @nodoc
class _$StoredDocumentCopyWithImpl<$Res, $Val extends StoredDocument>
    implements $StoredDocumentCopyWith<$Res> {
  _$StoredDocumentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoredDocument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? filePath = null,
    Object? fileName = null,
    Object? uploadedAt = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as DocumentType,
      filePath: null == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      uploadedAt: null == uploadedAt
          ? _value.uploadedAt
          : uploadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoredDocumentImplCopyWith<$Res>
    implements $StoredDocumentCopyWith<$Res> {
  factory _$$StoredDocumentImplCopyWith(_$StoredDocumentImpl value,
          $Res Function(_$StoredDocumentImpl) then) =
      __$$StoredDocumentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DocumentType type,
      String filePath,
      String fileName,
      DateTime uploadedAt});
}

/// @nodoc
class __$$StoredDocumentImplCopyWithImpl<$Res>
    extends _$StoredDocumentCopyWithImpl<$Res, _$StoredDocumentImpl>
    implements _$$StoredDocumentImplCopyWith<$Res> {
  __$$StoredDocumentImplCopyWithImpl(
      _$StoredDocumentImpl _value, $Res Function(_$StoredDocumentImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoredDocument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? filePath = null,
    Object? fileName = null,
    Object? uploadedAt = null,
  }) {
    return _then(_$StoredDocumentImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as DocumentType,
      filePath: null == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      uploadedAt: null == uploadedAt
          ? _value.uploadedAt
          : uploadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoredDocumentImpl implements _StoredDocument {
  const _$StoredDocumentImpl(
      {required this.type,
      required this.filePath,
      required this.fileName,
      required this.uploadedAt});

  factory _$StoredDocumentImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoredDocumentImplFromJson(json);

  @override
  final DocumentType type;
  @override
  final String filePath;
  @override
  final String fileName;
  @override
  final DateTime uploadedAt;

  @override
  String toString() {
    return 'StoredDocument(type: $type, filePath: $filePath, fileName: $fileName, uploadedAt: $uploadedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoredDocumentImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.uploadedAt, uploadedAt) ||
                other.uploadedAt == uploadedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, type, filePath, fileName, uploadedAt);

  /// Create a copy of StoredDocument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoredDocumentImplCopyWith<_$StoredDocumentImpl> get copyWith =>
      __$$StoredDocumentImplCopyWithImpl<_$StoredDocumentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoredDocumentImplToJson(
      this,
    );
  }
}

abstract class _StoredDocument implements StoredDocument {
  const factory _StoredDocument(
      {required final DocumentType type,
      required final String filePath,
      required final String fileName,
      required final DateTime uploadedAt}) = _$StoredDocumentImpl;

  factory _StoredDocument.fromJson(Map<String, dynamic> json) =
      _$StoredDocumentImpl.fromJson;

  @override
  DocumentType get type;
  @override
  String get filePath;
  @override
  String get fileName;
  @override
  DateTime get uploadedAt;

  /// Create a copy of StoredDocument
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoredDocumentImplCopyWith<_$StoredDocumentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
