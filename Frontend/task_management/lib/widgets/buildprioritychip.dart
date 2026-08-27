import 'package:flutter/material.dart';

class BuildPriorityChip extends StatelessWidget {
  const BuildPriorityChip({super.key, required this.priorityId});

  final int priorityId;

  @override
  Widget build(BuildContext context) {
    String priority;

    if (priorityId == 1) {
      priority = 'Low';
    } else if (priorityId == 2) {
      priority = 'Medium';
    } else if (priorityId == 3) {
      priority = 'High';
    } else {
      priority = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$priority Priority',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF3B82F6),
        ),
      ),
    );
  }
}
