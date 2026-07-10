import 'package:freezed_annotation/freezed_annotation.dart';

import 'master_enums.dart';

part 'master.freezed.dart';
part 'master.g.dart';

/// A single Master's program announcement. Doubles as both the domain
/// entity and the wire/cache model — see `data/datasources` for where the
/// fields are actually populated (scraped + heuristically enriched) and
/// `data/repositories` for how remote results are merged with the local
/// Hive cache.
@freezed
class Master with _$Master {
  const factory Master({
    required String id,
    required String title,
    String? university,
    String? faculty,
    String? city,
    /// Category id matching `assets/data/specializations.json` (e.g. "ai",
    /// "management"). Null when the heuristic extractor couldn't classify it.
    String? specialization,
    required String description,
    DateTime? applicationStart,
    DateTime? applicationDeadline,
    String? requiredDegree,
    @Default(<String>[]) List<String> requiredDocuments,
    String? registrationLink,
    String? pdfLink,
    String? image,
    required MasterSource source,
    /// True when the heuristic field extractor had low confidence — the UI
    /// surfaces this so a user (or a future admin dashboard) knows the
    /// record may need a manual fix rather than silently trusting it.
    @Default(false) bool needsReview,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Master;

  const Master._();

  factory Master.fromJson(Map<String, dynamic> json) => _$MasterFromJson(json);

  MasterListingStatus get status {
    final deadline = applicationDeadline;
    if (deadline == null) return MasterListingStatus.open;
    final daysLeft = deadline.difference(DateTime.now()).inHours / 24;
    if (daysLeft < 0) return MasterListingStatus.closed;
    if (daysLeft <= 7) return MasterListingStatus.closingSoon;
    return MasterListingStatus.open;
  }

  int? get daysUntilDeadline {
    final deadline = applicationDeadline;
    if (deadline == null) return null;
    final today = DateTime.now();
    final todayMidnight = DateTime(today.year, today.month, today.day);
    final deadlineMidnight = DateTime(deadline.year, deadline.month, deadline.day);
    return deadlineMidnight.difference(todayMidnight).inDays;
  }
}
