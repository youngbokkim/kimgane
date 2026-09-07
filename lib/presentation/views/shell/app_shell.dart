import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kimgane/core/theme/app_theme.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _go(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 840;
    final destinations = const [
      _Dest(icon: Icons.home_outlined, selected: Icons.home, label: '홈'),
      _Dest(
        icon: Icons.calendar_month_outlined,
        selected: Icons.calendar_month,
        label: '달력',
      ),
      _Dest(icon: Icons.event_note_outlined, selected: Icons.event_note, label: '일정'),
      _Dest(
        icon: Icons.auto_stories_outlined,
        selected: Icons.auto_stories,
        label: '제례',
      ),
      _Dest(icon: Icons.groups_outlined, selected: Icons.groups, label: '가족'),
    ];

    if (wide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _go,
              labelType: NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 24),
                child: Column(
                  children: [
                    const Text(
                      '金',
                      style: TextStyle(
                        fontFamily: 'NanumMyeongjo',
                        fontSize: 28,
                        color: AppColors.cinnabar,
                      ),
                    ),
                    Text(
                      '김가네',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              destinations: [
                for (final d in destinations)
                  NavigationRailDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selected),
                    label: Text(d.label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: navigationShell),
          ],
        ),
      );
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _go,
        destinations: [
          for (final d in destinations)
            NavigationDestination(
              icon: Icon(d.icon),
              selectedIcon: Icon(d.selected, color: AppColors.cinnabar),
              label: d.label,
            ),
        ],
      ),
    );
  }
}

class _Dest {
  const _Dest({
    required this.icon,
    required this.selected,
    required this.label,
  });

  final IconData icon;
  final IconData selected;
  final String label;
}
