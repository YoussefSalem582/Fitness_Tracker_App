import 'exercise.dart';

class Workout {
  final String id;
  final String name;
  final DateTime date;
  final List<Exercise> exercises;
  final int duration;

  const Workout({
    required this.id,
    required this.name,
    required this.date,
    required this.exercises,
    required this.duration,
  });
}