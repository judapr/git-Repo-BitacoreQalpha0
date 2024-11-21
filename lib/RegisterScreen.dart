import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  // final TextEditingController usernameController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Ejemplo de guardar un nuevo usuario en la base de datos
  Future<void> addUser(
      String name, String lastname, String email, String uid) async {
    // Usamos el UID del usuario como el ID del documento en Firestore
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'lastname': lastname,
      'email': email,
    });
  }

  // Función para registrar al usuario
  Future<void> registerUser() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Las contraseñas no coinciden.")),
      );
      return;
    }

    try {
      // Registra al usuario con correo y contraseña
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

// Obtiene el UID del usuario
      String uid = userCredential.user?.uid ?? '';

      // Crear un documento en Firestore en la colección 'users'
      await addUser(
        //usernameController.text.trim(),
        firstNameController.text.trim(),
        lastNameController.text.trim(),
        emailController.text.trim(),
        uid,
      );
      /*
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'name': firstNameController.text.trim(),
        'lastname': lastNameController.text.trim(),
        'email': emailController.text.trim(),
      });
*/
      // Si la autenticación es exitosa, muestra el diálogo de éxito
      _showSuccessDialog();
    } on FirebaseAuthException catch (e) {
      // Muestra el mensaje de error correspondiente
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Error al registrarse")),
      );
    }
  }

  // Función para mostrar el popup de registro exitoso
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Impide que se cierre al tocar fuera del diálogo
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¡Registro Exitoso!'),
          content: const Text(
              'Tu cuenta ha sido creada con éxito. Ahora puedes iniciar sesión.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, '/login'); // Redirige al login
              },
              child: const Text('Ir a Iniciar Sesión'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40), // Espaciado superior
              Align(
                alignment: Alignment.topLeft, // Alinea arriba a la izquierda
                child: Image.asset(
                  'assets/login/logoBQLogin.jpg',
                  width: 120,
                  height: 120,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Registrarse',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60.0),
                child: Column(
                  children: [
                    // Campos de texto para el formulario
                    TextFormField(
                      controller: firstNameController,
                      decoration: InputDecoration(
                        hintText: 'Nombre(s)',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                        hintText: 'Apellidos',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    /*
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        hintText: 'Nombre de Usuario',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),*/
                    const SizedBox(height: 55),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Correo electrónico',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: 'Contraseña',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        hintText: 'Confirmar Contraseña',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 55),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            registerUser, // Llamada a la función de registro
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Registrarse"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text(
                    "¿Ya tienes una cuenta? Inicia Sesión",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
