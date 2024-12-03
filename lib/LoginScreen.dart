import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

// Función para iniciar sesión
  Future<void> signIn() async {
    try {
      // Inicia sesión con correo y contraseña
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Si la autenticación es exitosa, navega a la pantalla de actividades
      Navigator.pushReplacementNamed(context, '/activity');
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Error al iniciar sesión";

      // Verifica el tipo de error y ajusta el mensaje
      if (e.code == 'user-not-found') {
        errorMessage =
            "El usuario no fue encontrado. Verifica tu correo electrónico.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "El correo electrónico no es válido.";
      }

      // Muestra el mensaje de error correspondiente
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/BitacoreQLogo.png',
                    width: 120,
                    height: 120,
                  ),
                ),
                const SizedBox(height: 45),

                // Title
                const Text(
                  "Iniciar Sesión",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 30),

                // Correo electrónico o usuario
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 75.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "CORREO ELECTRÓNICO",
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "CONTRASEÑA",
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await signIn();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Iniciar sesión"),
                        ),
                      ),
                    ],
                  ),
                ),

                // Contraseña

                // Button to log in

                const SizedBox(height: 20),

                // Forgot password link
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Recuperar Contraseña",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Sign up link
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text(
                      "¿No tienes una cuenta? Registrarse",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
