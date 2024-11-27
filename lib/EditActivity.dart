import 'package:cloud_firestore/cloud_firestore.dart';
import 'MainAppBar.dart';
import 'package:flutter/material.dart';

class EditActivity extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController categoryController;
  final TextEditingController descriptionController;
  final TextEditingController timeController;
  DateTime selectedDate;
  final TextEditingController notesController;
  final String activityId; // ID del documento de la actividad a editar

  EditActivity({
    super.key,
    required String title,
    required String category,
    required String description,
    required String time,
    required DateTime date,
    required String notes,
    required this.activityId, // Recibir el ID de la actividad
  })  : titleController = TextEditingController(text: title),
        categoryController = TextEditingController(text: category),
        descriptionController = TextEditingController(text: description),
        timeController = TextEditingController(text: time),
        notesController = TextEditingController(text: notes),
        selectedDate = date;

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
                    "Editar Actividad",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField("Título*", titleController),
                  _buildDatePicker(context),
                  _buildTimePicker(context),

                  _buildTextField("Categoría", categoryController),
                  const SizedBox(height: 16),
                  const Text(
                    "Descripción",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField("Descripción", descriptionController,
                      maxLines: 4),
                  const SizedBox(height: 16),
                  const Text(
                    "Imágenes",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      _buildImagePlaceholder(),
                      const SizedBox(width: 8),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Notas",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 8),
                  // _buildTextField("Descripción", descriptionController,
                  //  maxLines: 4),
                  _buildTextField("Notas", notesController, maxLines: 4),
                  const SizedBox(height: 8),

                  const SizedBox(height: 65), // Espacio en blanco
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      _saveChanges(context);
                    },
                    label: const Text("Guardar Cambios"),
                    icon: const Icon(Icons.save),
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 14),
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
      ),
    );
  }

  // Función para actualizar la actividad en Firebase
  Future<void> _saveChanges(BuildContext context) async {
    try {
      // Obtener la referencia al documento de la actividad en Firebase
      final activityRef =
          FirebaseFirestore.instance.collection('activities').doc(activityId);

      // Actualizar los campos en el documento
      await activityRef.update({
        'title': titleController.text,
        'category': categoryController.text,
        'description': descriptionController.text,
        'notes': notesController.text,
        'date_time':
            Timestamp.fromDate(selectedDate), // Actualizar fecha y hora
        'time': timeController.text, // Actualizar hora
      });

      // Mostrar mensaje de éxito y navegar hacia atrás
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Actividad actualizada exitosamente')),
      );
      Navigator.pop(context);
    } catch (e) {
      // Manejar errores de la actualización
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar la actividad: $e')),
      );
    }
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
        child: _buildTextField("Hora", timeController),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      String formattedTime = pickedTime.format(context);
      timeController.text = formattedTime;
    }
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
