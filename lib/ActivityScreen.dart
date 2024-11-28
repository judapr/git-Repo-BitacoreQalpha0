import 'MainAppBar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ActivitySection.dart';
import 'ActivityCard.dart';
import 'AddActivity.dart';
import 'package:intl/intl.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  late Stream<List<Map<String, dynamic>>> activitiesStream;

  @override
  void initState() {
    super.initState();
    activitiesStream = fetchUserActivities();
  }

  // Función para obtener las actividades del usuario desde Firestore en tiempo real
  Stream<List<Map<String, dynamic>>> fetchUserActivities() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("No user logged in");
    }

    // Devuelve un Stream de actividades que se actualiza en tiempo real
    return FirebaseFirestore.instance
        .collection('activities')
        .where('user_id', isEqualTo: user.uid)
        .orderBy('date_time', descending: true)
        .snapshots()
        .asyncMap((querySnapshot) async {
      final activities = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Agregar el ID del documento
        return data;
      }).toList();

      // Crear una lista de IDs únicos de categorías
      final categoryIds = activities
          .map((activity) => activity['category_id'] as String?)
          .where((id) => id != null)
          .toSet();

      // Consultar nombres de las categorías en Firestore
      final categoryNames = <String, String>{};
      if (categoryIds.isNotEmpty) {
        final categoriesQuery = await FirebaseFirestore.instance
            .collection('categories')
            .where(FieldPath.documentId, whereIn: categoryIds.toList())
            .get();

        for (var doc in categoriesQuery.docs) {
          categoryNames[doc.id] = doc.data()['name'] as String;
        }
      }

      // Reemplazar `category_id` por el nombre real en las actividades
      for (var activity in activities) {
        final categoryId = activity['category_id'] as String?;
        activity['category_name'] =
            categoryNames[categoryId] ?? "Categoría desconocida";
      }

      return activities;
    });
  }

  // Función para formatear la fecha
  String formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('d MMMM yyyy', 'es_ES');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainAppBar(),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: fetchUserActivities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final activities = snapshot.data ?? [];

          if (activities.isEmpty) {
            return const Center(child: Text("No hay actividades registradas"));
          }

          // Agrupar actividades por fecha
          final groupedActivities = <String, List<Map<String, dynamic>>>{};
          for (var activity in activities) {
            final date = (activity['date_time'] as Timestamp).toDate();
            final formattedDate = "${date.day}-${date.month}-${date.year}";

            groupedActivities.putIfAbsent(formattedDate, () => []);
            groupedActivities[formattedDate]!.add(activity);
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: groupedActivities.entries.map((entry) {
                  final date = entry.key;
                  final activityList = entry.value;

                  return ActivitySection(
                    title: date,
                    activities: activityList.map((activity) {
                      final String description =
                          (activity['description'] ?? "").trim();
                      final String notes = (activity['notes'] ?? "").trim();
                      final String title = (activity['title'] ?? "").trim();
                      final String categoryName =
                          (activity['category_name'] ?? "").trim();
                      return ActivityCard(
                        title: title.isEmpty
                            ? "No hay título" // Valor predeterminado
                            : title,
                        category: categoryName.isEmpty
                            ? "No hay categoría" // Valor predeterminado
                            : categoryName,
                        description: description.isEmpty
                            ? "No hay descripción disponible"
                            : description,
                        time: TimeOfDay.fromDateTime(
                          (activity['date_time'] as Timestamp).toDate(),
                        ).format(context),
                        date: (activity['date_time'] as Timestamp).toDate(),
                        notes: notes.isEmpty
                            ? "Sin notas"
                            : notes, // Manejo seguro de notas
                        activityId: activity['id'], // ID del documento
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
