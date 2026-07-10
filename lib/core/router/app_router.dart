import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/calendar/presentation/screens/calendar_screen.dart';
import '../../features/documents/presentation/screens/document_manager_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/masters/presentation/screens/explore_screen.dart';
import '../../features/masters/presentation/screens/home_screen.dart';
import '../../features/masters/presentation/screens/master_detail_screen.dart';
import '../../features/masters/presentation/screens/search_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/providers/settings_providers.dart';
import '../../features/settings/presentation/screens/privacy_policy_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/tracker/presentation/screens/application_tracker_screen.dart';
import '../widgets/main_shell.dart';

class AppRoutes {
  AppRoutes._();

  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const explore = '/explore';
  static const calendar = '/calendar';
  static const saved = '/saved';
  static const profile = '/profile';
  static const search = '/search';
  static const documents = '/documents';
  static const tracker = '/tracker';
  static const settings = '/settings';
  static const privacyPolicy = '/settings/privacy';
  static const auth = '/auth';
  static const masterDetail = '/master/:id';

  static String masterDetailPath(String id) => '/master/$id';
}

class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen(onboardingCompleteProvider, (_, __) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _RouterRefreshNotifier(ref);
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final loc = state.matchedLocation;
      if (loc == AppRoutes.splash) return null;

      final onboardingDone = ref.read(onboardingCompleteProvider);
      if (!onboardingDone && loc != AppRoutes.onboarding) {
        return AppRoutes.onboarding;
      }
      if (onboardingDone && loc == AppRoutes.onboarding) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: AppRoutes.onboarding, builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: AppRoutes.search, builder: (context, state) => const SearchScreen()),
      GoRoute(path: AppRoutes.documents, builder: (context, state) => const DocumentManagerScreen()),
      GoRoute(path: AppRoutes.tracker, builder: (context, state) => const ApplicationTrackerScreen()),
      GoRoute(path: AppRoutes.settings, builder: (context, state) => const SettingsScreen()),
      GoRoute(
        path: AppRoutes.privacyPolicy,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(path: AppRoutes.auth, builder: (context, state) => const AuthScreen()),
      GoRoute(
        path: AppRoutes.masterDetail,
        builder: (context, state) => MasterDetailScreen(masterId: state.pathParameters['id']!),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.home, builder: (context, state) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.explore, builder: (context, state) => const ExploreScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.calendar, builder: (context, state) => const CalendarScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.saved, builder: (context, state) => const FavoritesScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.profile, builder: (context, state) => const ProfileScreen()),
          ]),
        ],
      ),
    ],
  );
});
