import 'package:flutter/material.dart';

class Buildprofileheader extends StatelessWidget {
  const Buildprofileheader({
    super.key,
    required this.fullName,
    required this.userName,
    required this.jobTitle,
  });

  final String fullName;
  final String userName;
  final String? jobTitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile image
            Stack(
              children: [
                CircleAvatar(
                  radius: 52,
                  backgroundColor: theme.colorScheme.primary.withValues(
                    alpha: 0.12,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 55,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              fullName,
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 4),

            Text(
              userName,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                jobTitle!,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
