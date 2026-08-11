/// Centralised route path + name constants used across the app.
abstract final class Routes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const language = '/language';
  static const setup = '/setup';
  static const home = '/home';
  static const subjects = '/subjects';
  static const subject = '/subject'; // /subject/:id
  static const lesson = '/lesson'; // /lesson/:id
  static const quiz = '/quiz'; // /quiz/:id  (lessonId)
  static const quizResult = '/quiz-result'; // /quiz-result/:id (attemptId)
  static const aiTutor = '/ai-tutor';
  static const offline = '/offline';
  static const progress = '/progress';
  static const profile = '/profile';
  static const editProfile = '/profile/edit';
  static const settings = '/settings';
  static const teacher = '/teacher';
  static const favorites = '/favorites';
  static const search = '/search';
  static const report = '/report';
  static const achievements = '/achievements';
  static const teacherClass = '/teacher/class'; // /teacher/class/:id
  static const teacherStudent = '/teacher/student'; // /teacher/student/:id

  static String teacherClassPath(int id) => '$teacherClass/$id';
  static String teacherStudentPath(int classId, int index) =>
      '$teacherStudent/$classId?i=$index';

  static String subjectPath(int id) => '$subject/$id';
  static String lessonPath(int id) => '$lesson/$id';
  static String aiTutorPath({int? lessonId}) =>
      lessonId == null ? aiTutor : '$aiTutor?lessonId=$lessonId';
  static String quizPath(int lessonId) => '$quiz/$lessonId';
  static String quizResultPath(int attemptId) => '$quizResult/$attemptId';
}
