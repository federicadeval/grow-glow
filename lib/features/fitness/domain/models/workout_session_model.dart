class WorkoutSession {
  final String id;
  final DateTime date;
  final String workoutId;
  final String workoutName;
  final Map<String, String> weights; // exerciseName -> weight string
  final int fatigue; // 1–5
  final String loadFeel; // 'tooLight' | 'justRight' | 'tooHeavy'
  final bool jointPain;
  final String mood; // 'bad' | 'neutral' | 'good' | 'great'
  final int estimatedKcal;

  const WorkoutSession({
    required this.id,
    required this.date,
    required this.workoutId,
    required this.workoutName,
    required this.weights,
    required this.fatigue,
    required this.loadFeel,
    required this.jointPain,
    required this.mood,
    required this.estimatedKcal,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'workoutId': workoutId,
        'workoutName': workoutName,
        'weights': weights,
        'fatigue': fatigue,
        'loadFeel': loadFeel,
        'jointPain': jointPain,
        'mood': mood,
        'estimatedKcal': estimatedKcal,
      };

  factory WorkoutSession.fromJson(Map<String, dynamic> json) => WorkoutSession(
        id: json['id'] as String,
        date: DateTime.parse(json['date'] as String),
        workoutId: json['workoutId'] as String,
        workoutName: json['workoutName'] as String,
        weights: (json['weights'] as Map<String, dynamic>).cast<String, String>(),
        fatigue: json['fatigue'] as int,
        loadFeel: json['loadFeel'] as String,
        jointPain: json['jointPain'] as bool,
        mood: json['mood'] as String,
        estimatedKcal: json['estimatedKcal'] as int,
      );
}
