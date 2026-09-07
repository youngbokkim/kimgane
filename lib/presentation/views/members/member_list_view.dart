import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kimgane/core/theme/app_theme.dart';
import 'package:kimgane/data/models/enums.dart';
import 'package:kimgane/data/models/family_member.dart';
import 'package:kimgane/presentation/viewmodels/app_view_models.dart';

class MemberListView extends ConsumerWidget {
  const MemberListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = ref.watch(membersViewModelProvider);
    final living = members.where((m) => !m.isDeceased).toList();
    final deceased = members.where((m) => m.isDeceased).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('가족')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/members/new'),
        child: const Icon(Icons.person_add_alt_1),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
        children: [
          _Group(title: '생존', members: living),
          const SizedBox(height: 16),
          _Group(title: '故人 · 제사 대상', members: deceased),
        ],
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.title, required this.members});

  final String title;
  final List<FamilyMember> members;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        if (members.isEmpty)
          const Text('등록된 가족이 없습니다.', style: TextStyle(color: AppColors.inkMuted))
        else
          for (final member in members)
            Card(
              child: ListTile(
                title: Text(member.name),
                subtitle: Text(
                  '${member.kinship.label} · ${member.displayClan}'
                  '${member.isDeceased ? ' · 故' : ''}',
                ),
                onTap: () => context.push('/members/${member.id}/edit'),
              ),
            ),
      ],
    );
  }
}
