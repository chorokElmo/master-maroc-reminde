import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parse;

import '../../domain/entities/master.dart';
import '../../domain/entities/master_enums.dart';
import '../parsing/master_field_extractor.dart';
import 'master_remote_data_source.dart';

/// Scrapes the Blogger-powered homepage at almaster-maroc.com.
///
/// Verified markup: each post is an `article.post-amp` containing a
/// `script[type="application/ld+json"]` with a full schema.org
/// `BlogPosting` object (headline, description, datePublished,
/// mainEntityOfPage.@id, image.url) plus a `span.postcat` short
/// institution tag in the DOM. The JSON-LD is far more robust to parse
/// than the surrounding HTML, so it's the primary source of truth here.
class AlmasterMarocDataSource implements MasterRemoteDataSource {
  AlmasterMarocDataSource(this._dio, this._extractor);

  final Dio _dio;
  final MasterFieldExtractor _extractor;

  static const String _listingUrl = 'https://www.almaster-maroc.com/';

  @override
  MasterSource get source => MasterSource.almasterMaroc;

  @override
  Future<List<Master>> fetchListings() async {
    final response = await _dio.get<String>(
      _listingUrl,
      options: Options(responseType: ResponseType.plain),
    );
    final document = parse(response.data ?? '');
    final articles = document.querySelectorAll('article.post-amp');

    final now = DateTime.now();
    final results = <Master>[];

    for (final article in articles) {
      final ldJsonScript =
          article.querySelector('script[type="application/ld+json"]')?.text;
      if (ldJsonScript == null || ldJsonScript.trim().isEmpty) continue;

      Map<String, dynamic> data;
      try {
        data = jsonDecode(ldJsonScript) as Map<String, dynamic>;
      } catch (_) {
        continue;
      }

      final title = (data['headline'] as String?)?.trim() ?? '';
      if (title.isEmpty) continue;

      final description = (data['description'] as String?)?.trim() ?? '';
      final detailUrl = (data['mainEntityOfPage']
              as Map<String, dynamic>?)?['@id'] as String? ??
          article.querySelector('a.Title')?.attributes['href'] ?? '';
      final image = (data['image'] as Map<String, dynamic>?)?['url'] as String?;
      final publishedRaw = data['datePublished'] as String?;
      final publishedAt = publishedRaw != null
          ? DateTime.tryParse(publishedRaw)
          : null;

      final category = article.querySelector('span.postcat')?.text.trim();

      final slug = Uri.tryParse(detailUrl)?.pathSegments.lastOrNull ?? title;
      final id = 'almaster:$slug';

      final fields = _extractor.extract(title, '$category $description');

      results.add(Master(
        id: id,
        title: title,
        university: fields.university,
        faculty: fields.faculty ?? category,
        city: fields.city,
        specialization: fields.specialization,
        description: description,
        requiredDegree: fields.requiredDegree,
        registrationLink: detailUrl.isNotEmpty ? detailUrl : null,
        image: image,
        source: source,
        needsReview: !fields.confident,
        createdAt: publishedAt ?? now,
        updatedAt: now,
      ));
    }

    return results;
  }
}

extension _LastOrNull on List<String> {
  String? get lastOrNull => isEmpty ? null : last;
}
