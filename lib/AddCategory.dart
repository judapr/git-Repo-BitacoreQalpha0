import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'MainAppBar.dart';

class AddCategory extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // Nodo de foco

  AddCategory({super.key});

  @override
  Widget build(BuildContext context) {
    // Solicitar el foco al construir el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    return Scaffold(
      appBar: const MainAppBar(),
      backgroundColor: const Color.fromARGB(255, 252, 252, 253),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flecha de regresar
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context); // Navega hacia atrás
              },
            ),
            const SizedBox(height: 10),
            // Título de la pantalla
            const Text(
              "Agregar Categoría",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Campo de texto "Nombre"
            const Text(
              "Nombre",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              focusNode: _focusNode, // Asignar el nodo de foco aquí
              decoration: InputDecoration(
                hintText: "Nombre",
                filled: true, // Activa el color de fondo
                fillColor: const Color.fromARGB(255, 208, 206, 206), // Fondo
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Colors.black, width: 2), // Borde negro al enfocar
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Botón "Guardar"
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () async {
                  final categoryName = _controller.text.trim();
                  if (categoryName.isEmpty) {
                    // Mostrar un mensaje si el campo está vacío
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            "El nombre de la categoría no puede estar vacío."),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  try {
                    // Obtener el usuario logueado
                    final user = FirebaseAuth.instance.currentUser;

                    if (user == null) {
                      // Si no hay usuario logueado, mostrar mensaje de error
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("No se encontró un usuario logueado."),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Guardar la categoría en Firestore
                    await FirebaseFirestore.instance
                        .collection("categories")
                        .add({
                      "name": categoryName,
                      "user_uid": user.uid, // Agregar el UID del usuario
                    });

                    // Mostrar un mensaje de éxito
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Categoría guardada exitosamente."),
                        backgroundColor: Colors.green,
                      ),
                    );

                    // Navegar hacia atrás
                    Navigator.pop(context);
                  } catch (e) {
                    // Mostrar un mensaje de error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error al guardar la categoría: $e"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 54, 54, 55),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8), // Bordes redondeados
                  ),
                ),
                child: const Text(
                  "Guardar",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
