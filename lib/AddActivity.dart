//TODO: hacer que la lista deslizable tenga una opción para agregar una categoría y la envíe a la página de guardar actividad
//TODO: mostrar las actividades guardadas
import 'MainAppBar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddActivity extends StatefulWidget {
  const AddActivity({super.key});

  @override
  _AddActivityState createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String?
      selectedCategoryId; // Para almacenar el ID de la categoría seleccionada
  List<Map<String, dynamic>> categories = []; // Para almacenar las categorías
  bool isLoading =
      true; // Para mostrar un cargador mientras obtenemos las categorías

  @override
  void initState() {
    super.initState();
    _loadCategories(); // Llamar a esta función para cargar las categorías
  }

  // Cargar categorías desde Firestore
  void _loadCategories() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("categories").get();

      setState(() {
        categories = snapshot.docs
            .map((doc) => {
                  "id": doc.id, // Guardamos el ID de la categoría
                  "name": doc["name"], // Guardamos el nombre de la categoría
                })
            .toList();
        isLoading =
            false; // Deja de mostrar el cargador cuando se termine de cargar
      });
    } catch (e) {
      _showErrorSnackBar(context, 'Error al cargar las categorías: $e');
    }
  }

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
                    _buildCategoryDropdown(), // Agregar el Dropdown para la categoría
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
        ));
  }

  // Widget para mostrar el Dropdown de categorías
  Widget _buildCategoryDropdown() {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text("Seleccionar Categoría"),
                value: selectedCategoryId, // Usamos el ID de la categoría aquí
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategoryId = newValue; // Guardamos el ID
                  });
                },
                items: categories.map<DropdownMenuItem<String>>((category) {
                  return DropdownMenuItem<String>(
                    value: category["id"], // Usamos el ID de la categoría
                    child: Text(category["name"]), // Mostramos el nombre
                  );
                }).toList(),
              ),
            ),
          );
  }

  // Widget de campo de texto
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

  // Método para seleccionar la fecha
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
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // Método para seleccionar la hora
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
      String formattedTime = pickedTime.format(context);
      setState(() {
        timeController.text = formattedTime;
      });
    }
  }

  // Guardar la actividad en Firestore
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

    if (selectedCategoryId == null) {
      _showErrorSnackBar(context, 'La categoría es obligatoria.');
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

      DateTime finalDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        timeOfDay.hour,
        timeOfDay.minute,
      );

      // Guardar en Firestore
      FirebaseFirestore.instance.collection("activities").add({
        "title": titleController.text,
        "description": descriptionController.text,
        "notes": notesController.text,
        "category_id": selectedCategoryId,
        "date_time": finalDateTime,
        "created_at": FieldValue.serverTimestamp(),
        "user_id": FirebaseAuth.instance.currentUser!.uid,
      });

      Navigator.pop(context); // Volver a la pantalla de actividades

      // Mostrar mensaje de éxito
      _showSuccessSnackBar(context, 'Actividad guardada con éxito.');
    } catch (e) {
      _showErrorSnackBar(context, 'Error al guardar la actividad: $e');
    }
  }

  // Mostrar mensaje de error
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Mostrar mensaje de éxito
  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  // Placeholder de imagen
  Widget _buildImagePlaceholder() {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.grey[300],
      ),
      child: const Icon(
        Icons.add_a_photo,
        size: 50,
        color: Colors.grey,
      ),
    );
  }
}
