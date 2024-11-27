import 'package:flutter/material.dart';
import 'ActivityDetailScreen.dart';

class ActivityCard extends StatelessWidget {
  final String title;
  final String category;
  final String description;
  final String time;
  final DateTime date;
  final String notes;
  final String activityId; // ID de la actividad en Firebase

  const ActivityCard({
    super.key,
    required this.title,
    required this.category,
    required this.description,
    required this.time,
    required this.date,
    required this.notes,
    required this.activityId, // Recibir el ID de la actividad
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActivityDetailScreen(
              title: title,
              category: category,
              description: description,
              time: time,
              date: date,
              notes: notes,
              activityId:
                  activityId, // Pasamos el activityId aquí para la edición
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$title ($category)",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description.isEmpty
                          ? "No hay descripción disponible"
                          : description,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
