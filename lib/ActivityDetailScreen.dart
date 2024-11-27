import 'package:cloud_firestore/cloud_firestore.dart';
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
  final String notes;
  final String activityId; // ID de la actividad en Firebase

  const ActivityDetailScreen({
    super.key,
    required this.title,
    required this.category,
    required this.description,
    required this.time,
    required this.date,
    required this.notes,
    required this.activityId, // Recibir ID de la actividad
  });

  // Función para obtener el Stream de la actividad desde Firestore
  Stream<DocumentSnapshot> _getActivityStream(String activityId) {
    return FirebaseFirestore.instance
        .collection('activities')
        .doc(activityId)
        .snapshots(); // Usamos 'snapshots' para obtener un Stream
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MainAppBar(),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _getActivityStream(
            activityId), // Obtenemos el stream de la actividad
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Actividad no encontrada"));
          }

          // Obtener los datos de la actividad desde el snapshot
          final activityData = snapshot.data!.data() as Map<String, dynamic>;

          final title = activityData['title'] ?? "Sin título";
          final category = activityData['category_id'] ?? "Sin categoría";
          final description = activityData['description'] ?? "Sin descripción";
          final time = DateFormat.jm()
              .format((activityData['date_time'] as Timestamp).toDate());
          final date = (activityData['date_time'] as Timestamp).toDate();
          final notes = activityData['notes'] ?? "Sin notas";

          return SingleChildScrollView(
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
                              _deleteActivity(context);
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
                                    notes: notes,
                                    activityId:
                                        activityId, // Pasar el ID a EditActivity
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
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRowDate("Fecha", date),
                  _buildInfoRow("Hora", time),
                  _buildInfoRow("Categoría", category),
                  const SizedBox(height: 16),
                  const Text(
                    "Descripción",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(description.isEmpty
                      ? "No hay descripción disponible"
                      : description),
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
                    notes.isEmpty ? "No hay notas disponibles" : notes,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Función para eliminar la actividad en Firebase
  Future<void> _deleteActivity(BuildContext context) async {
    try {
      // Confirmación para eliminar la actividad
      bool? confirmDelete = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Eliminar Actividad'),
            content: const Text(
                '¿Estás seguro de que deseas eliminar esta actividad?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Eliminar'),
              ),
            ],
          );
        },
      );

      if (confirmDelete == true) {
        // Eliminar actividad de Firebase
        await FirebaseFirestore.instance
            .collection('activities')
            .doc(activityId)
            .delete();

        // Mostrar mensaje de éxito y navegar hacia atrás
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Actividad eliminada exitosamente')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      // Manejar errores de la eliminación
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar la actividad: $e')),
      );
    }
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
