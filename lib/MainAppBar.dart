import 'package:flutter/material.dart';
import 'AddActivity.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String buttonText; // Texto del botón
  final bool showAddActivityButton; // Controla la visibilidad del botón
  final bool showlupa;

  const MainAppBar({
    super.key,
    this.buttonText = "Agregar Actividad",
    this.showAddActivityButton = true, // Por defecto, el botón es visible
    this.showlupa = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0, // Sin sombra predeterminada
      iconTheme:
          const IconThemeData(color: Colors.black), // Para el ícono del menú
      title: const Text(
        ' ',
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        // Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //children: [
        const Spacer(
          flex: 1,
        ),
        // const Icon(Icons.hexagon_outlined),
        const Spacer(
          flex: 5,
        ),
        if (showlupa)
          IconButton(
            onPressed: () {}, // Acción de búsqueda
            icon: const Icon(Icons.search, color: Colors.black),
          ),
        if (showAddActivityButton) // Muestra el botón solo si showButton es verdadero
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
            child: ElevatedButton.icon(
              onPressed: () async {
                // Navegar a AddActivity y esperar su resultado
                bool? result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddActivity(),
                  ),
                );

                // Si el resultado es true, actualizar las actividades en ActivityScreen
                if (result == true) {
                  // Refrescar la lista de actividades (según tu implementación)
                }
              },
              label: Text(buttonText), // Usa el texto del botón
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 14),
                foregroundColor: Colors.white,
                backgroundColor: Colors.grey[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              icon: const Icon(Icons.add),
            ),
          ),
        // ],
        //),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
