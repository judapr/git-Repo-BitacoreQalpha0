import 'package:bitacoreqalpha0/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOnboarding extends StatefulWidget {
  const MyOnboarding({super.key});

  @override
  State<MyOnboarding> createState() => _MyOnboardingState();
}

class _MyOnboardingState extends State<MyOnboarding> {
  final controller = PageController();

  bool isLastPage = false;
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              isLastPage = index == 2;
            });
          },
          children: [
            Container(
              color: const Color.fromARGB(255, 194, 196, 199),
              child: const Center(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Ajusta la columna al contenido
                  children: [
                    // Imagen ajustable
                    Image(
                      image: AssetImage(
                          'assets/images/agenda1.JPG'), // Ruta de la imagen en tu proyecto
                      height: 550, // Altura ajustable
                      width: 450, // Ancho ajustable
                      fit: BoxFit.cover, // Ajuste de la imagen
                    ),
                    SizedBox(
                        height: 16), // Espaciado entre la imagen y el texto
                    // Títulos
                    Text(
                      'Bienvenido a BitacoreQ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 3, 3, 3),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16), // Espaciado entre los textos
                    Text(
                      'Lleva un registro de tus actividades díarias de manera ordenada.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 53, 52, 52),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: const Color.fromARGB(255, 194, 196, 199),
              child: const Center(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Ajusta la columna al contenido
                  children: [
                    // Imagen ajustable
                    Image(
                      image: AssetImage(
                          'assets/images/agenda2.JPG'), // Ruta de la imagen en tu proyecto
                      height: 550, // Altura ajustable
                      width: 550, // Ancho ajustable
                      fit: BoxFit.cover, // Ajuste de la imagen
                    ),
                    SizedBox(
                        height: 16), // Espaciado entre la imagen y el texto
                    // Títulos
                    Text(
                      '',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16), // Espaciado entre los textos
                    Text(
                      'Registra tus actividades diarias, realiza un seguimiento por día, por hora y  por categoría.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 53, 52, 52),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: const Color.fromARGB(255, 194, 196, 199),
              child: Center(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Ajusta la columna al contenido
                  children: [
                    // Imagen ajustable
                    const Image(
                      image: AssetImage(
                          'assets/images/agenda2.JPG'), // Ruta de la imagen en tu proyecto
                      height: 450, // Altura ajustable
                      width: 400, // Ancho ajustable
                      fit: BoxFit.cover, // Ajuste de la imagen
                    ),
                    const SizedBox(
                        height: 16), // Espaciado entre la imagen y el texto
                    // Títulos
                    const Text(
                      'BitacoreQ',
                      style: TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16), // Espaciado entre los textos
                    const Text(
                      'Crea ahora tus reportes de actividades diarias.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 55, 53, 53),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16), // Espaciado entre los textos
                    const SizedBox(height: 16), // Espaciado entre los textos
                    // Botón
                    ElevatedButton(
                      onPressed: () async {
                        // Marca como visto el onboarding
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('hasSeenOnboarding', true);

                        // Después de completar el onboarding, redirige al login
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const LoginScreen()), // Redirige a la pantalla de Login
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 64, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Comenzar",
                        style: TextStyle(
                          fontSize: 18,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
        ),
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: () {
                  controller.jumpToPage(2);
                },
                child: const Text(
                  "Skip",
                  style: TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 9, 9, 9)),
                )),
            Center(
              child: SmoothPageIndicator(
                  effect: const WormEffect(
                      spacing: 15,
                      dotColor: Color.fromARGB(255, 140, 140, 140),
                      activeDotColor: Color.fromARGB(255, 0, 0, 0)),
                  controller: controller,
                  count: 3),
            ),
            TextButton(
                onPressed: () {
                  controller.nextPage(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut);
                },
                child: const Text(
                  "Next",
                  style: TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 9, 9, 9)),
                )),
          ],
        ),
      ),
    );
  }
}
