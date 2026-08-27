import 'package:flutter/material.dart';
import 'package:task_management/api/auth/api_refreshtoken.dart';
import 'package:task_management/api/exception/unauthorized.dart';
import 'package:task_management/api/tasks/api_completetask.dart';
import 'package:task_management/api/tasks/api_deletetask.dart';
import 'package:task_management/api/users/api_getuserid.dart';
import 'package:task_management/api/tasks/api_tasks.dart';
import 'package:task_management/models/task_response.dart';
import 'package:task_management/screens/tasks/add_task.dart';
import 'package:task_management/screens/tasks/update_task.dart';
import 'package:task_management/widgets/buildstatisticscard.dart';
import 'package:task_management/widgets/splash.dart';
import 'package:task_management/widgets/tasks_list.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key, required this.email});

  final String email;

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<TaskModel> tasks = [];
  List<TaskModel> filteredTasks = [];

  int userId = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeScreen();
  }

  // ============================================================
  // INITIALIZE SCREEN
  // ============================================================

  Future<void> initializeScreen() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      userId = await getUserIdUsingEmailAddress();

      await loadTasks();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      print('Error initializing screen: $e');
    }
  }

  // ============================================================
  // GET USER ID
  // ============================================================

  Future<int> getUserIdUsingEmailAddress() async {
    final getUserDataUsingId = GetUserIdUsingEmail();

    final int id = await getUserDataUsingId.getUserId(widget.email);

    return id;
  }

  // ============================================================
  // LOAD TASKS
  // ============================================================

  Future<void> loadTasks() async {
    final TasksApi taskApi = TasksApi();

    try {
      final List<TaskModel> loadedTasks = await taskApi.getTasks(userId);

      if (!mounted) return;

      setState(() {
        tasks = loadedTasks;
        filteredTasks = List<TaskModel>.from(loadedTasks);
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      print('Error loading tasks: $e');
    }
  }

  // ============================================================
  // REFRESH TASKS
  // ============================================================

  Future<void> refreshTasks(TaskModel newTask) async {
    if (!mounted) return;

    setState(() {
      tasks.insert(0, newTask);
      filteredTasks.insert(0, newTask);
    });
  }

  void _taskCompleted(TaskModel task) {
    if (!mounted) return;

    setState(() {
      task.statusId = 4;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Task is Completed!')));

    Navigator.pop(context);
  }

  Future<void> completeTask(TaskModel task) async {
    final ApiCompleteTask apiCompleteTask = ApiCompleteTask();
    final ApiRefreshToken apiRefreshToken = ApiRefreshToken();

    // ==========================================================
    // ALREADY COMPLETED
    // ==========================================================

    if (task.statusId == 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task is Already Completed!')),
      );

      return;
    }

    try {
      // ========================================================
      // FIRST REQUEST
      // ========================================================

      final bool success = await apiCompleteTask.completeTask(task.taskId);

      if (success) {
        _taskCompleted(task);
      }
    }
    // ============================================================
    // ACCESS TOKEN EXPIRED
    // ============================================================
    on UnauthorizedException {
      try {
        // --------------------------------------------------------
        // REFRESH TOKEN
        // --------------------------------------------------------

        await apiRefreshToken.refreshToken(widget.email);

        // --------------------------------------------------------
        // RETRY COMPLETE TASK
        // --------------------------------------------------------

        final bool success = await apiCompleteTask.completeTask(task.taskId);

        if (success) {
          _taskCompleted(task);
        }
      } catch (e) {
        print('Refresh token failed: $e');

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session expired. Please login again.')),
        );
      }
    }
    // ============================================================
    // OTHER ERRORS
    // ============================================================
    catch (e) {
      print('Error completing task: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to complete task.')));
    }
  }

  void removeTaskFromList(int taskId) {
    setState(() {
      tasks.removeWhere((task) => task.taskId == taskId);

      filteredTasks.removeWhere((task) => task.taskId == taskId);
    });
  }

  Future<void> deleteTask(int taskId) async {
    final ApiDeleteTask _apiDeleteTask = ApiDeleteTask();
    final ApiRefreshToken _apiRefreshToken = ApiRefreshToken();

    try {
      // ========================================================
      // FIRST REQUEST
      // ========================================================

      final bool success = await _apiDeleteTask.deleteTask(taskId);

      if (success) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("delete Successful")));

        removeTaskFromList(taskId);
        Navigator.pop(context);
      }
    }
    // ============================================================
    // ACCESS TOKEN EXPIRED
    // ============================================================
    on UnauthorizedException {
      try {
        // --------------------------------------------------------
        // REFRESH TOKEN
        // --------------------------------------------------------

        await _apiRefreshToken.refreshToken(widget.email);

        // --------------------------------------------------------
        // RETRY COMPLETE TASK
        // --------------------------------------------------------

        final bool success = await _apiDeleteTask.deleteTask(taskId);

        if (success) {
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("delete Successful")));

          removeTaskFromList(taskId);

          Navigator.pop(context);
        }
      } catch (e) {
        print('Refresh token failed: $e');

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session expired. Please login again.')),
        );
      }
    }
    // ============================================================
    // OTHER ERRORS
    // ============================================================
    catch (e) {
      print('Error deleting task: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to delete task.')));
    }
  }

  Future<void> updatedData(TaskModel task) async {
    final TaskModel? taskData = await Navigator.push<TaskModel>(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateTaskScreen(email: widget.email, task: task),
      ),
    );

    // User pressed back/cancel
    if (taskData == null) {
      return;
    }

    if (!mounted) return;

    setState(() {
      task.title = taskData.title;

      task.description = taskData.description?.isEmpty == true
          ? null
          : taskData.description;

      task.statusId = taskData.statusId;
      task.priorityId = taskData.priorityId;
      task.estimateHours = taskData.estimateHours;
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final completedTasks = tasks.where((task) => task.statusId == 4).length;

    final inProgressTasks = tasks.where((task) => task.statusId == 2).length;

    if (isLoading) {
      return const Splash(message: 'Loading your tasks...');
    }

    return Scaffold(
      // ==========================================================
      // APP BAR
      // ==========================================================
      appBar: AppBar(title: const Text('Task Manager')),

      // ==========================================================
      // FLOATING ACTION BUTTON
      // ==========================================================
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final TaskModel? newTask = await Navigator.push<TaskModel>(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddTaskScreen(email: widget.email, userId: userId),
            ),
          );

          if (newTask != null) {
            refreshTasks(newTask);
          }
        },
        child: const Icon(Icons.add),
      ),

      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // WELCOME
            // ==================================================
            Text('Good morning 👋', style: theme.textTheme.headlineLarge),

            const SizedBox(height: 24),

            // ==================================================
            // SEARCH
            // ==================================================
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: Icon(Icons.search),
              ),

              onChanged: (value) {
                setState(() {
                  filteredTasks = tasks.where((task) {
                    return task.title.toLowerCase().contains(
                      value.toLowerCase(),
                    );
                  }).toList();
                });
              },
            ),
            const SizedBox(height: 24),

            // ==================================================
            // STATISTICS
            // ==================================================
            Row(
              children: [
                Expanded(
                  child: BuildStatisticsCard(
                    title: 'Total',
                    value: tasks.length.toString(),
                    icon: Icons.task_alt,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: BuildStatisticsCard(
                    title: 'Progress',
                    value: inProgressTasks.toString(),
                    icon: Icons.timelapse,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: BuildStatisticsCard(
                    title: 'Done',
                    value: completedTasks.toString(),
                    icon: Icons.check_circle_outline,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // ==================================================
            // TASK HEADER
            // ==================================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Your Tasks', style: theme.textTheme.titleLarge)],
            ),

            const SizedBox(height: 8),

            // ==================================================
            // TASK LIST
            // ==================================================
            TasksList(
              tasks: filteredTasks,
              completeTask: completeTask,
              updateTask: updatedData,
              deleteTask: deleteTask,
              email: widget.email,
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
