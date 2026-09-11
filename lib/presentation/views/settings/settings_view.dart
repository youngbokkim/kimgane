import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kimgane/core/constants/clan.dart';
import 'package:kimgane/core/utils/event_notification_planner.dart';
import 'package:kimgane/data/models/app_settings.dart';
import 'package:kimgane/presentation/viewmodels/app_view_models.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsViewModelProvider);
    final time = TimeOfDay(
      hour: settings.notifyHour,
      minute: settings.notifyMinute,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          TextFormField(
            initialValue: '김영필',
            enabled: false,
            decoration: const InputDecoration(
              labelText: '제주',
              helperText: '제주는 장손 김영필로 고정입니다.',
            ),
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
          const SizedBox(height: 16),
          Text('글자 크기', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          const Text('휴대폰에서 글자가 작으면 크게 바꿔 보세요.'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final option in AppTextScale.options)
                ChoiceChip(
                  label: Text(option.label),
                  selected: settings.textScale == option.value,
                  onSelected: (_) => ref
                      .read(settingsViewModelProvider.notifier)
                      .update(settings.copyWith(textScale: option.value)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '가나다 미리보기 · 제사 · 생일',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('일정 알림'),
            subtitle: Text(
              kIsWeb
                  ? '휴대폰 앱에서 제사·생일·경조사를 하루 전과 당일 자정에 알려 줍니다.'
                  : '제사·생일·경조사를 ${EventNotificationPlanner.daysBefore}일 전과 당일 자정(00:00)에 알려 줍니다.',
            ),
            value: settings.notifyEnabled,
            onChanged: (value) => ref
                .read(settingsViewModelProvider.notifier)
                .update(settings.copyWith(notifyEnabled: value)),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            enabled: settings.notifyEnabled,
            title: const Text('하루 전 알림 시각'),
            subtitle: Text(time.format(context)),
            trailing: const Icon(Icons.schedule_outlined),
            onTap: settings.notifyEnabled
                ? () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: time,
                      helpText: '하루 전 알림 시각',
                    );
                    if (picked == null) return;
                    await ref
                        .read(settingsViewModelProvider.notifier)
                        .update(
                          settings.copyWith(
                            notifyHour: picked.hour,
                            notifyMinute: picked.minute,
                          ),
                        );
                  }
                : null,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            enabled: settings.notifyEnabled,
            title: const Text('당일 알림'),
            subtitle: const Text('자정(00:00)에 알려 줍니다. 시각은 바꿀 수 없습니다.'),
          ),
          const SizedBox(height: 24),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('광산김씨 소개'),
            subtitle: const Text('가족묘 비석 · 벼슬 한글 풀이'),
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
