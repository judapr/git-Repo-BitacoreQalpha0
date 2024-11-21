import 'package:flutter/material.dart';
import 'ActivityCard.dart';

// Widget que representa una sección de actividades, como "Hoy" o "30 ago"
class ActivitySection extends StatelessWidget {
  final String title;
  final List<ActivityCard> activities;

  const ActivitySection({
    super.key,
    required this.title,
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...activities,
        const SizedBox(height: 24),
      ],
    );
  }
}
