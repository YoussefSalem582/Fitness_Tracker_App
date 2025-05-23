import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'presentation/blocs/workout/workout_bloc.dart';
import 'data/repositories/workout_repository_impl.dart';
import 'presentation/pages/main/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const FitnessTrackerApp());
}

class FitnessTrackerApp extends StatelessWidget {
  const FitnessTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final workoutRepository = WorkoutRepositoryImpl();

    return MaterialApp(
      title: 'Fitness Tracker',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => WorkoutBloc(workoutRepository)),
        ],
        child: const MainPage(),
      ),
    );
  }
}
