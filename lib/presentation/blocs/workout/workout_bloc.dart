// lib/presentation/blocs/workout/workout_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/workout.dart';
import '../../../domain/repositories/workout_repository.dart';

// Events
abstract class WorkoutEvent {}

class LoadWorkouts extends WorkoutEvent {}
class AddWorkout extends WorkoutEvent {
  final Workout workout;
  AddWorkout(this.workout);
}

// States
abstract class WorkoutState {}

class WorkoutInitial extends WorkoutState {}
class WorkoutLoading extends WorkoutState {}
class WorkoutLoaded extends WorkoutState {
  final List<Workout> workouts;
  WorkoutLoaded(this.workouts);
}
class WorkoutError extends WorkoutState {
  final String message;
  WorkoutError(this.message);
}

// BLoC
class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final WorkoutRepository repository;

  WorkoutBloc(this.repository) : super(WorkoutInitial()) {
    on<LoadWorkouts>((event, emit) async {
      emit(WorkoutLoading());
      try {
        final workouts = await repository.getWorkouts();
        emit(WorkoutLoaded(workouts));
      } catch (e) {
        emit(WorkoutError(e.toString()));
      }
    });

    on<AddWorkout>((event, emit) async {
      emit(WorkoutLoading());
      try {
        await repository.addWorkout(event.workout);
        final workouts = await repository.getWorkouts();
        emit(WorkoutLoaded(workouts));
      } catch (e) {
        emit(WorkoutError(e.toString()));
      }
    });
  }
}