import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kimgane/core/theme/app_theme.dart';
import 'package:kimgane/core/utils/occurrence_service.dart';
import 'package:kimgane/data/models/enums.dart';
import 'package:kimgane/data/providers.dart';
import 'package:kimgane/presentation/viewmodels/app_view_models.dart';
import 'package:kimgane/presentation/widgets/event_type_badge.dart';
import 'package:kimgane/presentation/widgets/section_card.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcoming = ref.watch(upcomingProvider);
    final settings = ref.watch(settingsViewModelProvider);
    final lunar = ref.watch(lunarServiceProvider);
    final today = DateTime.now();
    final todayLunar = lunar.solarToLunar(today);
    final nextJesa = upcoming.where((e) => e.event.type == EventType.jesa).firstOrNull;
    final dateFmt = DateFormat('M월 d일 (E)', 'ko_KR');

    return Scaffold(
      appBar: AppBar(
        title: const Text('김가네'),
        actions: [
          IconButton(
            tooltip: '설정',
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7A1F1F), Color(0xFF2C3A4F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${settings.defaultBonGwan}${settings.defaultSurname}씨 · ${settings.hometown}',
                  style: const TextStyle(color: Color(0xFFE7DDC8), fontSize: 13),
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat('yyyy년 M월 d일', 'ko_KR').format(today),
                  style: const TextStyle(
                    fontFamily: 'NanumMyeongjo',
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lunar.formatLunar(todayLunar),
                  style: const TextStyle(color: Color(0xFFE7DDC8), fontSize: 15),
                ),
                if (nextJesa != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '다음 제례  ${nextJesa.event.title}  ·  D-${nextJesa.dDay == 0 ? 'Day' : nextJesa.dDay}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _Quick(
                  icon: Icons.add,
                  label: '일정 추가',
                  onTap: () => context.push('/events/new'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _Quick(
                  icon: Icons.edit_document,
                  label: '지방 · 축문',
                  onTap: () => context.push('/jibang'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _Quick(
                  icon: Icons.restaurant_menu,
                  label: '상차림',
                  onTap: () => context.push('/offering'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SectionCard(
            title: '광산김씨',
            subtitle: '의성 가족묘 · 선조 벼슬',
            onTap: () => context.push('/clan'),
            trailing: const Icon(Icons.chevron_right),
            child: const Text(
              '직계선조 묘비와 36대·37대 비석을 한글로 풀어 두었습니다.',
            ),
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: '다가오는 일정',
            subtitle: '양력 날짜 기준 · 제사는 음력 기일을 환산합니다',
            child: upcoming.isEmpty
                ? const Text('등록된 일정이 없습니다.')
                : Column(
                    children: [
                      for (final occ in upcoming.take(8))
                        _UpcomingTile(
                          occurrence: occ,
                          dateLabel: dateFmt.format(occ.solarDate),
                          onTap: () => context.push('/events/${occ.event.id}'),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _Quick extends StatelessWidget {
  const _Quick({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.hanjiCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.line),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: AppColors.cinnabar),
              const SizedBox(height: 6),
              Text(label, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}

class _UpcomingTile extends StatelessWidget {
  const _UpcomingTile({
    required this.occurrence,
    required this.dateLabel,
    required this.onTap,
  });

  final EventOccurrence occurrence;
  final String dateLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final event = occurrence.event;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      title: Text(event.title),
      subtitle: Text(
        [
          dateLabel,
          if (occurrence.lunar != null)
            '음력 ${occurrence.lunar!.month}.${occurrence.lunar!.day} (음)',
          if (occurrence.riteEvening != null)
            '제사 저녁(관행) ${DateFormat('M.d', 'ko_KR').format(occurrence.riteEvening!)}',
        ].join(' · '),
      ),
      trailing: EventTypeBadge(
        type: event.type,
        kindLabel: event.jesaKind?.label ?? event.gyeongjosaKind?.label,
      ),
    );
  }
}
