// lib/presentation/pages/stats/stats_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/workout.dart';
import '../../blocs/workout/workout_bloc.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Stats'),
      ),
      body: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutLoaded) {
            final workouts = state.workouts;
            final totalWorkouts = workouts.length;
            final totalDuration = workouts.fold<int>(
              0,
              (sum, workout) => sum + workout.duration,
            );
            final totalExercises = workouts.fold<int>(
              0,
              (sum, workout) => sum + workout.exercises.length,
            );

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatCard(
                    'Total Workouts',
                    totalWorkouts.toString(),
                    Icons.fitness_center,
                  ),
                  const SizedBox(height: 16),
                  _buildStatCard(
                    'Total Time',
                    '$totalDuration minutes',
                    Icons.timer,
                  ),
                  const SizedBox(height: 16),
                  _buildStatCard(
                    'Total Exercises',
                    totalExercises.toString(),
                    Icons.list_alt,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Recent Workouts',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _buildRecentWorkoutsList(workouts),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentWorkoutsList(List<Workout> workouts) {
    final sortedWorkouts = List.from(workouts)
      ..sort((a, b) => b.date.compareTo(a.date));
    final recentWorkouts = sortedWorkouts.take(5).toList();

    return ListView.builder(
      itemCount: recentWorkouts.length,
      itemBuilder: (context, index) {
        final workout = recentWorkouts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(workout.name),
            subtitle: Text(
              '${workout.date.toString().split(' ')[0]} - ${workout.duration} min',
            ),
            trailing: Text('${workout.exercises.length} exercises'),
          ),
        );
      },
    );
  }
}