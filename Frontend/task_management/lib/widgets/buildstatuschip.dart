import 'package:flutter/material.dart';

class BuildStatusChip extends StatelessWidget {
  const BuildStatusChip({super.key, required this.statusId});

  final int statusId;

  @override
  Widget build(BuildContext context) {
    String status;
    IconData icon;

    if (statusId == 1) {
      status = 'To Do';
      icon = Icons.radio_button_unchecked;
    } else if (statusId == 2) {
      status = 'In Progress';
      icon = Icons.timelapse;
    } else if (statusId == 3) {
      status = 'In Review';
      icon = Icons.rate_review_outlined;
    } else if (statusId == 4) {
      status = 'Completed';
      icon = Icons.check_circle_outline;
    } else {
      status = 'Pending';
      icon = Icons.schedule;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: const Color(0xFF6C63FF)),

          const SizedBox(width: 5),

          Text(
            status,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }
}
