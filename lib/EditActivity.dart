import 'MainAppBar.dart';
import 'package:flutter/material.dart';

class EditActivity extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController categoryController;
  final TextEditingController descriptionController;
  final TextEditingController timeController;
  DateTime selectedDate;
  final TextEditingController durationController;

  EditActivity({
    super.key,
    required String title,
    required String category,
    required String description,
    required String time,
    required DateTime date,
    required String duration,
  })  : titleController = TextEditingController(text: title),
        categoryController = TextEditingController(text: category),
        descriptionController = TextEditingController(text: description),
        timeController = TextEditingController(text: time),
        durationController = TextEditingController(text: duration),
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
                  _buildTextField("Duración", durationController),
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
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildImagePlaceholder(),
                      const SizedBox(width: 8),
                    ],
                  ),
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
                      // Aquí irá la funcionalidad de guardar cambios
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
