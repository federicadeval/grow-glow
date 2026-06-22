import 'package:flutter/material.dart';

class Exercise {
  final String name;
  final int sets;
  final int reps;
  final String weight;
  final int restSeconds;

  const Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.restSeconds,
  });
}

class WorkoutPlan {
  final String id;
  final String name;
  final IconData icon;
  final String duration;
  final int estimatedKcal;
  final List<Exercise> exercises;

  const WorkoutPlan({
    required this.id,
    required this.name,
    required this.icon,
    required this.duration,
    required this.estimatedKcal,
    required this.exercises,
  });
}

final List<WorkoutPlan> builtinWorkouts = [
  WorkoutPlan(
    id: 'full_body_a',
    name: 'Full Body Forza',
    icon: Icons.fitness_center_rounded,
    duration: '35 min',
    estimatedKcal: 250,
    exercises: [
      Exercise(name: 'Squat con bilanciere', sets: 3, reps: 8, weight: '10 kg', restSeconds: 90),
      Exercise(name: 'Panca Piana', sets: 3, reps: 8, weight: '10 kg', restSeconds: 90),
      Exercise(name: 'Stacco da terra', sets: 3, reps: 8, weight: '15-20 kg', restSeconds: 120),
      Exercise(name: 'Shoulder Press', sets: 3, reps: 10, weight: '8-10 kg', restSeconds: 90),
      Exercise(name: 'Rematore con bilanciere', sets: 3, reps: 10, weight: '10-12 kg', restSeconds: 90),
    ],
  ),
  WorkoutPlan(
    id: 'full_body_b',
    name: 'Full Body Ipertrofia',
    icon: Icons.local_fire_department_rounded,
    duration: '40 min',
    estimatedKcal: 270,
    exercises: [
      Exercise(name: 'Front Squat', sets: 3, reps: 10, weight: '10-12 kg', restSeconds: 90),
      Exercise(name: 'Panca Inclinata', sets: 3, reps: 10, weight: '10 kg', restSeconds: 90),
      Exercise(name: 'Romanian Deadlift', sets: 3, reps: 10, weight: '15-20 kg', restSeconds: 90),
      Exercise(name: 'Bent-over Row', sets: 3, reps: 12, weight: '10-15 kg', restSeconds: 75),
      Exercise(name: 'Skull Crusher', sets: 3, reps: 12, weight: '6-8 kg', restSeconds: 60),
    ],
  ),
  WorkoutPlan(
    id: 'full_body_c',
    name: 'Full Body Tonificante',
    icon: Icons.spa_rounded,
    duration: '35 min',
    estimatedKcal: 230,
    exercises: [
      Exercise(name: 'Goblet Squat', sets: 3, reps: 12, weight: '6-8 kg', restSeconds: 75),
      Exercise(name: 'Hip Thrust con bilanciere', sets: 3, reps: 12, weight: '15-20 kg', restSeconds: 75),
      Exercise(name: 'Panca con manubri', sets: 3, reps: 12, weight: '4-5 kg/lato', restSeconds: 75),
      Exercise(name: 'Arnold Press', sets: 3, reps: 12, weight: '3-4 kg/lato', restSeconds: 60),
      Exercise(name: 'Curl con bilanciere', sets: 3, reps: 15, weight: '6-8 kg', restSeconds: 60),
    ],
  ),
  WorkoutPlan(
    id: 'full_body_home',
    name: 'Full Body a Casa',
    icon: Icons.accessibility_new_rounded,
    duration: '30 min',
    estimatedKcal: 180,
    exercises: [
      Exercise(name: 'Squat', sets: 3, reps: 15, weight: '—', restSeconds: 60),
      Exercise(name: 'Superman', sets: 3, reps: 12, weight: '—', restSeconds: 45),
      Exercise(name: 'Affondi alternati', sets: 3, reps: 10, weight: '—', restSeconds: 60),
      Exercise(name: 'Crunch', sets: 3, reps: 20, weight: '—', restSeconds: 45),
      Exercise(name: 'Glute Bridge', sets: 3, reps: 15, weight: '—', restSeconds: 45),
    ],
  ),
];
