import 'MainAppBar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'EditActivity.dart';

class ActivityDetailScreen extends StatelessWidget {
  final String title;
  final String category;
  final String description;
  final String time;
  final DateTime date;
  //final String date;
  final String duration;

  const ActivityDetailScreen({
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MainAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // Acción para eliminar actividad
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditActivity(
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
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildInfoRowDate("Fecha", date),
              _buildInfoRow("Hora", time),
              _buildInfoRow("Duración", duration),
              _buildInfoRow("Categoría", category),
              const SizedBox(height: 16),
              const Text(
                "Descripción",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(description),
              const SizedBox(height: 16),
              const Text(
                "Imágenes",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildImagePlaceholder(),
                  const SizedBox(width: 8),
                  _buildImagePlaceholder(),
                  const SizedBox(width: 8),
                  _buildImagePlaceholder(),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "Notas",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildInfoRowDate(String label, DateTime value) {
    String formattedDate = DateFormat('d \'/\' MMM \'/\' y').format(value);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(formattedDate),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 80,
      height: 80,
      color: Colors.grey[300],
      child: Icon(Icons.image, color: Colors.grey[600]),
    );
  }
}
