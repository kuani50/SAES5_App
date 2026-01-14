import '../models/event_model.dart';
import '../models/course_model.dart';

final List<EventModel> allEvents = [
  EventModel(
    title: "Raid Suisse Normande",
    clubName: "Le Club De Caen",
    location: "Clécy, 14",
    date: "12 Octobre 2025",
    status: "Inscription ouverte",
    raidState: "Raid à venir",
    remainingTeams: 5,
    courses: [
      CourseModel(
        name: "Parcours Aventure",
        distance: "45km",
        teamSize: "Équipe de 2 à 4",
        difficulty: "Expert",
      ),
    ],
  ),
  EventModel(
    title: "Raid Urbain Caen",
    clubName: "ALBE Orientation",
    location: "Caen, 14",
    date: "15 Nov 2025",
    status: "Inscription ouverte",
    raidState: "Raid à venir",
    courses: [
      CourseModel(
        name: "Parcours Découverte",
        distance: "10km",
        teamSize: "Solo ou Duo",
        difficulty: "Débutant",
      ),
    ],
  ),
  EventModel(
    title: "Course d'Orientation Nocturne",
    clubName: "Vikings 76",
    location: "Rouen, 76",
    date: "20 Dec",
    status: "À partir du 01/12",
    raidState: "Raid à venir",
  ),
  EventModel(
    title: "Entraînement Forêt",
    clubName: "ASL Condé",
    location: "Condé-sur-Noireau",
    date: "05 Fév",
    status: "Complet",
    raidState: "En cours",
  ),
  EventModel(
    title: "Challenge Orientation 14",
    clubName: "CDCO 14",
    location: "Falaise, 14",
    date: "12 Mars",
    status: "Complet",
    raidState: "Terminé",
  ),
];
