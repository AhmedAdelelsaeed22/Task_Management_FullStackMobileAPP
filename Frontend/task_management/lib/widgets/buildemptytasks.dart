import 'package:flutter/material.dart';

class BuildEmptyTasks extends StatelessWidget {
  const BuildEmptyTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      child: Column(
        children: [
          const Icon(Icons.task_alt, size: 70, color: Color(0xFF9CA3AF)),

          const SizedBox(height: 16),

          Text('No tasks yet', style: Theme.of(context).textTheme.titleLarge),

          const SizedBox(height: 8),

          Text(
            'Create your first task to get started.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
