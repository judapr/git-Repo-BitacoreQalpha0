import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';
import 'ActivityScreen.dart';
import 'LoginScreen.dart';
import 'AboutUsScreen.dart';
import 'RegisterScreen.dart';
import 'authGuard.dart';
import 'onboarding.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Usamos un StreamBuilder para cambiar dinámicamente entre pantallas
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras se verifica el estado de autenticación
            return const Center(child: CircularProgressIndicator());
          }

          // Si el usuario está autenticado, muestra la pantalla de actividades
          if (snapshot.hasData) {
            return const AuthGuard(child: ActivityScreen());
          }

          // Si el usuario no está autenticado, muestra el onboarding
          return const MyOnboarding(); // Siempre muestra el onboarding si no está autenticado.
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/about': (context) => const AboutUsScreen(),
        '/activity': (context) =>
            const AuthGuard(child: ActivityScreen()), // Protección
      },
    );
  }
}
