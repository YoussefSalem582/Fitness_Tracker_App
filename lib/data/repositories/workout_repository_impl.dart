// lib/data/repositories/workout_repository_impl.dart
import '../../domain/entities/workout.dart';
import '../../domain/repositories/workout_repository.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  // TODO: Add data source
  final List<Workout> _workouts = [];

  @override
  Future<List<Workout>> getWorkouts() async {
    return _workouts;
  }

  @override
  Future<void> addWorkout(Workout workout) async {
    _workouts.add(workout);
  }

  @override
  Future<void> updateWorkout(Workout workout) async {
    final index = _workouts.indexWhere((w) => w.id == workout.id);
    if (index != -1) {
      _workouts[index] = workout;
    }
  }

  @override
  Future<void> deleteWorkout(String id) async {
    _workouts.removeWhere((workout) => workout.id == id);
  }
}