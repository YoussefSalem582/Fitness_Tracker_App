// lib/data/repositories/workout_repository_impl.dart
    import 'package:hive_flutter/hive_flutter.dart';
    import '../../domain/entities/exercise.dart';
import '../../domain/entities/workout.dart';
    import '../../domain/repositories/workout_repository.dart';
    import '../models/workout_model.dart';

    class WorkoutRepositoryImpl implements WorkoutRepository {
      late Box<WorkoutModel> _workoutBox;

      WorkoutRepositoryImpl() {
        _initHive();
      }

      Future<void> _initHive() async {
        await Hive.initFlutter();
        Hive.registerAdapter(WorkoutModelAdapter());
        Hive.registerAdapter(ExerciseModelAdapter());
        _workoutBox = await Hive.openBox<WorkoutModel>('workouts');
      }

      @override
      Future<List<Workout>> getWorkouts() async {
        return _workoutBox.values.map((model) => _convertToEntity(model)).toList();
      }

      @override
      Future<void> addWorkout(Workout workout) async {
        await _workoutBox.put(workout.id, _convertToModel(workout));
      }

      @override
      Future<void> updateWorkout(Workout workout) async {
        await _workoutBox.put(workout.id, _convertToModel(workout));
      }

      @override
      Future<void> deleteWorkout(String id) async {
        await _workoutBox.delete(id);
      }

      WorkoutModel _convertToModel(Workout workout) {
        return WorkoutModel(
          id: workout.id,
          name: workout.name,
          date: workout.date,
          exercises: workout.exercises
              .map((e) => ExerciseModel(
                    id: e.id,
                    name: e.name,
                    sets: e.sets,
                    reps: e.reps,
                    weight: e.weight,
                  ))
              .toList(),
          duration: workout.duration,
        );
      }

      Workout _convertToEntity(WorkoutModel model) {
        return Workout(
          id: model.id,
          name: model.name,
          date: model.date,
          exercises: model.exercises
              .map((e) => Exercise(
                    id: e.id,
                    name: e.name,
                    sets: e.sets,
                    reps: e.reps,
                    weight: e.weight,
                  ))
              .toList(),
          duration: model.duration,
        );
      }
    }