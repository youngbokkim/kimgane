import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kimgane/core/theme/app_theme.dart';
import 'package:kimgane/data/models/enums.dart';
import 'package:kimgane/presentation/viewmodels/app_view_models.dart';
import 'package:kimgane/presentation/widgets/chukmun_paper.dart';
import 'package:kimgane/presentation/widgets/jibang_paper.dart';

class JibangEditorView extends ConsumerStatefulWidget {
  const JibangEditorView({super.key, this.preselectedIds});

  final List<String>? preselectedIds;

  @override
  ConsumerState<JibangEditorView> createState() => _JibangEditorViewState();
}

class _JibangEditorViewState extends ConsumerState<JibangEditorView> {
  @override
  void initState() {
    super.initState();
    final ids = widget.preselectedIds;
    if (ids != null && ids.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(jibangViewModelProvider.notifier).setSelected(ids);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersViewModelProvider);
    final state = ref.watch(jibangViewModelProvider);
    final events = ref.watch(eventsViewModelProvider);
    final composer = ref.watch(jibangComposerProvider);
    final deceased = members.where((m) => m.isDeceased).toList();
    final selected = members.where((m) => state.selectedIds.contains(m.id)).toList();
    final texts = composer.pairFor(selected);
    final chukmun = ref.watch(chukmunComposerProvider).compose(
      ancestors: selected,
      events: events,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('지방 · 축문 쓰기'),
        actions: [
          TextButton(
            onPressed: texts.isEmpty ? null : () => context.push('/jibang/preview'),
            child: const Text('미리보기'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          const Text(
            '고인은 최대 두 분까지 한 장의 지방에 모십니다. 왼쪽이 고위(考), 오른쪽이 비위(妣)입니다. '
            '같은 선택으로 축문도 만듭니다.',
            style: TextStyle(color: AppColors.inkMuted),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('한자로 쓰기'),
            subtitle: const Text('끄면 한글로 세로 표기합니다'),
            value: state.useHanja,
            onChanged: ref.read(jibangViewModelProvider.notifier).setUseHanja,
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final member in deceased)
                FilterChip(
                  label: Text('${member.name} (${member.kinship.label})'),
                  selected: state.selectedIds.contains(member.id),
                  onSelected: (_) =>
                      ref.read(jibangViewModelProvider.notifier).toggle(member.id),
                ),
            ],
          ),
          const SizedBox(height: 24),
          if (texts.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('제사에 모실 조상을 선택해 주세요.'),
              ),
            )
          else ...[
            const Text(
              '지방',
              style: TextStyle(
                fontFamily: 'NanumMyeongjo',
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            JibangPaper(people: texts, useHanja: state.useHanja),
            const SizedBox(height: 16),
            for (final text in texts)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(text.name),
                subtitle: Text(state.useHanja ? text.hanja : text.hangul),
              ),
            const SizedBox(height: 8),
            const Text(
              '축문',
              style: TextStyle(
                fontFamily: 'NanumMyeongjo',
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '고른 조상을 기준으로, 제주 김영필이 고하는 한글 축문을 세로로 만듭니다. '
              '오른쪽부터 읽습니다.',
              style: TextStyle(color: AppColors.inkMuted),
            ),
            const SizedBox(height: 12),
            ChukmunPaper(chukmun: chukmun),
            const SizedBox(height: 12),
            SelectableText(
              chukmun.columns.join('\n'),
              style: const TextStyle(
                fontFamily: 'NanumMyeongjo',
                height: 1.7,
                color: AppColors.inkMuted,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => context.push('/jibang/preview'),
              icon: const Icon(Icons.print_outlined),
              label: const Text('미리보고 출력하기'),
            ),
          ],
        ],
      ),
    );
  }
}
