import 'package:drift/drift.dart' show Value;

import '../database/app_database.dart';

/// A learner identity.
///
/// PRIVACY: a student account stores only what teaching needs — id, name,
/// grade, language, and *optional* school/class. The app deliberately never
/// collects CNIC, home address, GPS location, phone number or family details.
/// The default experience is a **guest, offline** account requiring no sign-up.
class StudentAccount {
  const StudentAccount({
    required this.id,
    required this.name,
    required this.grade,
    required this.languageCode,
    this.school,
    this.className,
    this.isGuest = true,
  });

  final int id;
  final String name;
  final int grade;
  final String languageCode;
  final String? school;
  final String? className;
  final bool isGuest;

  factory StudentAccount.fromRow(Student s) => StudentAccount(
        id: s.id,
        name: s.name,
        grade: s.grade,
        languageCode: s.languageCode,
        school: s.school,
        className: s.className,
        isGuest: true,
      );
}

/// A teacher identity for the teacher dashboard and (future) school mode.
///
/// PRIVACY: only professional/organisational fields — id, name, school,
/// district and the classes they teach. No personal identifiers.
class TeacherAccount {
  const TeacherAccount({
    required this.id,
    required this.name,
    required this.school,
    required this.district,
    this.classIds = const [],
  });

  final String id;
  final String name;
  final String school;
  final String district;
  final List<int> classIds;
}

/// Authentication abstraction.
///
/// Today only a mock is provided ([MockAuthService]) so the app works offline
/// with no server. The interface is intentionally shaped for a future secure
/// implementation (token-based teacher sign-in backed by your server) — screens
/// depend only on this interface, so swapping in real auth needs no UI changes.
abstract class AuthService {
  /// The signed-in teacher, if any.
  TeacherAccount? get currentTeacher;

  /// Signs a teacher in. In the mock this validates against demo credentials;
  /// a real implementation would exchange credentials for a token server-side.
  Future<TeacherAccount?> signInTeacher({
    required String username,
    required String password,
  });

  Future<void> signOutTeacher();
}

/// Offline mock authentication. Accepts a single demo teacher and never talks
/// to a network. Credentials are demo-only and are **not** real secrets.
class MockAuthService implements AuthService {
  MockAuthService();

  // Demo-only credentials for the offline teacher dashboard. Not a real secret;
  // a production build authenticates against a secure backend instead.
  static const String demoUsername = 'teacher';
  static const String demoPassword = 'demo';

  static const TeacherAccount demoTeacher = TeacherAccount(
    id: 'teacher-demo',
    name: 'Demo Teacher',
    school: 'Government Primary School',
    district: 'Peshawar',
    classIds: [1, 2, 3, 4, 5, 6, 7, 8],
  );

  TeacherAccount? _current;

  @override
  TeacherAccount? get currentTeacher => _current;

  @override
  Future<TeacherAccount?> signInTeacher({
    required String username,
    required String password,
  }) async {
    if (username.trim() == demoUsername && password == demoPassword) {
      _current = demoTeacher;
      return _current;
    }
    return null;
  }

  @override
  Future<void> signOutTeacher() async {
    _current = null;
  }
}

/// Manages the on-device student account. Guest-offline by default: a student
/// can start learning immediately without any account. School/class are
/// optional and can be added later.
class AccountService {
  AccountService(this.db);
  final AppDatabase db;

  Future<StudentAccount?> currentStudent() async {
    final row = await db.currentStudent();
    return row == null ? null : StudentAccount.fromRow(row);
  }

  /// Creates a guest (offline) student account. Only optional school/class are
  /// accepted beyond the basics; nothing personal is collected.
  Future<StudentAccount> createGuestStudent({
    required String name,
    required int grade,
    required String languageCode,
    String? school,
    String? className,
  }) async {
    final id = await db.createStudent(
      name: name,
      grade: grade,
      languageCode: languageCode,
      school: school,
      className: className,
    );
    return StudentAccount(
      id: id,
      name: name,
      grade: grade,
      languageCode: languageCode,
      school: school,
      className: className,
      isGuest: true,
    );
  }

  /// Updates the optional school/class labels on the current student.
  Future<void> setSchoolAndClass({
    String? school,
    String? className,
  }) async {
    final s = await db.currentStudent();
    if (s == null) return;
    await db.updateStudent(s.copyWith(
      school: Value(school),
      className: Value(className),
    ));
  }
}
