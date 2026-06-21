import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/cycle_entry.dart';

const _kLastPeriodKey  = 'cycle_last_period_v2';
const _kCycleLengthKey = 'cycle_length_v2';
const _kPeriodLengthKey = 'period_length_v2';

class CycleState {
  final DateTime? lastPeriodDate;
  final int cycleLength;
  final int periodLength;

  const CycleState({
    this.lastPeriodDate,
    this.cycleLength = 28,
    this.periodLength = 5,
  });

  int? get currentCycleDay {
    if (lastPeriodDate == null) return null;
    return (DateTime.now().difference(lastPeriodDate!).inDays % cycleLength) + 1;
  }

  CyclePhase? get currentPhase {
    final day = currentCycleDay;
    return day == null ? null : phaseForDay(day);
  }

  int? get daysToNextPeriod {
    final day = currentCycleDay;
    return day == null ? null : cycleLength - day + 1;
  }

  DateTime? get nextPeriodDate {
    if (lastPeriodDate == null) return null;
    final cyclesPassed = DateTime.now().difference(lastPeriodDate!).inDays ~/ cycleLength;
    return lastPeriodDate!.add(Duration(days: (cyclesPassed + 1) * cycleLength));
  }

  // Days 11-17 of the cycle are considered fertile
  bool get isInFertileWindow {
    final day = currentCycleDay;
    return day != null && day >= 11 && day <= 17;
  }

  DateTime? get ovulationDate {
    if (lastPeriodDate == null) return null;
    final cyclesPassed = DateTime.now().difference(lastPeriodDate!).inDays ~/ cycleLength;
    return lastPeriodDate!.add(Duration(days: cyclesPassed * cycleLength + 14));
  }

  CyclePhase phaseForDay(int day) {
    if (day <= periodLength) return CyclePhase.mestruale;
    if (day <= 13)           return CyclePhase.follicolare;
    if (day <= 16)           return CyclePhase.ovulatoria;
    return                          CyclePhase.luteinica;
  }

  CyclePhase? phaseForDate(DateTime date) {
    if (lastPeriodDate == null) return null;
    final diff = date.difference(lastPeriodDate!).inDays;
    if (diff < 0) return null;
    return phaseForDay((diff % cycleLength) + 1);
  }
}

class CycleNotifier extends StateNotifier<CycleState> {
  CycleNotifier() : super(const CycleState()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final dateStr = prefs.getString(_kLastPeriodKey);
    state = CycleState(
      lastPeriodDate: dateStr != null ? DateTime.parse(dateStr) : null,
      cycleLength:   prefs.getInt(_kCycleLengthKey)  ?? 28,
      periodLength:  prefs.getInt(_kPeriodLengthKey) ?? 5,
    );
  }

  Future<void> updateLastPeriodDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final d = DateTime(date.year, date.month, date.day);
    await prefs.setString(_kLastPeriodKey, d.toIso8601String());
    state = CycleState(lastPeriodDate: d, cycleLength: state.cycleLength, periodLength: state.periodLength);
  }

  Future<void> updateCycleLength(int length) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kCycleLengthKey, length);
    state = CycleState(lastPeriodDate: state.lastPeriodDate, cycleLength: length, periodLength: state.periodLength);
  }

  Future<void> updatePeriodLength(int length) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kPeriodLengthKey, length);
    state = CycleState(lastPeriodDate: state.lastPeriodDate, cycleLength: state.cycleLength, periodLength: length);
  }
}

final cycleProvider =
    StateNotifierProvider<CycleNotifier, CycleState>((ref) => CycleNotifier());
