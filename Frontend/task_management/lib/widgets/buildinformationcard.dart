import 'package:flutter/material.dart';
import 'package:task_management/widgets/buildinformationitem.dart';

class Buildinformationcard extends StatelessWidget {
  const Buildinformationcard({
    super.key,
    required this.fullName,
    required this.userName,
    required this.email,
    required this.password,
    required this.jobTitle,
  });

  final String fullName;
  final String userName;
  final String email;
  final String password;
  final String? jobTitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Personal Information', style: theme.textTheme.titleLarge),

            const SizedBox(height: 20),

            Buildinformationitem(
              icon: Icons.person_outline,
              title: 'Full Name',
              value: fullName,
            ),

            const Divider(height: 28),

            Buildinformationitem(
              icon: Icons.alternate_email,
              title: 'Username',
              value: userName,
            ),

            const Divider(height: 28),

            Buildinformationitem(
              icon: Icons.email_outlined,
              title: 'Email Address',
              value: email,
            ),

            const Divider(height: 28),

            Buildinformationitem(
              icon: Icons.password,
              title: 'Password',
              value: password,
            ),

            const Divider(height: 28),

            Buildinformationitem(
              icon: Icons.work_outline,
              title: 'Job Title',
              value: jobTitle!,
            ),
          ],
        ),
      ),
    );
  }
}
