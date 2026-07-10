import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parse;

import '../../domain/entities/master.dart';
import '../../domain/entities/master_enums.dart';
import '../parsing/master_field_extractor.dart';
import 'master_remote_data_source.dart';

/// Scrapes the listing table at orientation-chabab.com/master.
///
/// Verified markup (fetched directly, not guessed): each announcement is a
/// `table.annonce_table` containing `img.annonce_image` (logo),
/// `h2.annonce_titre > a.annonce_link` (title + detail link),
/// `div.date_left` (posted date, `DD-MM-YYYY`) and
/// `p.annonce_description > strong` (short description). The listing page
/// has no pagination — everything is on one page.
class OrientationChababDataSource
    implements MasterRemoteDataSource, MasterDetailEnricher {
  OrientationChababDataSource(this._dio, this._extractor);

  final Dio _dio;
  final MasterFieldExtractor _extractor;

  static const String _baseUrl = 'https://orientation-chabab.com';
  static const String _listingUrl = '$_baseUrl/master';

  @override
  MasterSource get source => MasterSource.orientationChabab;

  @override
  Future<List<Master>> fetchListings() async {
    final response = await _dio.get<String>(
      _listingUrl,
      options: Options(responseType: ResponseType.plain),
    );
    final document = parse(response.data ?? '');
    final tables = document.querySelectorAll('table.annonce_table');

    final now = DateTime.now();
    final results = <Master>[];

    for (final table in tables) {
      final titleAnchor = table.querySelector('h2.annonce_titre a.annonce_link');
      if (titleAnchor == null) continue;

      final title = titleAnchor.text.trim();
      if (title.isEmpty) continue;

      final href = titleAnchor.attributes['href'] ?? '';
      final detailUrl = href.startsWith('http') ? href : '$_baseUrl$href';
      final slug = Uri.tryParse(href)?.pathSegments.lastOrNullWhereNotEmpty ?? title;
      final id = 'chabab:$slug';

      final description =
          table.querySelector('p.annonce_description strong')?.text.trim() ??
              table.querySelector('p.annonce_description')?.text.trim() ??
              '';

      final image = table.querySelector('img.annonce_image')?.attributes['src'];

      final postedDate = _parsePostedDate(
        table.querySelector('div.date_left')?.text.trim() ?? '',
      );

      final fields = _extractor.extract(title, description);

      results.add(Master(
        id: id,
        title: title,
        university: fields.university,
        faculty: fields.faculty,
        city: fields.city,
        specialization: fields.specialization,
        description: description,
        requiredDegree: fields.requiredDegree,
        registrationLink: detailUrl,
        image: image,
        source: source,
        needsReview: !fields.confident,
        createdAt: postedDate ?? now,
        updatedAt: now,
      ));
    }

    return results;
  }

  @override
  Future<Master> enrich(Master master) async {
    final link = master.registrationLink;
    if (link == null || !link.startsWith(_baseUrl)) return master;

    final response = await _dio.get<String>(
      link,
      options: Options(responseType: ResponseType.plain),
    );
    final document = parse(response.data ?? '');
    final article = document.querySelector('article');
    if (article == null) return master;

    final bodyText = article.text;
    final deadline = master.applicationDeadline ?? _extractor.extractDeadline(bodyText);

    final pdfHref = article
        .querySelectorAll('a')
        .map((a) => a.attributes['href'])
        .firstWhere((h) => h != null && h.toLowerCase().endsWith('.pdf'), orElse: () => null);

    final externalLink = article.querySelectorAll('a').map((a) => a.attributes['href']).firstWhere(
          (h) => h != null && h.startsWith('http') && !h.contains('orientation-chabab.com'),
          orElse: () => null,
        );

    final requiredDocs = _extractRequiredDocuments(bodyText);

    return master.copyWith(
      description: bodyText.trim().isNotEmpty ? bodyText.trim() : master.description,
      applicationDeadline: deadline,
      pdfLink: pdfHref ?? master.pdfLink,
      registrationLink: externalLink ?? master.registrationLink,
      requiredDocuments: requiredDocs.isNotEmpty ? requiredDocs : master.requiredDocuments,
      needsReview: master.needsReview && deadline == null,
      updatedAt: DateTime.now(),
    );
  }

  List<String> _extractRequiredDocuments(String text) {
    const catalog = {
      'CV': ['cv', 'curriculum vitae'],
      'Diploma': ['diplôme', 'diplome'],
      'Transcript': ['relevé de notes', 'releve de notes'],
      'Motivation Letter': ['lettre de motivation'],
      'National ID': ["carte d'identité", "carte nationale", 'cni'],
      'Passport Photo': ['photo'],
      'Birth Certificate': ['acte de naissance'],
    };
    final lower = text.toLowerCase();
    return [
      for (final entry in catalog.entries)
        if (entry.value.any(lower.contains)) entry.key,
    ];
  }

  DateTime? _parsePostedDate(String raw) {
    final match = RegExp(r'(\d{1,2})-(\d{1,2})-(\d{4})').firstMatch(raw);
    if (match == null) return null;
    final day = int.tryParse(match.group(1)!);
    final month = int.tryParse(match.group(2)!);
    final year = int.tryParse(match.group(3)!);
    if (day == null || month == null || year == null) return null;
    try {
      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }
}

extension _LastOrNull on List<String> {
  String? get lastOrNullWhereNotEmpty {
    for (var i = length - 1; i >= 0; i--) {
      if (this[i].trim().isNotEmpty) return this[i];
    }
    return null;
  }
}
