import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/features/presentation/screens/task_form_screen.dart';
import 'package:tasks/features/presentation/screens/task_search_delegate.dart';
import '../../bussiness/bloc/task_bloc.dart';
import '../../bussiness/bloc/task_event.dart';
import '../../bussiness/bloc/task_state.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text('My Tasks'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                await showSearch(
                  context: context,
                  delegate: TaskSearchDelegate(),
                );
                context.read<TaskBloc>().add(LoadTasks()); // defined separately
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            final tasks = state.tasks;

            if (tasks.isEmpty) {
              return const Center(child: Text('No tasks available.'));
            }

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                return Dismissible(
                    key: Key(task.id.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) {
                      context.read<TaskBloc>().add(DeleteTask(task.id!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Task deleted")),
                      );
                    },

                  child: ListTile(
                    tileColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Chip(
                          label: Text(task.priority),
                          backgroundColor: getPriorityColor(task.priority),
                          labelStyle: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(task.description),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.date_range, size: 30, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text(
                              task.createdDate.split('T')[0],
                              style: const TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            const SizedBox(width: 16),
                            Chip(
                              label: Text(task.status),
                              backgroundColor: getStatusColor(task.status),
                              labelStyle: const TextStyle(color: Colors.white),
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<TaskBloc>(),
                            child: TaskFormScreen(task: task),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (state is TaskError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<TaskBloc>(),
                child: const TaskFormScreen(),
              ),
            ),
          );
        },
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}
Color getPriorityColor(String priority) {
  switch (priority) {
    case 'High':
      return Colors.red;
    case 'Medium':
      return Colors.orange;
    case 'Low':
      return Colors.green;
    default:
      return Colors.grey;
  }
}

Color getStatusColor(String status) {
  switch (status) {
    case 'Pending':
      return Colors.amber;
    case 'Completed':
      return Colors.green;
    default:
      return Colors.grey;
  }
}

