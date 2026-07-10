import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class SpecializationRef {
  const SpecializationRef(this.id, this.label, this.keywords);

  final String id;
  final String label;
  final List<String> keywords;
}

/// Loads the bundled Moroccan university/city/specialization reference
/// data (`assets/data/*.json`) once and exposes simple keyword-matching
/// helpers used by the heuristic field extractor to turn free-text
/// scraped titles/descriptions into structured `Master` fields.
///
/// This is real reference data (actual Moroccan public universities,
/// schools and cities) — not sample/placeholder content — but matching
/// free text against it is inherently best-effort, which is exactly why
/// [Master.needsReview] exists.
class AcademicReferenceData {
  AcademicReferenceData._();

  static final AcademicReferenceData instance = AcademicReferenceData._();

  List<String> _universityNames = [];
  Map<String, String> _schoolAcronymToCity = {};
  List<String> _cities = [];
  List<SpecializationRef> _specializations = [];

  bool _loaded = false;

  Future<void> load() async {
    if (_loaded) return;

    final universitiesRaw =
        await rootBundle.loadString('assets/data/moroccan_universities.json');
    final universitiesJson = jsonDecode(universitiesRaw) as Map<String, dynamic>;

    _universityNames = [
      for (final u in (universitiesJson['universities'] as List))
        (u as Map<String, dynamic>)['name'] as String,
    ];

    _schoolAcronymToCity = {
      for (final s in (universitiesJson['schools'] as List))
        (s as Map<String, dynamic>)['acronym'] as String: s['city'] as String? ?? '',
    };

    _cities = (universitiesJson['cities'] as List).cast<String>();

    final specializationsRaw =
        await rootBundle.loadString('assets/data/specializations.json');
    final specializationsJson =
        jsonDecode(specializationsRaw) as Map<String, dynamic>;

    _specializations = [
      for (final s in (specializationsJson['specializations'] as List))
        SpecializationRef(
          (s as Map<String, dynamic>)['id'] as String,
          s['label'] as String,
          (s['keywords'] as List).cast<String>(),
        ),
    ];

    _loaded = true;
  }

  List<String> get universityNames => _universityNames;
  Map<String, String> get schoolAcronyms => _schoolAcronymToCity;
  List<String> get cities => _cities;
  List<SpecializationRef> get specializations => _specializations;
}
