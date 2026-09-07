import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kimgane/core/constants/clan.dart';
import 'package:kimgane/presentation/viewmodels/app_view_models.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsViewModelProvider);
    final members = ref.watch(membersViewModelProvider);
    final living = members.where((m) => !m.isDeceased).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          DropdownButtonFormField<String>(
            initialValue: living.any((m) => m.id == settings.officiantId)
                ? settings.officiantId
                : (living.isEmpty ? null : living.first.id),
            decoration: const InputDecoration(labelText: '제주'),
            items: [
              for (final member in living)
                DropdownMenuItem(value: member.id, child: Text(member.name)),
            ],
            onChanged: (id) {
              if (id == null) return;
              ref
                  .read(settingsViewModelProvider.notifier)
                  .update(settings.copyWith(officiantId: id));
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: settings.defaultBonGwan,
            decoration: const InputDecoration(labelText: '기본 본관'),
            onChanged: (value) => ref
                .read(settingsViewModelProvider.notifier)
                .update(settings.copyWith(defaultBonGwan: value)),
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: settings.defaultSurname,
            decoration: const InputDecoration(labelText: '기본 성'),
            onChanged: (value) => ref
                .read(settingsViewModelProvider.notifier)
                .update(settings.copyWith(defaultSurname: value)),
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: settings.hometown,
            decoration: const InputDecoration(labelText: '고향'),
            onChanged: (value) => ref
                .read(settingsViewModelProvider.notifier)
                .update(settings.copyWith(hometown: value)),
          ),
          const SizedBox(height: 24),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('광산김씨 소개'),
            subtitle: const Text('가족묘 비석 · 벼슬 · 축문 한글 풀이'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/clan'),
          ),
          const SizedBox(height: 8),
          Text(
            '${ClanCatalog.clanName} (${ClanCatalog.clanHanja})\n'
            '제사 날짜는 음력을 기본으로 두고, 달력에서는 양력으로 함께 보여 줍니다.\n'
            '상차림 안내는 가례집람과 경상북도 의성·안동 영남 관행을 참고했습니다.',
          ),
        ],
      ),
    );
  }
}
