import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Color(0xFF6C63FF)),

            const SizedBox(height: 24),

            Text(message, style: theme.textTheme.titleLarge),

            const SizedBox(height: 8),

            Text('Please wait', style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
