class DayRoutineConfig {
  final int weekday; // 1=Mon, 7=Sun
  final List<String> morningProductIds;
  final List<String> eveningProductIds;

  const DayRoutineConfig({
    required this.weekday,
    this.morningProductIds = const [],
    this.eveningProductIds = const [],
  });

  DayRoutineConfig copyWith({
    List<String>? morningProductIds,
    List<String>? eveningProductIds,
  }) =>
      DayRoutineConfig(
        weekday: weekday,
        morningProductIds: morningProductIds ?? this.morningProductIds,
        eveningProductIds: eveningProductIds ?? this.eveningProductIds,
      );

  Map<String, dynamic> toJson() => {
        'weekday': weekday,
        'morningProductIds': morningProductIds,
        'eveningProductIds': eveningProductIds,
      };

  factory DayRoutineConfig.fromJson(Map<String, dynamic> json) =>
      DayRoutineConfig(
        weekday: json['weekday'] as int,
        morningProductIds:
            List<String>.from(json['morningProductIds'] as List),
        eveningProductIds:
            List<String>.from(json['eveningProductIds'] as List),
      );
}
