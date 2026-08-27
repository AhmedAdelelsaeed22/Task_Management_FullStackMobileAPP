import 'package:flutter/material.dart';
import 'package:task_management/models/task_response.dart';
import 'package:task_management/widgets/buildemptytasks.dart';
import 'package:task_management/widgets/tasks_item.dart';

class TasksList extends StatelessWidget {
  const TasksList({
    super.key,
    required this.tasks,
    required this.completeTask,
    required this.updateTask,
    required this.deleteTask,
    required this.email,
  });

  final List<TaskModel> tasks;
  final Future<void> Function(TaskModel task) completeTask;
  final Future<void> Function(TaskModel task) updateTask;
  final Future<void> Function(int taskId) deleteTask;
  final String email;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const BuildEmptyTasks();
    }
    return ListView.separated(
      itemCount: tasks.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) {
        return const SizedBox(height: 12);
      },
      itemBuilder: (context, index) {
        final TaskModel task = tasks[index];

        return TaskItem(
          task: task,
          completeTask: completeTask,
          updateTask: updateTask,
          deleteTask: deleteTask,
          email: email,
        );
      },
    );
  }
}
