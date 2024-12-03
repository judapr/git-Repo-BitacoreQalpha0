import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'MainAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ActivitySection.dart';
import 'ActivityCard.dart';
import 'package:intl/intl.dart';
import 'AboutUsScreen.dart';

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
  String formatDateWithContext(DateTime date) {
    initializeDateFormatting('es_ES', null);

    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return "Hoy";
    } else if (difference == 1) {
      return "Ayer";
    } else if (difference == 2) {
      return "Antier";
    } else if (difference > 2 && difference <= 7) {
      return "Hace $difference días";
    } else {
      return DateFormat("d MMM',' yyyy", 'es_ES').format(date);
    }
  }

  // Función para obtener los datos del usuario desde Firestore
  Future<Map<String, dynamic>> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return doc.data() as Map<String, dynamic>;
    } else {
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MainAppBar(),
      drawer: Drawer(
        child: FutureBuilder<Map<String, dynamic>>(
          future: getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text("Error al cargar los datos"));
            }

            Map<String, dynamic> user = snapshot.data ?? {};

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(user['name'] ?? 'Nombre del Usuario'),
                  accountEmail: Text(user['email'] ?? 'correo@ejemplo.com'),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      (user['name'] != null && user['name']!.isNotEmpty)
                          ? user['name']![0]
                          : 'N',
                      style: const TextStyle(fontSize: 24, color: Colors.black),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('About Us'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AboutUsScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Cerrar Sesión'),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            );
          },
        ),
      ),
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
          final groupedActivities = <DateTime, List<Map<String, dynamic>>>{};
          for (var activity in activities) {
            final date = (activity['date_time'] as Timestamp).toDate();
            final onlyDate = DateTime(date.year, date.month, date.day);

            groupedActivities.putIfAbsent(onlyDate, () => []);
            groupedActivities[onlyDate]!.add(activity);
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
                    title: formatDateWithContext(date), // Formato síncrono aquí
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
