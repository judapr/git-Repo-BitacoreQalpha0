import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'ActivityScreen.dart';
import 'LoginScreen.dart';
import 'RegisterScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Escucha los cambios en el estado de autenticación
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    runApp(MyApp(
        user: user)); // Pasa el usuario autenticado (si existe) a la aplicación
  });
}

class MyApp extends StatelessWidget {
  final User? user;

  const MyApp({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: user == null
          ? '/login'
          : '/activity', // Redirige según el estado de autenticación
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/activity': (context) => const ActivityScreen(),
      },
    );
  }
}
