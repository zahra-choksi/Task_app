import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bussiness/bloc/task_bloc.dart';
import '../../bussiness/bloc/task_event.dart';
import '../../data/model/task_model.dart';


class TaskFormScreen extends StatefulWidget {
  final Task? task;

  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  String _status = 'Pending';
  String _priority = 'Low';

  @override
  void initState() {
    super.initState();
    _title = widget.task?.title ?? '';
    _description = widget.task?.description ?? '';
    _status = widget.task?.status ?? 'Pending';
    _priority = widget.task?.priority ?? 'Low';
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final now = DateTime.now().toIso8601String();
      final isEdit = widget.task != null;

      final task = Task(
        id: isEdit ? widget.task!.id : DateTime.now().millisecondsSinceEpoch.toString(),
        title: _title,
        description: _description,
        status: _status,
        priority: _priority,
        createdDate: widget.task?.createdDate ?? now,
      );

      //final isEdit = widget.task != null;

      if (isEdit) {
        context.read<TaskBloc>().add(UpdateTask(task));
      } else {
        context.read<TaskBloc>().add(AddTask(task));
      }

      // ✅ Show snackbar before popping the screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEdit ? 'Task updated successfully' : 'Task added successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.task != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Task' : 'Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:   Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: _title,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.title),
                  ),
                  validator: (value) => value!.isEmpty ? 'Enter a title' : null,
                  onSaved: (value) => _title = value!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _description,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.description),
                  ),
                  maxLines: 3,
                  validator: (value) => value!.isEmpty ? 'Enter a description' : null,
                  onSaved: (value) => _description = value!,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.flag),
                  ),
                  items: ['Pending', 'Completed']
                      .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  ))
                      .toList(),
                  onChanged: (val) => setState(() => _status = val!),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _priority,
                  decoration: InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.priority_high),
                  ),
                  items: ['Low', 'Medium', 'High']
                      .map((priority) => DropdownMenuItem(
                    value: priority,
                    child: Text(priority),
                  ))
                      .toList(),
                  onChanged: (val) => setState(() => _priority = val!),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle_outline),
                    label: Text(widget.task == null ? 'Add Task' : 'Update Task'),
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}
