// lib/presentation/pages/home/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/workout/workout_bloc.dart';
import '../stats/stats_page.dart';
import '../workout/add_workout_page.dart';
import '../workout/workout_details_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Add this to the AppBar actions
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatsPage(),
                ),
              );
            },
          ),
        ],
        title: const Text('Fitness Tracker'),
      ),
      body: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is WorkoutError) {
            return Center(child: Text(state.message));
          }
          if (state is WorkoutLoaded) {
            return ListView.builder(
              itemCount: state.workouts.length,
              itemBuilder: (context, index) {
                final workout = state.workouts[index];
                return ListTile(
                  title: Text(workout.name),
                  subtitle: Text('Duration: ${workout.duration} minutes'),
                  trailing: Text(
                    '${workout.exercises.length} exercises',
                  ),
                  // Update the onTap in HomePage's ListTile
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkoutDetailsPage(workout: workout),
                      ),
                    );
                  },
                );
              },
            );
          }
          return const Center(
            child: Text('No workouts found. Add your first workout!'),
          );
        },
      ),
      // Update the FloatingActionButton in home_page.dart
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddWorkoutPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}