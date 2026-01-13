import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/club_model.dart';
import '../models/event_model.dart';
import '../widgets/club_card.dart';
import '../widgets/header_home_page.dart';

class ClubScreen extends StatelessWidget {
  final List<EventModel> allEvents;

  const ClubScreen({super.key, required this.allEvents});

  @override
  Widget build(BuildContext context) {
    final List<ClubModel> dummyClubs = [
      ClubModel(
        name: "Orient'Express",
        location: "Caen, 14",
        description: "Club organisateur du Raid Suisse Normande.",
      ),
      ClubModel(
        name: "ALBE Orientation",
        location: "Elbeuf, 76",
        description: "Club de course d'orientation et de raid multisport en Seine-Maritime.",
      ),
      ClubModel(
        name: "Vikings 76",
        location: "Rouen, 76",
        description: "Association sportive dédiée à la course d'orientation.",
      ),
      ClubModel(
        name: "ASL Condé",
        location: "Condé-sur-Noireau, 14",
        description: "Pratique de la course d'orientation pour tous.",
      ),
    ];

    const double spacing = 24.0;

    return Scaffold(
      appBar: const HeaderHomePage(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Clubs Organisateurs",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: spacing),
            
            // --- MODIFICATION : Remplacement de GridView par Wrap ---
            Wrap(
              spacing: spacing, // Espace horizontal entre les cartes
              runSpacing: spacing, // Espace vertical entre les lignes
              children: dummyClubs.map((club) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    // Détermine le nombre de colonnes en fonction de la largeur
                    double screenWidth = MediaQuery.of(context).size.width;
                    int crossAxisCount = (screenWidth > 800) ? 2 : 1;

                    // Calcule la largeur de la carte pour qu'elle remplisse l'espace
                    double cardWidth = (constraints.maxWidth - (crossAxisCount - 1) * spacing) / crossAxisCount;
                    
                    return SizedBox(
                      width: cardWidth,
                      child: ClubCard(
                        club: club,
                        onViewRaids: () {
                          context.push('/club-details', extra: {
                            'club': club,
                            'events': allEvents,
                          });
                        },
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
