import 'package:flutter/material.dart';
import 'ActivityDetailScreen.dart';

class ActivityCard extends StatelessWidget {
  final String title;
  final String category;
  final String description;
  final String time;
  //final String date;
  final DateTime date;
  final String duration;

  const ActivityCard({
    super.key,
    required this.title,
    required this.category,
    required this.description,
    required this.time,
    required this.date,
    required this.duration,
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
              duration: duration,
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
                      description,
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
