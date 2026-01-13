import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/event_model.dart';
import 'event_card.dart';

class EventListSection extends StatelessWidget {
  final List<EventModel> events;

  const EventListSection({
    super.key,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    // Détection de l'orientation
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    // 2 colonnes en Portrait, 3 en Paysage
    final crossAxisCount = isLandscape ? 3 : 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Tous les événements',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
        // Utilisation d'une Grille au lieu d'une Liste
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1.20, // Je remets 0.75 pour avoir de la hauteur pour le contenu
            crossAxisSpacing: 16, // Espace horizontal entre les cartes
            mainAxisSpacing: 16,  // Espace vertical entre les cartes
          ),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return EventCard(
              event: event,
              onTap: () {
                context.push('/details', extra: event);
              },
            );
          },
        ),
      ],
    );
  }
}
