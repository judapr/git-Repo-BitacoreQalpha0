import 'MainAppBar.dart';
import 'package:flutter/material.dart';
import 'ActivitySection.dart';
import 'ActivityCard.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MainAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ActivitySection(
                title: "Hoy",
                activities: [
                  ActivityCard(
                    title: "Actividad nombrelargo 1",
                    category: "categoría1",
                    description:
                        "Lorem ipsum dolor sit amet, consectetur adipiscing...",
                    time: "13:06",
                    date: DateTime(2024, 2, 10),
                    duration: "4 horas",
                  ),
                  ActivityCard(
                    title: "Act2",
                    category: "categoría1",
                    description:
                        "Lorem ipsum dolor sit amet, consectetur adipiscing...",
                    time: "11:08",
                    date: DateTime(2024, 2, 10),
                    duration: "4 horas",
                  ),
                ],
              ),
              ActivitySection(
                title: "30 ago",
                activities: [
                  ActivityCard(
                    title: "Actividad nombrelargo 2",
                    category: "categoría larga",
                    description:
                        "Lorem ipsum dolor sit amet, consectetur adipiscing...",
                    time: "22:04",
                    date: DateTime(2024, 2, 10),
                    duration: "4 horas",
                  ),
                  ActivityCard(
                    title: "Act3",
                    category: "categoría2",
                    description:
                        "Lorem ipsum dolor sit amet, consectetur adipiscing...",
                    time: "09:12",
                    date: DateTime(2024, 2, 10),
                    duration: "4 horas",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
