import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import '../models/course_model.dart'; // Import CourseModel
import '../models/event_model.dart';
import '../widgets/event_list_section.dart';
import '../widgets/header_home_page.dart';
import '../widgets/hero_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Données factices complètes
    final List<EventModel> dummyEvents = [
      EventModel(
        title: "Raid Suisse Normande",
        clubName: "Le Club De Caen",
        location: "Clécy, 14",
        date: "12 Octobre 2025",
        status: "Inscriptions ouvertes",
        courses: [
          CourseModel(
            name: "Parcours Aventure",
            distance: "45km",
            teamSize: "Équipe de 2 à 4",
            difficulty: "Expert",
          ),
           CourseModel(
            name: "Parcours Sportif",
            distance: "25km",
            teamSize: "Équipe de 2",
            difficulty: "Confirmé",
          ),
        ]
      ),
      EventModel(
        title: "Raid Urbain Caen",
        clubName: "Club ALBE Orientation",
        location: "Caen, 14",
        date: "15 Nov",
        status: "Inscriptions ouvertes",
        courses: [
           CourseModel(
            name: "Parcours Découverte",
            distance: "10km",
            teamSize: "Solo ou Duo",
            difficulty: "Débutant",
          ),
        ]
      ),
      EventModel(
        title: "Course d'Orientation Nocturne",
        clubName: "Vikings 76",
        location: "Rouen, 76",
        date: "20 Dec",
        status: "Complet",
      ),
      EventModel(
        title: "Trail des Forêts",
        clubName: "ASL Condé",
        location: "Condé-sur-Noireau",
        date: "05 Fév",
        status: "Inscriptions ouvertes",
      ),
      EventModel(
        title: "Challenge Orientation 14",
        clubName: "CDCO 14",
        location: "Falaise, 14",
        date: "12 Mars",
        status: "Bientôt",
      ),
      EventModel(
        title: "Raid des Plages",
        clubName: "Club Orientation Mer",
        location: "Ouistreham, 14",
        date: "25 Juin",
        status: "Fermé",
      ),
    ];

    return Scaffold(
      appBar: const HeaderHomePage(
        isLoggedIn: false, 
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeroBanner(
              title: 'Prochain défi : Raid Suisse Normande',
              onTap: () {
                 // Navigation vers le premier événement de la liste (Raid Suisse Normande)
                 context.push('/details', extra: dummyEvents[0]);
              },
            ),
            const SizedBox(height: 16),
            // On doit passer le contexte ou un callback à EventListSection pour gérer la navigation
            // Pour l'instant, je vais modifier EventListSection pour qu'il accepte un callback générique ou je gère la navigation ici si je passe le builder.
            // Simplifions : EventListSection prend la liste et gère l'affichage. 
            // Mais EventListSection a besoin de savoir comment naviguer.
            // Le plus propre est de passer la fonction de navigation.
            _EventListSectionWrapper(events: dummyEvents),
            const SizedBox(height: 40), 
          ],
        ),
      ),
    );
  }
}

// Petit wrapper local pour gérer la navigation proprement sans toucher à EventListSection si on ne veut pas modifier sa signature tout de suite
// Ou mieux, modifions EventListSection pour qu'il utilise le context pour naviguer ou accepte un callback.
// Comme EventCard a déjà un onTap, on peut le gérer dans le builder de EventListSection.
// Attendez, EventListSection utilise un builder interne. Je dois le modifier pour qu'il gère la navigation.
// Je vais plutôt réécrire l'appel ici pour être clair.
class _EventListSectionWrapper extends StatelessWidget {
  final List<EventModel> events;
  const _EventListSectionWrapper({required this.events});

  @override
  Widget build(BuildContext context) {
    // Je réutilise le widget EventListSection mais je dois m'assurer qu'il gère le onTap.
    // Regardons le code de EventListSection... il a un TODO Navigation.
    // Je vais devoir modifier EventListSection pour qu'il soit interactif.
    return EventListSection(events: events);
  }
}
