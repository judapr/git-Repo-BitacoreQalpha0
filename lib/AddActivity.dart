import 'MainAppBar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddActivity extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  //final TextEditingController durationController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  AddActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const MainAppBar(
          showAddActivityButton: false,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
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
                      ],
                    ),
                    const Text(
                      "Agregar Actividad",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Nombre, Fecha y Hora son obligatorias.",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField("Título*", titleController),
                    _buildDatePicker(context),
                    _buildTimePicker(context),
                    //_buildTextField("Duración", durationController),
                    _buildTextField("Categoría", categoryController),
                    const SizedBox(height: 16),
                    const Text(
                      "Descripción",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _buildTextField("Descripción", descriptionController,
                        maxLines: 4),
                    const SizedBox(height: 16),
                    const Text(
                      "Imágenes",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildImagePlaceholder(),
                        const SizedBox(width: 8),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Notas",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    _buildTextField("Notas", notesController, maxLines: 4),
                    // Agrega un espacio en blanco debajo del contenido
                    const SizedBox(height: 65), // Altura del espacio en blanco
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.all(15.0), // Espacio alrededor del botón

              child: Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _saveActivity(context);
                      },
                      label: const Text("Guardar Actividad"),
                      icon: const Icon(Icons.save),
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 14,
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.grey[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _selectDate(context);
      },
      child: AbsorbPointer(
        child: _buildTextField(
            "Fecha*",
            TextEditingController(
                text:
                    "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}")),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      selectedDate = pickedDate;
    }
  }

  Widget _buildTimePicker(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _selectTime(context);
      },
      child: AbsorbPointer(
        child: _buildTextField("Hora*", timeController),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      // Formato de hora
      String formattedTime = pickedTime.format(context);
      timeController.text = formattedTime;
    }
  }

  void _saveActivity(BuildContext context) async {
    // Validar campos obligatorios
    if (titleController.text.isEmpty) {
      _showErrorSnackBar(context, 'El título es obligatorio.');
      return;
    }

    if (timeController.text.isEmpty) {
      _showErrorSnackBar(context, 'La hora es obligatoria.');
      return;
    }

    try {
      // Combinar fecha y hora
      String dateText =
          "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

      // Convertir la hora al formato 24 horas
      var timeOfDay = TimeOfDay(
        hour: int.parse(timeController.text.split(":")[0]),
        minute: int.parse(timeController.text.split(":")[1].split(" ")[0]),
      );

      if (timeController.text.contains("PM") && timeOfDay.hour < 12) {
        timeOfDay = timeOfDay.replacing(hour: timeOfDay.hour + 12);
      } else if (timeController.text.contains("AM") && timeOfDay.hour == 12) {
        timeOfDay = timeOfDay.replacing(hour: 0);
      }

      String timeText =
          "${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}";

      // Formar el DateTime
      String dateTimeString = "$dateText $timeText";
      DateTime combinedDateTime = DateTime.parse(dateTimeString);

      // Obtener UID del usuario actual
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showErrorSnackBar(context, 'Usuario no autenticado.');
        return;
      }

      // Preparar datos de la actividad
      Map<String, dynamic> activityData = {
        "title": titleController.text,
        "category": categoryController.text,
        "description": descriptionController.text,
        "notes": notesController.text,
        "date_time": combinedDateTime.toIso8601String(), // Guardar como ISO8601
        "done_by": user.uid, // UID del usuario actual
        "created_at": FieldValue.serverTimestamp(), // Marca de tiempo
      };

      // Guardar en Firestore
      await FirebaseFirestore.instance
          .collection("activities")
          .add(activityData);

      /*
      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Actividad guardada: ${titleController.text}')),
      );*/

      // Mostrar mensaje de éxito en un popup (Dialog)
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Actividad Guardada"),
            content: const Text("La actividad se ha guardado exitosamente."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  // Cerrar el popup
                  Navigator.of(context).pop();

                  // Regresar a la vista de actividades (puedes reemplazar esto con tu ruta específica)
                  Navigator.pop(context); // Regresa a la pantalla anterior
                },
              ),
            ],
          );
        },
      );

      // Limpiar los campos
      titleController.clear();
      categoryController.clear();
      descriptionController.clear();
      notesController.clear();
      timeController.clear();
    } catch (e) {
      _showErrorSnackBar(context, 'Error al guardar la actividad: $e');
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 165,
      height: 165,
      color: Colors.grey[300],
      child: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.add, color: Colors.grey),
      ),
    );
  }
}
