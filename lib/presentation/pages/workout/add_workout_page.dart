// lib/presentation/pages/workout/add_workout_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/workout.dart';
import '../../../domain/entities/exercise.dart';
import '../../blocs/workout/workout_bloc.dart';
import '../../widgets/add_exercise_dialog.dart';

class AddWorkoutPage extends StatefulWidget {
  const AddWorkoutPage({super.key});

  @override
  State<AddWorkoutPage> createState() => _AddWorkoutPageState();
}

class _AddWorkoutPageState extends State<AddWorkoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  final List<Exercise> _exercises = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Workout'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Workout Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter workout name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _durationController,
              decoration: const InputDecoration(
                labelText: 'Duration (minutes)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter duration';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addExercise,
              child: const Text('Add Exercise'),
            ),
            const SizedBox(height: 16),
            ..._buildExerciseList(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveWorkout,
              child: const Text('Save Workout'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildExerciseList() {
    return _exercises.map((exercise) {
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          title: Text(exercise.name),
          subtitle: Text('${exercise.sets} sets × ${exercise.reps} reps'),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => setState(() => _exercises.remove(exercise)),
          ),
        ),
      );
    }).toList();
  }

  void _addExercise() async {
    final exercise = await showDialog<Exercise>(
      context: context,
      builder: (context) => const AddExerciseDialog(),
    );
    if (exercise != null) {
      setState(() => _exercises.add(exercise));
    }
  }

  void _saveWorkout() {
    if (_formKey.currentState!.validate()) {
      final workout = Workout(
        id: DateTime.now().toString(),
        name: _nameController.text,
        date: DateTime.now(),
        exercises: _exercises,
        duration: int.parse(_durationController.text),
      );

      context.read<WorkoutBloc>().add(AddWorkout(workout));
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    super.dispose();
  }
}