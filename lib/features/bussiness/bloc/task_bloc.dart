import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../data/repository/task_repository.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final _debounceDuration = Duration(milliseconds: 500); // Debounce time
  final _searchSubject = BehaviorSubject<String>();
  final TaskRepository repository;

  TaskBloc(this.repository) : super(TaskInitial()) {
    // Debounce search queries
    _searchSubject.stream.debounceTime(_debounceDuration).listen((query) {
      add(TaskSearch(query: query));
    });

    // Handle different events
    on<TaskSearch>(_onSearch);
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
  }

  // Handle loading tasks (both remote and local)
  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await repository.getTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError('Failed to load tasks'));
    }
  }

  // Handle adding a new task (both remote and local)
  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    try {
      await repository.createTask(event.task);
      add(LoadTasks());  // Reload tasks after creation
    } catch (e) {
      emit(TaskError('Failed to add task'));
    }
  }

  // Handle updating an existing task (both remote and local)
  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    try {
      await repository.updateTask(event.task);
      add(LoadTasks());  // Reload tasks after update
    } catch (e) {
      emit(TaskError('Failed to update task'));
    }
  }

  // Handle deleting a task (both remote and local)
  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try {
      await repository.deleteTask(event.taskId);
      add(LoadTasks());  // Reload tasks after deletion
    } catch (e) {
      emit(TaskError('Failed to delete task'));
    }
  }

  // Handle search functionality
  void _onSearch(TaskSearch event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentTasks = (state as TaskLoaded).tasks;
      final filteredTasks = currentTasks
          .where((task) => task.title.toLowerCase().contains(event.query.toLowerCase()))
          .toList();

      emit(TaskLoaded(filteredTasks));
    }
  }

  // Method to trigger search query
  void search(String query) {
    _searchSubject.add(query);
  }

  // Dispose of resources
  void dispose() {
    _searchSubject.close();
  }
}

