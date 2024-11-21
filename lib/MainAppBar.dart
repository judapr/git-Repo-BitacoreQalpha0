import 'package:flutter/material.dart';
import 'AddActivity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String buttonText; // Texto del botón
  final bool showAddActivityButton; // Controla la visibilidad del botón

  const MainAppBar({
    super.key,
    this.buttonText = "Agregar Actividad",
    this.showAddActivityButton = true, // Por defecto, el botón es visible
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: Colors.white,
          elevation: 0, // Sin sombra predeterminada
          leading: IconButton(
            onPressed: () {}, // Acción del menú lateral
            icon: const Icon(Icons.menu),
          ),
          title: const Text(' '),
          actions: [
            IconButton(
              onPressed: () {}, // Acción de búsqueda
              icon: const Icon(Icons.search),
            ),
            if (showAddActivityButton) // Muestra el botón solo si showButton es verdadero
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddActivity()),
                  );
                },
                label: Text(buttonText), // Usa el texto del botón
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 14,
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.grey[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            IconButton(
              onPressed: () {
                // Cierra la sesión
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              icon: const Icon(Icons.exit_to_app),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 4);
}