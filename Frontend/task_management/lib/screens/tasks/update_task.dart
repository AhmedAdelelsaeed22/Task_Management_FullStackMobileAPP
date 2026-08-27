import 'package:flutter/material.dart';
import 'package:task_management/api/auth/api_refreshtoken.dart';
import 'package:task_management/api/exception/unauthorized.dart';
import 'package:task_management/api/tasks/api_updatetask.dart';
import 'package:task_management/models/task_response.dart';
import 'package:task_management/validation/validators.dart';

class UpdateTaskScreen extends StatefulWidget {
  const UpdateTaskScreen({super.key, required this.email, required this.task});

  final String email;
  final TaskModel task;

  @override
  State<UpdateTaskScreen> createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _estimateHoursController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // ============================================================
  // SELECTED VALUES
  // ============================================================

  int? selectedStatusId;
  int? selectedPriorityId;

  TaskModel? updatedTask;

  @override
  void initState() {
    super.initState();

    _titleController.text = widget.task.title;

    _descriptionController.text = widget.task.description ?? '';

    _estimateHoursController.text = widget.task.estimateHours?.toString() ?? '';

    selectedStatusId = widget.task.statusId;
    selectedPriorityId = widget.task.priorityId;
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _estimateHoursController.dispose();

    super.dispose();
  }

  Future<void> updateTaskApi() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final ApiUpdateTask updateTask = ApiUpdateTask();

    final ApiRefreshToken refreshTokenApi = ApiRefreshToken();

    try {
      // ========================================================
      // FIRST REQUEST
      // ========================================================

      updatedTask = await updateTask.updateTask(
        taskId: widget.task.taskId,
        userId: widget.task.userId,
        statusId: selectedStatusId!,
        priorityId: selectedPriorityId!,
        title: _titleController.text,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        estimateHours: double.tryParse(_estimateHoursController.text),
        creationDate: widget.task.creationDate,
        lastUpdateDate: DateTime.now().toUtc().toIso8601String(),
        completionDate: null,
      );

      Navigator.pop(context, updatedTask);

      print('Task updated successfully');
    }
    // ==========================================================
    // ACCESS TOKEN EXPIRED
    // ==========================================================
    on UnauthorizedException {
      try {
        print('Access token expired. Refreshing...');

        // Refresh tokens
        await refreshTokenApi.refreshToken(widget.email);

        print('Token refreshed successfully');

        // ======================================================
        // RETRY CREATE TASK
        // ======================================================

        updatedTask = await updateTask.updateTask(
          taskId: widget.task.taskId,
          userId: widget.task.userId,
          statusId: selectedStatusId!,
          priorityId: selectedPriorityId!,
          title: _titleController.text,
          description: _descriptionController.text.isEmpty
              ? null
              : _descriptionController.text,
          estimateHours: double.tryParse(_estimateHoursController.text),
          creationDate: widget.task.creationDate,
          lastUpdateDate: DateTime.now().toUtc().toIso8601String(),
          completionDate: null,
        );

        Navigator.pop(context, updatedTask);

        print('Task created successfully after refresh');
      } catch (e) {
        print('Refresh/Create task failed: $e');
      }
    }
    // ==========================================================
    // OTHER ERRORS
    // ==========================================================
    catch (e) {
      print('Create task error: $e');
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // ==========================================================
      // APP BAR
      // ==========================================================
      appBar: AppBar(title: const Text('Update Task')),

      // ==========================================================
      // BODY
      // ==========================================================
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ======================================================
              // TITLE
              // ======================================================
              Text('Update task', style: theme.textTheme.headlineMedium),

              const SizedBox(height: 6),

              Text(
                'Update the information for your task.',
                style: theme.textTheme.bodyMedium,
              ),

              const SizedBox(height: 28),

              // ======================================================
              // TASK TITLE
              // ======================================================
              Text('Task Title', style: theme.textTheme.titleMedium),

              const SizedBox(height: 8),

              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,

                decoration: const InputDecoration(
                  hintText: 'Enter task title',
                  prefixIcon: Icon(Icons.title),
                ),

                validator: Validators.title,
              ),

              const SizedBox(height: 20),

              // ======================================================
              // DESCRIPTION
              // ======================================================
              Text('Description', style: theme.textTheme.titleMedium),

              const SizedBox(height: 8),

              TextFormField(
                controller: _descriptionController,
                maxLines: 5,

                decoration: const InputDecoration(
                  hintText: 'Enter task description',

                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 80),
                    child: Icon(Icons.description_outlined),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ======================================================
              // STATUS + PRIORITY
              // ======================================================
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --------------------------------------------------
                  // STATUS
                  // --------------------------------------------------
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Status', style: theme.textTheme.titleMedium),

                        const SizedBox(height: 8),

                        DropdownButtonFormField<int>(
                          initialValue: selectedStatusId,

                          isExpanded: true,

                          decoration: const InputDecoration(
                            hintText: 'Status',
                            prefixIcon: Icon(Icons.timelapse),
                          ),

                          items: const [
                            DropdownMenuItem(value: 1, child: Text('To Do')),
                            DropdownMenuItem(
                              value: 2,
                              child: Text('In Progress'),
                            ),
                            DropdownMenuItem(
                              value: 3,
                              child: Text('In Review'),
                            ),
                            DropdownMenuItem(
                              value: 4,
                              child: Text('Completed'),
                            ),
                          ],

                          onChanged: (value) {
                            setState(() {
                              selectedStatusId = value;
                            });
                          },

                          validator: (value) {
                            if (value == null) {
                              return 'Select status';
                            }

                            return null;
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // --------------------------------------------------
                  // PRIORITY
                  // --------------------------------------------------
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Priority', style: theme.textTheme.titleMedium),

                        const SizedBox(height: 8),

                        DropdownButtonFormField<int>(
                          initialValue: selectedPriorityId,

                          isExpanded: true,

                          decoration: const InputDecoration(
                            hintText: 'Priority',
                            prefixIcon: Icon(Icons.flag_outlined),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                          ),

                          items: const [
                            DropdownMenuItem(value: 1, child: Text('Low')),
                            DropdownMenuItem(value: 2, child: Text('Medium')),
                            DropdownMenuItem(value: 3, child: Text('High')),
                          ],

                          onChanged: (value) {
                            setState(() {
                              selectedPriorityId = value;
                            });
                          },

                          validator: (value) {
                            if (value == null) {
                              return 'Select priority';
                            }

                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ======================================================
              // ESTIMATE HOURS
              // ======================================================
              Text('Estimate Hours', style: theme.textTheme.titleMedium),

              const SizedBox(height: 8),

              TextFormField(
                controller: _estimateHoursController,

                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),

                decoration: const InputDecoration(
                  hintText: 'e.g. 4.5',
                  prefixIcon: Icon(Icons.access_time_outlined),
                  suffixText: 'hours',
                ),

                validator: Validators.estimateHours,
              ),

              const SizedBox(height: 28),

              // ======================================================
              // CREATE BUTTON
              // ======================================================
              ElevatedButton.icon(
                onPressed: updateTaskApi,
                icon: const Icon(Icons.update),
                label: const Text('Update Task'),
              ),

              const SizedBox(height: 12),

              // ======================================================
              // CANCEL BUTTON
              // ======================================================
              SizedBox(
                width: double.infinity,
                height: 50,

                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  child: const Text('Cancel'),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
