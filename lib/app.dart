import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kimgane/core/theme/app_theme.dart';
import 'package:kimgane/data/models/enums.dart';
import 'package:kimgane/presentation/viewmodels/app_view_models.dart';
import 'package:kimgane/presentation/views/calendar/calendar_view.dart';
import 'package:kimgane/presentation/views/clan/clan_intro_view.dart';
import 'package:kimgane/presentation/views/events/event_detail_view.dart';
import 'package:kimgane/presentation/views/events/event_form_view.dart';
import 'package:kimgane/presentation/views/events/event_list_view.dart';
import 'package:kimgane/presentation/views/home/home_view.dart';
import 'package:kimgane/presentation/views/jibang/jibang_editor_view.dart';
import 'package:kimgane/presentation/views/jibang/jibang_preview_view.dart';
import 'package:kimgane/presentation/views/members/member_form_view.dart';
import 'package:kimgane/presentation/views/members/member_list_view.dart';
import 'package:kimgane/presentation/views/offering/offering_guide_view.dart';
import 'package:kimgane/presentation/views/rite/rite_hub_view.dart';
import 'package:kimgane/presentation/views/settings/settings_view.dart';
import 'package:kimgane/presentation/views/shell/app_shell.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter() {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/', builder: (context, state) => const HomeView()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/calendar',
                builder: (context, state) => const CalendarView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/events',
                builder: (context, state) => const EventListView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/rite',
                builder: (context, state) => const RiteHubView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/family',
                builder: (context, state) => const MemberListView(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/events/new',
        builder: (context, state) =>
            EventFormView(initialType: state.extra as EventType?),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/events/:id',
        builder: (context, state) =>
            EventDetailView(id: state.pathParameters['id']!),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/events/:id/edit',
        builder: (context, state) =>
            EventFormView(eventId: state.pathParameters['id']),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/members/new',
        builder: (context, state) => const MemberFormView(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/members/:id/edit',
        builder: (context, state) =>
            MemberFormView(memberId: state.pathParameters['id']),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/jibang',
        builder: (context, state) {
          final extra = state.extra;
          return JibangEditorView(
            preselectedIds: extra is List<String> ? extra : null,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/jibang/preview',
        builder: (context, state) => const JibangPreviewView(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/clan',
        builder: (context, state) => const ClanIntroView(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/clan/photo/:id',
        builder: (context, state) =>
            ClanPhotoView(sectionId: state.pathParameters['id']!),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/offering',
        builder: (context, state) => const OfferingGuideView(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/offering/photo',
        builder: (context, state) => const OfferingPhotoView(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/settings',
        builder: (context, state) => const SettingsView(),
      ),
    ],
  );
}

class KimganeApp extends StatelessWidget {
  KimganeApp({super.key, GoRouter? router})
    : _router = router ?? createRouter();

  final GoRouter _router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '김가네',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: const Locale('ko', 'KR'),
      supportedLocales: const [Locale('ko', 'KR'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: _router,
      builder: (context, child) {
        return _NotificationSync(child: child ?? const SizedBox.shrink());
      },
    );
  }
}

class _NotificationSync extends ConsumerStatefulWidget {
  const _NotificationSync({required this.child});

  final Widget child;

  @override
  ConsumerState<_NotificationSync> createState() => _NotificationSyncState();
}

class _NotificationSyncState extends ConsumerState<_NotificationSync> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _sync());
  }

  Future<void> _sync() async {
    await ref
        .read(eventNotificationServiceProvider)
        .sync(
          events: ref.read(eventsViewModelProvider),
          settings: ref.read(settingsViewModelProvider),
          occurrences: ref.read(occurrenceServiceProvider),
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(eventsViewModelProvider, (_, _) => _sync());
    ref.listen(settingsViewModelProvider, (_, _) => _sync());
    final textScale = ref.watch(
      settingsViewModelProvider.select((s) => s.textScale),
    );
    return MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(textScale)),
      child: widget.child,
    );
  }
}
