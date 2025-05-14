import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks/features/data/datasource/remote/task_api_service.dart';

import 'features/bussiness/bloc/task_bloc.dart';
import 'features/bussiness/bloc/task_event.dart';
import 'features/data/datasource/local/task_db_helper.dart';
import 'features/data/repository/task_repository.dart';
import 'features/presentation/screens/task_list_screen.dart';


void main() {
  //final dbHelper = TaskDbHelper();
  final taskRepository = TaskRepository(
    TaskDbHelper(), // Local DB helper
    TaskRemoteDataSource(), // Remote API data source
  );

  runApp(MultiProvider(
      providers: [
        Provider<TaskBloc>(
          create: (_) => TaskBloc(taskRepository)..add(LoadTasks()),
          dispose: (_, bloc) => bloc.dispose(),
        )],
      child: MyApp(repository: taskRepository)));
}

class MyApp extends StatelessWidget {
  final TaskRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task CRUD App',
      theme: ThemeData(
        primaryColor: const Color(0xFF3F51B5),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF3F51B5),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF3F51B5),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: Color(0xFF212121)),
          bodySmall: TextStyle(color: Color(0xFF757575)),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3F51B5),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Color(0xFF3F51B5),
          contentTextStyle: TextStyle(color: Colors.white),
        ),
      ),
      home:
         const TaskListScreen(),

    );
  }
}
