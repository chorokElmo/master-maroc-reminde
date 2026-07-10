import 'package:freezed_annotation/freezed_annotation.dart';

import 'application_status.dart';

part 'application_progress.freezed.dart';
part 'application_progress.g.dart';

@freezed
class ApplicationProgress with _$ApplicationProgress {
  const factory ApplicationProgress({
    required String masterId,
    required ApplicationStatus status,
    String? notes,
    required DateTime updatedAt,
  }) = _ApplicationProgress;

  factory ApplicationProgress.fromJson(Map<String, dynamic> json) =>
      _$ApplicationProgressFromJson(json);
}
