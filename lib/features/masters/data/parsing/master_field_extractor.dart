import 'academic_reference_data.dart';

/// Result of running the heuristic extractor over a scraped title +
/// description. Neither source site exposes university/city/specialization
/// as separate structured fields (both bury everything in free-text French
/// titles like "Inscription Master à l'ENSMR Rabat 2026-2027"), so this is
/// intentionally best-effort: [confident] tells the caller whether enough
/// fields were resolved to trust the record without a review flag.
class ExtractedFields {
  const ExtractedFields({
    this.university,
    this.city,
    this.faculty,
    this.specialization,
    this.requiredDegree,
  });

  final String? university;
  final String? city;
  final String? faculty;
  final String? specialization;
  final String? requiredDegree;

  bool get confident => city != null && (university != null || faculty != null);
}

/// Regex-and-keyword based field extraction, matched against the bundled
/// [AcademicReferenceData]. Deliberately simple (no NLP dependency) — French
/// announcement titles follow a handful of very consistent patterns
/// (`... à l'ÉCOLE VILLE ANNÉE`, `Master VILLE ANNÉE`), so plain
/// substring/regex matching against a real reference list gets most of the
/// way there, and [ExtractedFields.confident] flags the rest for review.
class MasterFieldExtractor {
  MasterFieldExtractor(this._reference);

  final AcademicReferenceData _reference;

  static final RegExp _degreePattern = RegExp(
    r"(Bac\s*\+\s*\d|Licence\s+[A-Za-zÀ-ÿ]+|Licence\b|Diplôme d'ingénieur|Master\b)",
    caseSensitive: false,
  );

  static final RegExp _dateNearKeyword = RegExp(
    r"(avant le|jusqu'au|jusqu au|date limite|clôture|clôtur\w*)\D{0,20}(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{2,4})",
    caseSensitive: false,
  );

  static final RegExp _genericDate = RegExp(r'(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{2,4})');

  ExtractedFields extract(String title, String description) {
    final haystack = '$title $description';
    final lower = haystack.toLowerCase();

    String? city;
    for (final c in _reference.cities) {
      if (lower.contains(c.toLowerCase())) {
        city = c;
        break;
      }
    }

    String? university;
    for (final u in _reference.universityNames) {
      if (lower.contains(u.toLowerCase())) {
        university = u;
        break;
      }
    }

    String? faculty;
    for (final entry in _reference.schoolAcronyms.entries) {
      final pattern = RegExp('\\b${RegExp.escape(entry.key)}\\b', caseSensitive: false);
      if (pattern.hasMatch(haystack)) {
        faculty = entry.key;
        city ??= entry.value.isNotEmpty ? entry.value : null;
        break;
      }
    }
    // Fallback: a bare 2-6 letter uppercase acronym not already matched
    // (e.g. "I2S", "ISSS") — kept as the faculty guess but doesn't count
    // toward [ExtractedFields.confident] on its own.
    faculty ??= RegExp(r'\b[A-Z][A-Z0-9]{1,5}\b').firstMatch(title)?.group(0);

    String? specialization;
    for (final spec in _reference.specializations) {
      if (spec.keywords.any((k) => lower.contains(k.toLowerCase()))) {
        specialization = spec.id;
        break;
      }
    }

    final degreeMatch = _degreePattern.firstMatch(haystack);

    return ExtractedFields(
      university: university,
      city: city,
      faculty: faculty,
      specialization: specialization,
      requiredDegree: degreeMatch?.group(0),
    );
  }

  /// Best-effort deadline extraction from a detail page's full body text.
  /// Prefers a date immediately following an explicit "date limite" style
  /// keyword; falls back to the last date-like token found in the text
  /// (announcements typically end with the closing date).
  DateTime? extractDeadline(String bodyText) {
    final keywordMatch = _dateNearKeyword.firstMatch(bodyText);
    if (keywordMatch != null) {
      return _parseDateGroups(
        keywordMatch.group(2)!,
        keywordMatch.group(3)!,
        keywordMatch.group(4)!,
      );
    }

    final allDates = _genericDate.allMatches(bodyText).toList();
    if (allDates.isEmpty) return null;
    final last = allDates.last;
    return _parseDateGroups(last.group(1)!, last.group(2)!, last.group(3)!);
  }

  DateTime? _parseDateGroups(String d, String m, String y) {
    final day = int.tryParse(d);
    final month = int.tryParse(m);
    var year = int.tryParse(y);
    if (day == null || month == null || year == null) return null;
    if (year < 100) year += 2000;
    if (month < 1 || month > 12 || day < 1 || day > 31) return null;
    try {
      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }
}
