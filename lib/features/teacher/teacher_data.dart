import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// DEMO teacher data — deterministically generated, no login, no real records.
/// This models a class of students with per-subject progress so the Teacher
/// Dashboard can show classes, student lists, weak areas and performance.

class TeacherSubjectPerf {
  const TeacherSubjectPerf(this.code, this.name, this.percent);
  final String code;
  final String name;
  final int percent;
}

class ClassStudentData {
  const ClassStudentData({
    required this.name,
    required this.subjects,
  });
  final String name;
  final List<TeacherSubjectPerf> subjects;

  int get average => subjects.isEmpty
      ? 0
      : (subjects.fold<int>(0, (a, b) => a + b.percent) / subjects.length)
          .round();

  /// The weakest subject (lowest percent), used for "needs support".
  TeacherSubjectPerf? get weakest {
    if (subjects.isEmpty) return null;
    return subjects.reduce((a, b) => a.percent <= b.percent ? a : b);
  }

  bool get needsSupport => (weakest?.percent ?? 100) < 50;
}

class TeacherClassData {
  const TeacherClassData({
    required this.id,
    required this.name,
    required this.grade,
    required this.students,
  });
  final int id;
  final String name;
  final int grade;
  final List<ClassStudentData> students;

  int get averageProgress => students.isEmpty
      ? 0
      : (students.fold<int>(0, (a, b) => a + b.average) / students.length)
          .round();

  List<ClassStudentData> get needingSupport =>
      students.where((s) => s.needsSupport).toList()
        ..sort((a, b) => (a.weakest?.percent ?? 0)
            .compareTo(b.weakest?.percent ?? 0));

  /// Average percent per subject across the class.
  List<TeacherSubjectPerf> get subjectAverages {
    if (students.isEmpty) return [];
    final byCode = <String, List<TeacherSubjectPerf>>{};
    for (final s in students) {
      for (final p in s.subjects) {
        byCode.putIfAbsent(p.code, () => []).add(p);
      }
    }
    return byCode.entries.map((e) {
      final avg =
          (e.value.fold<int>(0, (a, b) => a + b.percent) / e.value.length)
              .round();
      return TeacherSubjectPerf(e.key, e.value.first.name, avg);
    }).toList()
      ..sort((a, b) => a.percent.compareTo(b.percent));
  }
}

const _demoNames = [
  'Ahmed', 'Ali', 'Sara', 'Bilal', 'Hina', 'Usman', 'Zoya', 'Kamran',
  'Noor', 'Fahad', 'Ayesha', 'Hamza', 'Maryam', 'Saad', 'Iqra', 'Rehan',
  'Sana', 'Tariq', 'Laila', 'Danish', 'Areeba', 'Zain', 'Nida', 'Yousaf',
  'Mahnoor', 'Faizan', 'Rabia', 'Shan', 'Amna', 'Waleed', 'Hooria', 'Junaid',
];

const _demoSubjects = [
  ('math', 'Mathematics'),
  ('science', 'Science'),
  ('english', 'English'),
  ('urdu', 'Urdu'),
];

/// Builds a deterministic demo class (same output every run).
TeacherClassData buildDemoClass({int id = 5, int grade = 5}) {
  final rng = Random(id * 100 + grade);
  final students = <ClassStudentData>[];
  for (final name in _demoNames) {
    final subjects = _demoSubjects
        .map((s) => TeacherSubjectPerf(
            s.$1, s.$2, 30 + rng.nextInt(65))) // 30..94
        .toList();
    students.add(ClassStudentData(name: name, subjects: subjects));
  }
  return TeacherClassData(
    id: id,
    name: 'Class $grade',
    grade: grade,
    students: students,
  );
}

/// The demo classes a teacher sees.
final teacherClassesProvider = Provider<List<TeacherClassData>>((ref) {
  return [
    buildDemoClass(id: 5, grade: 5),
    buildDemoClass(id: 4, grade: 4),
  ];
});

final teacherClassProvider =
    Provider.family<TeacherClassData?, int>((ref, id) {
  final classes = ref.watch(teacherClassesProvider);
  for (final c in classes) {
    if (c.id == id) return c;
  }
  return null;
});
