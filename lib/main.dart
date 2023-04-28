import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/bloc/task_bloc/task_bloc.dart';
import 'package:my_flutter_app/ui/screens/task_screen.dart';
import 'data/repository/task_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => TaskRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => TaskBloc(
              taskRepository: RepositoryProvider.of<TaskRepository>(context),
            ),
          ),
        ],
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: TaskScreen(),
        ),
      ),
    );
  }
}
