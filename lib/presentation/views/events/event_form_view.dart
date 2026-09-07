import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kimgane/core/theme/app_theme.dart';
import 'package:kimgane/data/models/enums.dart';
import 'package:kimgane/data/models/family_event.dart';
import 'package:kimgane/presentation/viewmodels/app_view_models.dart';

class EventFormView extends ConsumerStatefulWidget {
  const EventFormView({super.key, this.eventId, this.initialType});

  final String? eventId;
  final EventType? initialType;

  @override
  ConsumerState<EventFormView> createState() => _EventFormViewState();
}

class _EventFormViewState extends ConsumerState<EventFormView> {
  final _title = TextEditingController();
  final _notes = TextEditingController();
  late EventType _type;
  CalendarKind _calendar = CalendarKind.solar;
  JesaKind _jesaKind = JesaKind.gije;
  GyeongjosaKind _gyeong = GyeongjosaKind.other;
  int? _year;
  int _month = 1;
  int _day = 1;
  bool _leap = false;
  bool _recurring = true;
  String? _memberId;
  List<String> _ancestorIds = [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType ?? EventType.jesa;
    _applyTypeDefaults(_type);
  }

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _applyTypeDefaults(EventType type) {
    _calendar = type.defaultCalendar;
    _recurring = type != EventType.gyeongjosa;
    if (type == EventType.gyeongjosa) {
      _year = DateTime.now().year;
    }
  }

  void _hydrate(FamilyEvent event) {
    _title.text = event.title;
    _notes.text = event.notes ?? '';
    _type = event.type;
    _calendar = event.calendarKind;
    _year = event.year;
    _month = event.month;
    _day = event.day;
    _leap = event.isLeapMonth;
    _recurring = event.isRecurring;
    _memberId = event.memberId;
    _ancestorIds = [...event.ancestorIds];
    _jesaKind = event.jesaKind ?? JesaKind.gije;
    _gyeong = event.gyeongjosaKind ?? GyeongjosaKind.other;
    _loaded = true;
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersViewModelProvider);
    if (widget.eventId != null && !_loaded) {
      final existing = ref.read(eventsViewModelProvider.notifier).byId(widget.eventId!);
      if (existing != null) {
        _hydrate(existing);
      } else {
        _loaded = true;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.eventId == null ? '일정 추가' : '일정 수정'),
        actions: [
          TextButton(onPressed: _save, child: const Text('저장')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          SegmentedButton<EventType>(
            segments: [
              for (final type in EventType.values)
                ButtonSegment(value: type, label: Text(type.label)),
            ],
            selected: {_type},
            onSelectionChanged: (value) {
              setState(() {
                _type = value.first;
                _applyTypeDefaults(_type);
              });
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: '제목'),
          ),
          const SizedBox(height: 16),
          if (_type == EventType.jesa)
            DropdownButtonFormField<JesaKind>(
              initialValue: _jesaKind,
              decoration: const InputDecoration(labelText: '제례 종류'),
              items: [
                for (final kind in JesaKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) => setState(() => _jesaKind = value ?? _jesaKind),
            ),
          if (_type == EventType.gyeongjosa)
            DropdownButtonFormField<GyeongjosaKind>(
              initialValue: _gyeong,
              decoration: const InputDecoration(labelText: '경조사 종류'),
              items: [
                for (final kind in GyeongjosaKind.values)
                  DropdownMenuItem(value: kind, child: Text(kind.label)),
              ],
              onChanged: (value) => setState(() => _gyeong = value ?? _gyeong),
            ),
          const SizedBox(height: 16),
          SegmentedButton<CalendarKind>(
            segments: const [
              ButtonSegment(value: CalendarKind.solar, label: Text('양력')),
              ButtonSegment(value: CalendarKind.lunar, label: Text('음력')),
            ],
            selected: {_calendar},
            onSelectionChanged: (value) => setState(() => _calendar = value.first),
          ),
          const SizedBox(height: 8),
          Text(
            _type == EventType.jesa
                ? '제사는 음력이 기본입니다. 기일은 음력으로 두고 달력에서는 양력으로 환산해 보여 줍니다.'
                : '양력과 음력을 모두 쓸 수 있습니다.',
            style: const TextStyle(color: AppColors.inkMuted, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (!_recurring)
                Expanded(
                  child: _numberField(
                    '연',
                    _year ?? DateTime.now().year,
                    1900,
                    2049,
                    (v) => setState(() => _year = v),
                  ),
                ),
              if (!_recurring) const SizedBox(width: 8),
              Expanded(
                child: _numberField('월', _month, 1, 12, (v) => setState(() => _month = v)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _numberField('일', _day, 1, 31, (v) => setState(() => _day = v)),
              ),
            ],
          ),
          if (_calendar == CalendarKind.lunar)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('윤달'),
              value: _leap,
              onChanged: (v) => setState(() => _leap = v),
            ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('매년 반복'),
            subtitle: Text(_type == EventType.gyeongjosa ? '경조사는 보통 한 번입니다' : '생일·제사는 매년 반복'),
            value: _recurring,
            onChanged: (v) => setState(() {
              _recurring = v;
              _year = v ? null : (_year ?? DateTime.now().year);
            }),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String?>(
            initialValue: _memberId,
            decoration: const InputDecoration(labelText: '관련 가족'),
            items: [
              const DropdownMenuItem(value: null, child: Text('선택 안 함')),
              for (final member in members)
                DropdownMenuItem(value: member.id, child: Text(member.name)),
            ],
            onChanged: (value) => setState(() => _memberId = value),
          ),
          if (_type == EventType.jesa) ...[
            const SizedBox(height: 16),
            const Text('지방에 모실 조상 (최대 2위, 고위·비위)'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final member in members.where((m) => m.isDeceased))
                  FilterChip(
                    label: Text(member.name),
                    selected: _ancestorIds.contains(member.id),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          if (_ancestorIds.length >= 2) {
                            _ancestorIds.removeAt(0);
                          }
                          _ancestorIds.add(member.id);
                        } else {
                          _ancestorIds.remove(member.id);
                        }
                      });
                    },
                  ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          TextField(
            controller: _notes,
            maxLines: 4,
            decoration: const InputDecoration(labelText: '메모'),
          ),
        ],
      ),
    );
  }

  Widget _numberField(
    String label,
    int value,
    int min,
    int max,
    ValueChanged<int> onChanged,
  ) {
    return TextFormField(
      key: ValueKey('$label-$value'),
      initialValue: '$value',
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      onChanged: (raw) {
        final parsed = int.tryParse(raw);
        if (parsed == null) return;
        onChanged(parsed.clamp(min, max));
      },
    );
  }

  Future<void> _save() async {
    final title = _title.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목을 입력해 주세요.')),
      );
      return;
    }
    final notifier = ref.read(eventsViewModelProvider.notifier);
    final existing = widget.eventId == null
        ? null
        : notifier.byId(widget.eventId!);
    final event = FamilyEvent(
      id: existing?.id ?? notifier.newId(),
      type: _type,
      title: title,
      calendarKind: _calendar,
      year: _recurring ? null : _year,
      month: _month,
      day: _day,
      isLeapMonth: _calendar == CalendarKind.lunar && _leap,
      isRecurring: _recurring,
      memberId: _memberId,
      jesaKind: _type == EventType.jesa ? _jesaKind : null,
      gyeongjosaKind: _type == EventType.gyeongjosa ? _gyeong : null,
      ancestorIds: _ancestorIds,
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      createdAt: existing?.createdAt ?? DateTime.now(),
    );
    await notifier.upsert(event);
    if (mounted) context.pop();
  }
}
