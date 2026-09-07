import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kimgane/core/theme/app_theme.dart';
import 'package:kimgane/data/models/enums.dart';
import 'package:kimgane/data/models/family_member.dart';
import 'package:kimgane/presentation/viewmodels/app_view_models.dart';
import 'package:uuid/uuid.dart';

class MemberFormView extends ConsumerStatefulWidget {
  const MemberFormView({super.key, this.memberId});

  final String? memberId;

  @override
  ConsumerState<MemberFormView> createState() => _MemberFormViewState();
}

class _MemberFormViewState extends ConsumerState<MemberFormView> {
  final _name = TextEditingController();
  final _bonGwan = TextEditingController(text: '광산');
  final _surname = TextEditingController(text: '김');
  final _office = TextEditingController();
  final _notes = TextEditingController();
  Gender _gender = Gender.male;
  Kinship _kinship = Kinship.other;
  CalendarKind _birthCal = CalendarKind.solar;
  CalendarKind _deathCal = CalendarKind.lunar;
  int? _birthYear;
  int? _birthMonth;
  int? _birthDay;
  bool _birthLeap = false;
  bool _deceased = false;
  int? _deathYear;
  int? _deathMonth;
  int? _deathDay;
  bool _deathLeap = false;
  bool _loaded = false;

  @override
  void dispose() {
    _name.dispose();
    _bonGwan.dispose();
    _surname.dispose();
    _office.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _hydrate(FamilyMember member) {
    _name.text = member.name;
    _bonGwan.text = member.bonGwan;
    _surname.text = member.surname;
    _office.text = member.officeTitle ?? '';
    _notes.text = member.notes ?? '';
    _gender = member.gender;
    _kinship = member.kinship;
    _birthCal = member.birthCalendar;
    _deathCal = member.deathCalendar;
    _birthYear = member.birthYear;
    _birthMonth = member.birthMonth;
    _birthDay = member.birthDay;
    _birthLeap = member.birthLeapMonth;
    _deceased = member.isDeceased;
    _deathYear = member.deathYear;
    _deathMonth = member.deathMonth;
    _deathDay = member.deathDay;
    _deathLeap = member.deathLeapMonth;
    _loaded = true;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.memberId != null && !_loaded) {
      final existing = ref.read(membersViewModelProvider.notifier).byId(widget.memberId!);
      if (existing != null) _hydrate(existing);
      _loaded = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.memberId == null ? '가족 추가' : '가족 수정'),
        actions: [
          TextButton(onPressed: _save, child: const Text('저장')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          TextField(
            controller: _name,
            decoration: const InputDecoration(labelText: '이름'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _bonGwan,
                  decoration: const InputDecoration(labelText: '본관'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _surname,
                  decoration: const InputDecoration(labelText: '성'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SegmentedButton<Gender>(
            segments: const [
              ButtonSegment(value: Gender.male, label: Text('남')),
              ButtonSegment(value: Gender.female, label: Text('여')),
            ],
            selected: {_gender},
            onSelectionChanged: (v) => setState(() => _gender = v.first),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<Kinship>(
            initialValue: _kinship,
            decoration: const InputDecoration(labelText: '제주 기준 관계'),
            items: [
              for (final k in Kinship.values)
                DropdownMenuItem(value: k, child: Text(k.label)),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _kinship = value;
                _gender = value.defaultMale ? Gender.male : Gender.female;
              });
            },
          ),
          const SizedBox(height: 16),
          const Text('생일', style: TextStyle(fontWeight: FontWeight.w700)),
          SegmentedButton<CalendarKind>(
            segments: const [
              ButtonSegment(value: CalendarKind.solar, label: Text('양력')),
              ButtonSegment(value: CalendarKind.lunar, label: Text('음력')),
            ],
            selected: {_birthCal},
            onSelectionChanged: (v) => setState(() => _birthCal = v.first),
          ),
          _ymdRow(
            year: _birthYear,
            month: _birthMonth,
            day: _birthDay,
            onYear: (v) => setState(() => _birthYear = v),
            onMonth: (v) => setState(() => _birthMonth = v),
            onDay: (v) => setState(() => _birthDay = v),
          ),
          if (_birthCal == CalendarKind.lunar)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('윤달 생일'),
              value: _birthLeap,
              onChanged: (v) => setState(() => _birthLeap = v),
            ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('고인'),
            subtitle: const Text('기제사는 음력 기일이 기본입니다'),
            value: _deceased,
            onChanged: (v) => setState(() => _deceased = v),
          ),
          if (_deceased) ...[
            const Text('기일', style: TextStyle(fontWeight: FontWeight.w700)),
            SegmentedButton<CalendarKind>(
              segments: const [
                ButtonSegment(value: CalendarKind.solar, label: Text('양력')),
                ButtonSegment(value: CalendarKind.lunar, label: Text('음력')),
              ],
              selected: {_deathCal},
              onSelectionChanged: (v) => setState(() => _deathCal = v.first),
            ),
            _ymdRow(
              year: _deathYear,
              month: _deathMonth,
              day: _deathDay,
              onYear: (v) => setState(() => _deathYear = v),
              onMonth: (v) => setState(() => _deathMonth = v),
              onDay: (v) => setState(() => _deathDay = v),
            ),
            if (_deathCal == CalendarKind.lunar)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('윤달 기일'),
                value: _deathLeap,
                onChanged: (v) => setState(() => _deathLeap = v),
              ),
          ],
          TextField(
            controller: _office,
            decoration: const InputDecoration(
              labelText: '관직·봉작 (비우면 학생/유인)',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notes,
            maxLines: 3,
            decoration: const InputDecoration(labelText: '메모'),
          ),
          if (widget.memberId != null) ...[
            const SizedBox(height: 24),
            TextButton(
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('가족을 지울까요?'),
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
                if (ok == true) {
                  await ref
                      .read(membersViewModelProvider.notifier)
                      .remove(widget.memberId!);
                  if (!context.mounted) return;
                  context.pop();
                }
              },
              child: const Text('삭제', style: TextStyle(color: AppColors.cinnabar)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _ymdRow({
    required int? year,
    required int? month,
    required int? day,
    required ValueChanged<int?> onYear,
    required ValueChanged<int?> onMonth,
    required ValueChanged<int?> onDay,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        children: [
          Expanded(child: _num('연', year, onYear)),
          const SizedBox(width: 8),
          Expanded(child: _num('월', month, onMonth)),
          const SizedBox(width: 8),
          Expanded(child: _num('일', day, onDay)),
        ],
      ),
    );
  }

  Widget _num(String label, int? value, ValueChanged<int?> onChanged) {
    return TextFormField(
      key: ValueKey('$label-$value'),
      initialValue: value?.toString() ?? '',
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      onChanged: (raw) => onChanged(int.tryParse(raw)),
    );
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이름을 입력해 주세요.')),
      );
      return;
    }
    final existing = widget.memberId == null
        ? null
        : ref.read(membersViewModelProvider.notifier).byId(widget.memberId!);
    final member = FamilyMember(
      id: existing?.id ?? const Uuid().v4(),
      name: _name.text.trim(),
      gender: _gender,
      kinship: _kinship,
      bonGwan: _bonGwan.text.trim().isEmpty ? '광산' : _bonGwan.text.trim(),
      surname: _surname.text.trim().isEmpty ? '김' : _surname.text.trim(),
      birthCalendar: _birthCal,
      birthYear: _birthYear,
      birthMonth: _birthMonth,
      birthDay: _birthDay,
      birthLeapMonth: _birthLeap,
      isDeceased: _deceased,
      deathCalendar: _deathCal,
      deathYear: _deathYear,
      deathMonth: _deathMonth,
      deathDay: _deathDay,
      deathLeapMonth: _deathLeap,
      officeTitle: _office.text.trim().isEmpty ? null : _office.text.trim(),
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
    );
    await ref.read(membersViewModelProvider.notifier).upsert(member);
    if (mounted) context.pop();
  }
}
