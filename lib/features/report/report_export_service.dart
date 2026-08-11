import '../../data/models/view_models.dart';
import '../teacher/teacher_data.dart';

/// Generates teacher/student reports locally, with **no internet required**.
///
/// CSV is produced in-memory as a plain string (openable in any spreadsheet).
/// PDF export is defined as an interface ([ReportPdfExporter]) so a real
/// implementation (e.g. using the `pdf` package) can be dropped in later
/// without changing callers — the architecture is ready, kept out of the app
/// today to stay lightweight.
class ReportExportService {
  const ReportExportService({this.pdfExporter = const UnavailablePdfExporter()});

  final ReportPdfExporter pdfExporter;

  /// A single student's learning report as CSV. All values come from local
  /// data (progress + quizzes) — nothing leaves the device.
  String studentReportCsv(StudentReport report) {
    final rows = <List<String>>[
      ['Section', 'Item', 'Value'],
      ['Student', 'Name', report.student.name],
      ['Student', 'Grade', '${report.student.grade}'],
      ['Overall', 'Progress %', '${report.overallPercent}'],
      ['Overall', 'Lessons completed', '${report.lessonsCompleted}'],
      ['Overall', 'Total lessons', '${report.totalLessons}'],
      ['Overall', 'Quizzes taken', '${report.quizzesTaken}'],
      ['Overall', 'Quiz average %', '${report.quizAveragePercent}'],
    ];
    for (final s in report.subjects) {
      rows.add(['Subject', s.subject.nameEn, '${s.percent}']);
    }
    for (final a in report.recentActivity) {
      rows.add(['Activity', a.title, a.detail]);
    }
    return _toCsv(rows);
  }

  /// A whole class as CSV: one row per student with per-subject percentages
  /// and their average. Deterministic and offline.
  String classReportCsv(TeacherClassData data) {
    // Stable subject column order from the class-average list.
    final subjectCols = data.subjectAverages.map((s) => s.code).toList();
    final subjectNames = {
      for (final s in data.subjectAverages) s.code: s.name,
    };

    final header = <String>[
      'Student',
      for (final code in subjectCols) subjectNames[code] ?? code,
      'Average',
      'Needs support',
    ];
    final rows = <List<String>>[header];

    for (final student in data.students) {
      final byCode = {for (final p in student.subjects) p.code: p.percent};
      rows.add([
        student.name,
        for (final code in subjectCols) '${byCode[code] ?? 0}',
        '${student.average}',
        student.needsSupport ? 'Yes' : 'No',
      ]);
    }

    // Trailing class-average row.
    final avgByCode = {for (final s in data.subjectAverages) s.code: s.percent};
    rows.add([
      'Class average',
      for (final code in subjectCols) '${avgByCode[code] ?? 0}',
      '${data.averageProgress}',
      '',
    ]);

    return _toCsv(rows);
  }

  /// Exports a student report to PDF bytes via the configured exporter.
  /// Returns null when PDF export is not available in this build (CSV still
  /// works). Never throws for the unavailable case.
  Future<List<int>?> studentReportPdf(StudentReport report) {
    if (!pdfExporter.isAvailable) return Future.value(null);
    return pdfExporter.exportStudentReport(report);
  }

  /// RFC-4180-ish CSV encoding: quote fields containing comma, quote or
  /// newline, and double embedded quotes.
  String _toCsv(List<List<String>> rows) {
    final buffer = StringBuffer();
    for (final row in rows) {
      buffer.writeln(row.map(_escape).join(','));
    }
    return buffer.toString();
  }

  String _escape(String field) {
    final needsQuote =
        field.contains(',') || field.contains('"') || field.contains('\n');
    if (!needsQuote) return field;
    return '"${field.replaceAll('"', '""')}"';
  }
}

/// Interface for a future PDF exporter. A real implementation would render the
/// report to PDF bytes (e.g. with the `pdf` + `printing` packages) so teachers
/// can print or share offline.
abstract class ReportPdfExporter {
  bool get isAvailable;
  Future<List<int>?> exportStudentReport(StudentReport report);
}

/// Default: PDF export not wired in this build. CSV remains fully functional.
class UnavailablePdfExporter implements ReportPdfExporter {
  const UnavailablePdfExporter();
  @override
  bool get isAvailable => false;
  @override
  Future<List<int>?> exportStudentReport(StudentReport report) async => null;
}
