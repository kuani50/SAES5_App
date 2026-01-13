import '../models/event_model.dart';
import '../models/course_model.dart';

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
      ]),
  EventModel(
      title: "Raid Urbain Caen",
      clubName: "ALBE Orientation", // J'ai corrigé pour correspondre au club ALBE
      location: "Caen, 14",
      date: "15 Nov 2025",
      status: "Inscriptions ouvertes",
      courses: [
        CourseModel(
          name: "Parcours Découverte",
          distance: "10km",
          teamSize: "Solo ou Duo",
          difficulty: "Débutant",
        ),
      ]),
  EventModel(
    title: "Course d'Orientation Nocturne",
    clubName: "Vikings 76",
    location: "Rouen, 76",
    date: "20 Dec",
    status: "Bientôt",
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
