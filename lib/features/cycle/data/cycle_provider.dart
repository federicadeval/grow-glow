import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/cycle_entry.dart';

const _kCyclesKey = 'cycle_entries_v1';
const _kCycleLengthKey = 'cycle_length_v1';
const _kPeriodLengthKey = 'period_length_v1';

class CycleState {
  final List<CycleEntry> entries;
  final int cycleLength;
  final int periodLength;

  const CycleState({
    this.entries = const [],
    this.cycleLength = 28,
    this.periodLength = 5,
  });

  CycleEntry? get lastEntry => entries.isEmpty ? null : entries.last;

  bool get isInActivePeriod {
    final last = lastEntry;
    if (last == null) return false;
    final day = DateTime.now().difference(last.startDate).inDays + 1;
    return day >= 1 && day <= periodLength && last.endDate == null;
  }

  int? get currentCycleDay {
    final last = lastEntry;
    if (last == null) return null;
    return (DateTime.now().difference(last.startDate).inDays % cycleLength) + 1;
  }

  CyclePhase? get currentPhase {
    final day = currentCycleDay;
    if (day == null) return null;
    return _phaseForDay(day);
  }

  int? get daysToNextPeriod {
    final day = currentCycleDay;
    if (day == null) return null;
    return cycleLength - day + 1;
  }

  DateTime? get nextPeriodDate {
    final last = lastEntry;
    if (last == null) return null;
    final daysPassed = DateTime.now().difference(last.startDate).inDays;
    final cyclesPassed = daysPassed ~/ cycleLength;
    return last.startDate.add(Duration(days: (cyclesPassed + 1) * cycleLength));
  }

  CyclePhase _phaseForDay(int day) {
    if (day <= periodLength) return CyclePhase.mestruale;
    if (day <= 13) return CyclePhase.follicolare;
    if (day <= 16) return CyclePhase.ovulatoria;
    return CyclePhase.luteinica;
  }

  CyclePhase? phaseForDate(DateTime date) {
    final last = lastEntry;
    if (last == null) return null;
    final diff = date.difference(last.startDate).inDays;
    if (diff < 0) return null;
    return _phaseForDay((diff % cycleLength) + 1);
  }
}

class CycleNotifier extends StateNotifier<CycleState> {
  CycleNotifier() : super(const CycleState()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_kCyclesKey) ?? [];
    final entries = raw
        .map((s) => CycleEntry.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
    state = CycleState(
      entries: entries,
      cycleLength: prefs.getInt(_kCycleLengthKey) ?? 28,
      periodLength: prefs.getInt(_kPeriodLengthKey) ?? 5,
    );
  }

  Future<void> _persist(List<CycleEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _kCyclesKey,
      entries.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  Future<void> logPeriodStart(DateTime date) async {
    final d = DateTime(date.year, date.month, date.day);
    final entries = [...state.entries, CycleEntry(startDate: d)]
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
    await _persist(entries);
    state = CycleState(entries: entries, cycleLength: state.cycleLength, periodLength: state.periodLength);
  }

  Future<void> endCurrentPeriod(DateTime date) async {
    if (state.entries.isEmpty) return;
    final d = DateTime(date.year, date.month, date.day);
    final entries = List<CycleEntry>.from(state.entries);
    entries[entries.length - 1] = entries.last.copyWith(endDate: d);
    await _persist(entries);
    state = CycleState(entries: entries, cycleLength: state.cycleLength, periodLength: state.periodLength);
  }

  Future<void> updateCycleLength(int length) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kCycleLengthKey, length);
    state = CycleState(entries: state.entries, cycleLength: length, periodLength: state.periodLength);
  }

  Future<void> updatePeriodLength(int length) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kPeriodLengthKey, length);
    state = CycleState(entries: state.entries, cycleLength: state.cycleLength, periodLength: length);
  }

  Future<void> deleteLast() async {
    if (state.entries.isEmpty) return;
    final entries = state.entries.sublist(0, state.entries.length - 1);
    await _persist(entries);
    state = CycleState(entries: entries, cycleLength: state.cycleLength, periodLength: state.periodLength);
  }
}

final cycleProvider =
    StateNotifierProvider<CycleNotifier, CycleState>((ref) => CycleNotifier());
