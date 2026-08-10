import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/ai_tutor/ai_tutor_screen.dart';
import '../../features/favorites/favorites_screen.dart';
import '../../features/home/app_shell.dart';
import '../../features/home/home_screen.dart';
import '../../features/language/language_screen.dart';
import '../../features/lesson/lesson_screen.dart';
import '../../features/offline/offline_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/profile/edit_profile_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/progress/progress_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/quiz/quiz_hub_screen.dart';
import '../../features/quiz/quiz_result_screen.dart';
import '../../features/quiz/quiz_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/setup/setup_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/subjects/subject_detail_screen.dart';
import '../../features/subjects/subjects_screen.dart';
import '../../features/teacher/teacher_screen.dart';
import '../../shared/providers/app_settings.dart';
import 'routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Bridges Riverpod settings changes to GoRouter's [refreshListenable] so the
/// redirect re-runs when onboarding/profile state changes.
class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(Ref ref) {
    ref.listen(
      settingsControllerProvider
          .select((s) => (s.onboardingComplete, s.hasProfile)),
      (_, _) => notifyListeners(),
    );
  }
}

int? _idParam(GoRouterState state) => int.tryParse(state.pathParameters['id'] ?? '');

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefresh(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.splash,
    refreshListenable: refresh,
    redirect: (context, state) {
      final settings = ref.read(settingsControllerProvider);
      final loc = state.matchedLocation;

      if (loc == Routes.splash) return null;

      if (!settings.onboardingComplete) {
        if (loc == Routes.onboarding || loc == Routes.language) return null;
        return Routes.onboarding;
      }
      if (!settings.hasProfile) {
        if (loc == Routes.setup || loc == Routes.language) return null;
        return Routes.setup;
      }
      // Fully set up: keep the user out of the first-run-only screens.
      if (loc == Routes.onboarding || loc == Routes.setup) {
        return Routes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.language,
        builder: (context, state) => LanguageScreen(
          fromSettings: state.uri.queryParameters['from'] == 'settings',
        ),
      ),
      GoRoute(
        path: Routes.setup,
        builder: (context, state) => const SetupScreen(),
      ),

      // Full-screen routes above the bottom-nav shell.
      GoRoute(
        path: '${Routes.subject}/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            SubjectDetailScreen(subjectId: _idParam(state) ?? 0),
      ),
      GoRoute(
        path: '${Routes.lesson}/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            LessonScreen(lessonId: _idParam(state) ?? 0),
      ),
      GoRoute(
        path: '${Routes.quiz}/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            QuizScreen(lessonId: _idParam(state) ?? 0),
      ),
      GoRoute(
        path: '${Routes.quizResult}/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            QuizResultScreen(attemptId: _idParam(state) ?? 0),
      ),
      GoRoute(
        path: Routes.aiTutor,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => AiTutorScreen(
          lessonId: int.tryParse(state.uri.queryParameters['lessonId'] ?? ''),
        ),
      ),
      GoRoute(
        path: Routes.offline,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OfflineScreen(),
      ),
      GoRoute(
        path: Routes.settings,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: Routes.teacher,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const TeacherScreen(),
      ),
      GoRoute(
        path: Routes.favorites,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: Routes.search,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: Routes.editProfile,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const EditProfileScreen(),
      ),

      // Bottom-navigation shell with five branches.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.subjects,
              builder: (context, state) => const SubjectsScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.quiz,
              builder: (context, state) => const QuizHubScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.progress,
              builder: (context, state) => const ProgressScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.profile,
              builder: (context, state) => const ProfileScreen(),
            ),
          ]),
        ],
      ),
    ],
  );
});
