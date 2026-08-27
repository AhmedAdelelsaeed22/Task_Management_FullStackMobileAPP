import 'package:flutter/material.dart';
import 'package:task_management/models/task_response.dart';
import 'package:task_management/screens/tasks/task_details.dart';
import 'package:task_management/widgets/buildprioritychip.dart';
import 'package:task_management/widgets/buildstatuschip.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.task,
    required this.completeTask,
    required this.updateTask,
    required this.deleteTask,
    required this.email,
  });

  final TaskModel task;
  final Future<void> Function(TaskModel task) completeTask;
  final Future<void> Function(TaskModel task) updateTask;
  final Future<void> Function(int taskId) deleteTask;
  final String email;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailsScreen(
                task: widget.task,
                completeTask: widget.completeTask,
                updateTask: widget.updateTask,
                deleteTask: widget.deleteTask,
              ),
            ),
          );
        },

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ------------------------------------------------
              // Title + More button
              // ------------------------------------------------
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.task.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ------------------------------------------------
              // Status + Priority
              // ------------------------------------------------
              Row(
                children: [
                  BuildStatusChip(statusId: widget.task.statusId),

                  const SizedBox(width: 8),

                  BuildPriorityChip(priorityId: widget.task.priorityId),
                ],
              ),

              const SizedBox(height: 14),

              const Divider(height: 1),

              const SizedBox(height: 12),

              // ------------------------------------------------
              // Date
              // ------------------------------------------------
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: Color(0xFF6B7280),
                  ),

                  const SizedBox(width: 6),

                  Text(
                    'Created ${widget.task.creationDate}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),

                  const Spacer(),

                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Color(0xFF9CA3AF),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
