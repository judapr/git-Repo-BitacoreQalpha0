import 'MainAppBar.dart';
import 'package:flutter/material.dart';

class AddActivity extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

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
                      "Sólo Nombre y Fecha son campos Obligatorios",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
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
      // Formato de hora
      String formattedTime = pickedTime.format(context);
      timeController.text = formattedTime;
    }
  }

  void _saveActivity(BuildContext context) {
    // Validar campos obligatorios
    if (titleController.text.isEmpty) {
      _showErrorSnackBar(context, 'El título es obligatorio.');
      return;
    }

    if (timeController.text.isEmpty && selectedDate == DateTime.now()) {
      _showErrorSnackBar(context, 'La fecha es obligatoria.');
      return;
    }

    // Aquí puedes agregar la lógica para guardar la actividad
    String title = titleController.text;
    String category = categoryController.text;
    String description = descriptionController.text;
    String time = timeController.text;
    String date =
        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"; // Formato de fecha
    String duration = durationController.text;

    // Mostrar un mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Actividad guardada: $title')),
    );

    // Limpiar los campos (opcional)
    titleController.clear();
    categoryController.clear();
    descriptionController.clear();
    timeController.clear();
    durationController.clear();
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
