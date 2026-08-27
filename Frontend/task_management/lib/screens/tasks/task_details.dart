import 'package:flutter/material.dart';

import 'package:task_management/models/task_response.dart';
import 'package:task_management/widgets/buildInfoRow.dart';
import 'package:task_management/widgets/buildprioritychip.dart';
import 'package:task_management/widgets/buildstatuschip.dart';

class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({
    super.key,
    required this.task,
    required this.completeTask,
    required this.updateTask,
    required this.deleteTask,
  });

  final TaskModel task;
  final Future<void> Function(TaskModel task) completeTask;
  final Future<void> Function(TaskModel task) updateTask;
  final Future<void> Function(int taskId) deleteTask;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // ============================================================
      // APP BAR
      // ============================================================
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            onPressed: () {
              updateTask(task);
            },
            icon: const Icon(Icons.edit_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),

      // ============================================================
      // BODY
      // ============================================================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ======================================================
            // TASK TITLE
            // ======================================================
            Text(task.title, style: theme.textTheme.headlineMedium),

            const SizedBox(height: 12),

            // ======================================================
            // STATUS + PRIORITY
            // ======================================================
            Row(
              children: [
                BuildStatusChip(statusId: task.statusId),

                const SizedBox(width: 8),

                BuildPriorityChip(priorityId: task.priorityId),
              ],
            ),

            const SizedBox(height: 28),

            // ======================================================
            // DESCRIPTION
            // ======================================================
            Text('Description', style: theme.textTheme.titleLarge),

            const SizedBox(height: 10),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Text(
                  task.description.toString(),
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ======================================================
            // TASK INFORMATION
            // ======================================================
            Text('Task Information', style: theme.textTheme.titleLarge),

            const SizedBox(height: 12),

            Card(
              child: Column(
                children: [
                  BuildInfoRow(
                    icon: Icons.access_time,
                    title: 'Estimate',
                    value: task.estimateHours.toString(),
                  ),

                  const Divider(height: 1),

                  BuildInfoRow(
                    icon: Icons.calendar_today_outlined,
                    title: 'Created',
                    value: task.creationDate,
                  ),

                  const Divider(height: 1),

                  BuildInfoRow(
                    icon: Icons.event_outlined,
                    title: 'Due Date',
                    value: task.lastUpdateDate.toString(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ======================================================
            // ACTION BUTTONS
            // ======================================================
            ElevatedButton.icon(
              onPressed: () {
                completeTask(task);
              },
              icon: const Icon(Icons.check),
              label: const Text('Mark as Completed'),
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: () {
                deleteTask(task.taskId);
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete Task'),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
