enum Gender { female, male }

enum FitnessGoal { weightLoss, maintenance, muscleMass }

enum DietStyle { onnivora, vegetariana, vegana, altro }

extension FitnessGoalLabel on FitnessGoal {
  String get label {
    switch (this) {
      case FitnessGoal.weightLoss: return 'Perdita di peso';
      case FitnessGoal.maintenance: return 'Mantenimento';
      case FitnessGoal.muscleMass: return 'Aumento massa muscolare';
    }
  }

  String get emoji {
    switch (this) {
      case FitnessGoal.weightLoss: return '⚖️';
      case FitnessGoal.maintenance: return '🎯';
      case FitnessGoal.muscleMass: return '💪';
    }
  }
}

extension DietStyleLabel on DietStyle {
  String get label {
    switch (this) {
      case DietStyle.onnivora: return 'Onnivora';
      case DietStyle.vegetariana: return 'Vegetariana';
      case DietStyle.vegana: return 'Vegana';
      case DietStyle.altro: return 'Altro';
    }
  }

  String get emoji {
    switch (this) {
      case DietStyle.onnivora: return '🍗';
      case DietStyle.vegetariana: return '🥦';
      case DietStyle.vegana: return '🌱';
      case DietStyle.altro: return '🍽️';
    }
  }
}

const kAllIntolerances = ['Lattosio', 'Glutine', 'Frutta secca', 'Uova', 'Pesce', 'Crostacei', 'Soia'];

class UserProfile {
  final String? name;
  final int age;
  final Gender gender;
  final double weightKg;
  final double heightCm;
  final FitnessGoal goal;
  final DietStyle dietStyle;
  final List<String> intolerances;
  final String foodsToAvoid;

  const UserProfile({
    this.name,
    required this.age,
    required this.gender,
    required this.weightKg,
    required this.heightCm,
    required this.goal,
    this.dietStyle = DietStyle.onnivora,
    this.intolerances = const [],
    this.foodsToAvoid = '',
  });

  // Mifflin-St Jeor
  double get bmr {
    if (gender == Gender.female) {
      return (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;
    } else {
      return (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
    }
  }

  double get tdee => bmr * 1.375;

  int get suggestedKcal {
    switch (goal) {
      case FitnessGoal.weightLoss: return (tdee * 0.80).round();
      case FitnessGoal.maintenance: return tdee.round();
      case FitnessGoal.muscleMass: return (tdee * 1.10).round();
    }
  }

  int get proteinG {
    switch (goal) {
      case FitnessGoal.weightLoss: return (weightKg * 2.0).round();
      case FitnessGoal.maintenance: return (weightKg * 1.8).round();
      case FitnessGoal.muscleMass: return (weightKg * 2.2).round();
    }
  }

  int get carbsG => ((suggestedKcal * 0.45) / 4).round();
  int get fatG => ((suggestedKcal * 0.25) / 9).round();

  UserProfile copyWith({
    String? name,
    int? age,
    Gender? gender,
    double? weightKg,
    double? heightCm,
    FitnessGoal? goal,
    DietStyle? dietStyle,
    List<String>? intolerances,
    String? foodsToAvoid,
  }) {
    return UserProfile(
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      goal: goal ?? this.goal,
      dietStyle: dietStyle ?? this.dietStyle,
      intolerances: intolerances ?? this.intolerances,
      foodsToAvoid: foodsToAvoid ?? this.foodsToAvoid,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'gender': gender.index,
    'weightKg': weightKg,
    'heightCm': heightCm,
    'goal': goal.index,
    'dietStyle': dietStyle.index,
    'intolerances': intolerances,
    'foodsToAvoid': foodsToAvoid,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    name: json['name'] as String?,
    age: json['age'] as int,
    gender: Gender.values[json['gender'] as int],
    weightKg: (json['weightKg'] as num).toDouble(),
    heightCm: (json['heightCm'] as num).toDouble(),
    goal: FitnessGoal.values[json['goal'] as int],
    dietStyle: DietStyle.values[json['dietStyle'] as int? ?? 0],
    intolerances: (json['intolerances'] as List<dynamic>?)?.cast<String>() ?? [],
    foodsToAvoid: json['foodsToAvoid'] as String? ?? '',
  );

  static UserProfile get defaultProfile => const UserProfile(
    age: 30,
    gender: Gender.female,
    weightKg: 60,
    heightCm: 165,
    goal: FitnessGoal.maintenance,
  );
}
