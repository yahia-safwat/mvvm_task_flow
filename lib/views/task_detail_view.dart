import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../viewmodels/task_view_model.dart';
import 'add_edit_task_view.dart';

class TaskDetailView extends StatelessWidget {
  final Task task;

  const TaskDetailView({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditTaskView(task: task),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Task'),
                  content: const Text(
                    'Are you sure you want to delete this task?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                if (context.mounted) {
                  await context.read<TaskViewModel>().deleteTask(task.id);
                  if (context.mounted) Navigator.pop(context);
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: task.isCompleted ? Colors.green[50] : Colors.blue[50],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                task.isCompleted ? 'COMPLETED' : 'IN PROGRESS',
                style: TextStyle(
                  color: task.isCompleted
                      ? Colors.green[700]
                      : Colors.blue[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              task.description.isEmpty
                  ? 'No description provided.'
                  : task.description,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<TaskViewModel>(
            builder: (context, viewModel, child) {
              return ElevatedButton(
                onPressed: () => viewModel.toggleTaskStatus(task.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: task.isCompleted
                      ? Colors.grey[200]
                      : Theme.of(context).colorScheme.primary,
                  foregroundColor: task.isCompleted
                      ? Colors.black87
                      : Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  task.isCompleted ? 'Mark as Incomplete' : 'Mark as Completed',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
