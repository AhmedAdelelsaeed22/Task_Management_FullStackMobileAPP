import 'package:flutter/material.dart';

class BuildStatisticsCard extends StatelessWidget {
  const BuildStatisticsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Icon(icon, color: const Color(0xFF6C63FF), size: 24),

            const SizedBox(height: 10),

            Text(value, style: Theme.of(context).textTheme.headlineMedium),

            const SizedBox(height: 2),

            Text(title, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
