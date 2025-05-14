import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bussiness/bloc/task_bloc.dart';
import '../../bussiness/bloc/task_event.dart';
import '../../bussiness/bloc/task_state.dart';


class TaskSearchDelegate extends SearchDelegate {
  TaskSearchDelegate();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [

      IconButton(

        icon: const Icon(Icons.clear,),
        onPressed: () {
          query = '';
          context.read<TaskBloc>().add(LoadTasks());// defined separately
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(

      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  // task_search_delegate.dart
  @override
  Widget buildResults(BuildContext context) {
    // Dispatch SearchTasks event to BLoC
    context.read<TaskBloc>().add(TaskSearch(query: query));

    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TaskLoaded) {
          final tasks = state.tasks;
          if (tasks.isEmpty) {
            return const Center(child: Text('No results found.'));
          }

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                title: Text(task.title),
                subtitle: Text(task.description),
                trailing: Text(task.priority),
                onTap: () {
                  // Handle task tap
                },
              );
            },
          );
        } else if (state is TaskError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Dispatch SearchTasks event to BLoC
    context.read<TaskBloc>().add(TaskSearch(query: query));

    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TaskLoaded) {
          final tasks = state.tasks;
          if (tasks.isEmpty) {
            return const Center(child: Text('No suggestions.'));
          }

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                title: Text(task.title),
                subtitle: Text(task.description),
                trailing: Text(task.priority),
                onTap: () {
                  // Handle task tap
                },
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

}

