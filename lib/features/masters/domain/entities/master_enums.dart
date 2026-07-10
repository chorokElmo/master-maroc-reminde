/// Computed from a Master's application window — never persisted, always
/// derived from `applicationDeadline` (and `applicationStart`) so it can't
/// drift out of sync with the actual dates.
enum MasterListingStatus {
  open,
  closingSoon,
  closed,
}

/// Which site a [Master] record was scraped from. Kept as an enum (rather
/// than a raw string) so the composite data source and UI badges stay
/// exhaustive-checked as new sources are added.
enum MasterSource {
  orientationChabab,
  almasterMaroc,
}

extension MasterSourceX on MasterSource {
  String get label => switch (this) {
        MasterSource.orientationChabab => 'orientation-chabab.com',
        MasterSource.almasterMaroc => 'almaster-maroc.com',
      };

  String get baseUrl => switch (this) {
        MasterSource.orientationChabab => 'https://orientation-chabab.com',
        MasterSource.almasterMaroc => 'https://www.almaster-maroc.com',
      };
}
