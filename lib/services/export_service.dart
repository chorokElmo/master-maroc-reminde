import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../core/utils/date_utils.dart';
import '../features/masters/domain/entities/master.dart';

/// Generates shareable PDF reports and `.ics` calendar files for the
/// student's saved Masters.
class ExportService {
  Future<File> exportSavedToPdf(List<Master> masters) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (context) => pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 12),
          child: pw.Text(
            'Master Maroc Reminder — Saved Programs',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
        ),
        build: (context) => [
          pw.TableHelper.fromTextArray(
            headers: ['Title', 'University / School', 'City', 'Deadline', 'Status'],
            data: masters.map((m) {
              return [
                m.title,
                m.university ?? m.faculty ?? '—',
                m.city ?? '—',
                m.applicationDeadline != null
                    ? AppDateUtils.formatDate(m.applicationDeadline!)
                    : '—',
                m.status.name,
              ];
            }).toList(),
            cellAlignment: pw.Alignment.centerLeft,
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          ),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/saved_masters_${_stamp()}.pdf');
    await file.writeAsBytes(await doc.save());
    return file;
  }

  /// Minimal, valid RFC 5545 `.ics` export — one VEVENT per saved Master
  /// with a deadline, importable into any calendar app.
  Future<File> exportSavedToIcs(List<Master> masters) async {
    final buffer = StringBuffer()
      ..writeln('BEGIN:VCALENDAR')
      ..writeln('VERSION:2.0')
      ..writeln('PRODID:-//Master Maroc Reminder//EN');

    for (final m in masters) {
      final deadline = m.applicationDeadline;
      if (deadline == null) continue;

      buffer
        ..writeln('BEGIN:VEVENT')
        ..writeln('UID:${m.id}@mastermarocreminder')
        ..writeln('DTSTAMP:${_icsDate(DateTime.now())}')
        ..writeln('DTSTART;VALUE=DATE:${_icsDateOnly(deadline)}')
        ..writeln('SUMMARY:${_escapeIcs(m.title)} — Application deadline')
        ..writeln('DESCRIPTION:${_escapeIcs(m.university ?? m.faculty ?? '')}')
        ..writeln('END:VEVENT');
    }

    buffer.writeln('END:VCALENDAR');

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/master_deadlines_${_stamp()}.ics');
    await file.writeAsString(buffer.toString());
    return file;
  }

  Future<void> shareFile(File file, {String? text}) async {
    await Share.shareXFiles([XFile(file.path)], text: text);
  }

  String _icsDate(DateTime date) {
    final utc = date.toUtc();
    return '${_icsDateOnly(utc)}T${_two(utc.hour)}${_two(utc.minute)}${_two(utc.second)}Z';
  }

  String _icsDateOnly(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}${_two(date.month)}${_two(date.day)}';

  String _two(int value) => value.toString().padLeft(2, '0');

  String _escapeIcs(String text) =>
      text.replaceAll(',', r'\,').replaceAll(';', r'\;').replaceAll('\n', r'\n');

  String _stamp() => DateTime.now().toIso8601String().replaceAll(':', '-');
}
