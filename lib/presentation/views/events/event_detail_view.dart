import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kimgane/core/theme/app_theme.dart';
import 'package:kimgane/data/models/enums.dart';
import 'package:kimgane/data/models/family_member.dart';
import 'package:kimgane/presentation/viewmodels/app_view_models.dart';
import 'package:kimgane/presentation/widgets/event_type_badge.dart';
import 'package:kimgane/presentation/widgets/section_card.dart';

class EventDetailView extends ConsumerWidget {
  const EventDetailView({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final event = ref.watch(eventsViewModelProvider.notifier).byId(id);
    if (event == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('일정')),
        body: const Center(child: Text('일정을 찾을 수 없습니다.')),
      );
    }
    final members = ref.watch(membersViewModelProvider);
    final occService = ref.watch(occurrenceServiceProvider);
    final thisYear = DateTime.now().year;
    final occ = occService.occurrenceForYear(event, thisYear);
    final dateFmt = DateFormat('yyyy년 M월 d일 (E)', 'ko_KR');
    FamilyMember? member;
    if (event.memberId != null) {
      member = members.where((m) => m.id == event.memberId).firstOrNull;
    }
    final ancestors = members
        .where((m) => event.ancestorIds.contains(m.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
        actions: [
          IconButton(
            onPressed: () => context.push('/events/${event.id}/edit'),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Row(
            children: [
              EventTypeBadge(
                type: event.type,
                kindLabel: event.jesaKind?.label ?? event.gyeongjosaKind?.label,
              ),
              const SizedBox(width: 8),
              Text(event.calendarKind.label),
              if (event.isLeapMonth) const Text(' · 윤달'),
              if (event.isRecurring) const Text(' · 매년'),
            ],
          ),
          const SizedBox(height: 16),
          SectionCard(
            title: '날짜',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${event.calendarKind.label} '
                  '${event.year == null ? '' : '${event.year}년 '}'
                  '${event.isLeapMonth ? '윤' : ''}${event.month}월 ${event.day}일',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (occ != null) ...[
                  const SizedBox(height: 8),
                  Text('올해 양력  ${dateFmt.format(occ.solarDate)}'),
                  if (occ.lunar != null)
                    Text(
                      '올해 음력  ${occ.lunar!.isLeapMonth ? '윤' : ''}${occ.lunar!.month}월 ${occ.lunar!.day}일',
                    ),
                  if (occ.riteEvening != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      '제사 저녁(의성 관행)  ${dateFmt.format(occ.riteEvening!)} 저녁\n'
                      '음력 기일 자시에 가깝게, 전날 저녁에 지내는 집이 많습니다.',
                      style: const TextStyle(color: AppColors.inkMuted),
                    ),
                  ],
                ],
              ],
            ),
          ),
          if (member != null) ...[
            const SizedBox(height: 12),
            SectionCard(
              title: '관련 가족',
              child: Text('${member.name} · ${member.kinship.label}'),
            ),
          ],
          if (event.type == EventType.jesa) ...[
            const SizedBox(height: 12),
            SectionCard(
              title: '지방 · 상차림',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (ancestors.isEmpty)
                    const Text('모실 조상을 일정에서 지정하면 지방을 바로 만들 수 있습니다.')
                  else
                    Text(ancestors.map((a) => a.name).join(' · ')),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilledButton.icon(
                        onPressed: () {
                          if (ancestors.isNotEmpty) {
                            ref
                                .read(jibangViewModelProvider.notifier)
                                .setSelected(ancestors.map((a) => a.id).toList());
                          }
                          context.push('/jibang');
                        },
                        icon: const Icon(Icons.edit_document),
                        label: const Text('지방 · 축문'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => context.push('/offering'),
                        icon: const Icon(Icons.restaurant_menu),
                        label: const Text('상차림 가이드'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          if (event.notes != null && event.notes!.isNotEmpty) ...[
            const SizedBox(height: 12),
            SectionCard(title: '메모', child: Text(event.notes!)),
          ],
          const SizedBox(height: 24),
          TextButton(
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('일정을 지울까요?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('삭제'),
                    ),
                  ],
                ),
              );
              if (ok == true && context.mounted) {
                await ref.read(eventsViewModelProvider.notifier).remove(event.id);
                if (context.mounted) context.pop();
              }
            },
            child: const Text('일정 삭제', style: TextStyle(color: AppColors.cinnabar)),
          ),
        ],
      ),
    );
  }
}
