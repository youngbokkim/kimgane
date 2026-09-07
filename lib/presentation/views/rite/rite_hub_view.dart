import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kimgane/core/constants/clan.dart';
import 'package:kimgane/core/theme/app_theme.dart';
import 'package:kimgane/presentation/widgets/section_card.dart';

class RiteHubView extends StatelessWidget {
  const RiteHubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('제례')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Text(
            '${ClanCatalog.clanName} · ${ClanCatalog.hometown}',
            style: const TextStyle(color: AppColors.inkMuted),
          ),
          const SizedBox(height: 8),
          Text(
            '지방을 미리 보고 출력하고, 의성 영남 가례에 맞춘 상차림을 확인합니다.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          SectionCard(
            title: '광산김씨 소개',
            subtitle: '의성 가족묘 비석 · 벼슬',
            onTap: () => context.push('/clan'),
            trailing: const Icon(Icons.chevron_right),
            child: const Text(
              '직계선조 묘비의 벼슬과 36·37대 가족묘 비석을 '
              '사진과 한글 풀이로 봅니다.',
            ),
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: '지방 · 축문 쓰기',
            subtitle: '한지 규격 6×22cm · 고위 左 / 비위 右',
            onTap: () => context.push('/jibang'),
            trailing: const Icon(Icons.chevron_right),
            child: const Text(
              '제사 대상 조상을 고르면 한자·한글 지방과 한글 축문을 세로로 보여 주고, '
              '웹과 앱에서 그대로 인쇄할 수 있습니다.',
            ),
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: '제사상 상차림 가이드',
            subtitle: '실제 상차림 사진 · 가례집람 · 영남 관행',
            onTap: () => context.push('/offering'),
            trailing: const Icon(Icons.chevron_right),
            child: const Text(
              '김가네가 제사에 올린 실제 상차림 사진과, 진설도·홀기·간소화 원칙을 한 페이지에서 봅니다.',
            ),
          ),
        ],
      ),
    );
  }
}
